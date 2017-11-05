
if not arg[1] then
  print ('Error: no input source specified')
  return
end

if not arg[2] then
  print ('Error: no prog file specified')
  return
end

local CODE_TEMPLATE =
  'code/await Emit_{#1}_Event ({#2}) -> none\ndo\n' ..
    '\tawait async ({#3}) do\n'                     ..
    '\t\temit {#4} ({#5});\n'                       ..
    '\tend\n'                                       ..
  'end'

local f = io.open (arg[1], 'r')
local maestro_src = f:read ('*all')
f:close()

lines = io.lines (arg[2])
inputs_evt = {}

for line in io.lines (arg[2]) do
  line = line:gsub("^%s*(.-)%s*$", "%1")
  if line:sub (1, 5) == 'input' then
    table.insert (inputs_evt, {})
    inputs_evt[#inputs_evt] =
      {
        line = line,
        args = {},
        evt = '',
        emitter = ''
      }
  end
end

local TO_GEN = ''

for i=1, #inputs_evt do
  local input = inputs_evt[i].line
  input = input:sub (5 + 1):gsub("^%s*(.-)%s*$", "%1")

  local args = input:match ("%((.-)%)")
  local evt  = input:match ("%).-$"):sub(2):gsub("^%s*(.-)%s*;$", "%1")
  local code_name = evt:lower():gsub('_.', string.upper):gsub('^.', string.upper)
  local code = string.gsub (CODE_TEMPLATE, '{#1}', code_name)
  local params = ''

  if args == 'none' then
    params = args
  else
    local k = 1
    for arg in args:gmatch('([^,]+)') do
      arg = arg:gsub("^%s*(.-)%s*$", "%1")
      table.insert(inputs_evt[i].args, arg)
      params = params .. 'var ' .. arg .. ' arg' .. k .. ', '
      k = k + 1
    end
    params = params:sub (1, -3)
  end

  code = code:gsub ('{#2}', params)

  params = params:gsub ('(var .-).- ,-', '')
  if params == 'none' then
    params = '_'
  end

  code = code:gsub ('{#3}', params)
  code = code:gsub ('{#4}', evt)

  if params == '_' then
    params = ''
  end
  code = code:gsub ('{#5}', params)

  inputs_evt[i].evt = evt
  inputs_evt[i].emitter = 'Emit_' .. code_name .. '_Event';

  TO_GEN = TO_GEN .. code .. '\n'
end

CODE_TEMPLATE = '\n'                                          ..
  'code/await Handle_Mapping (var _char&& mapping) -> none\n' ..
  'do\n'                                                      ..
  '{#1}\n'                                                    ..
  'end'

code = ''

local cond = '_strcmp(mapping, "{#1}") == 0'
for i = 1, #inputs_evt do
  input = inputs_evt[i]
  local statement
  if i == 1 then
    statement = '\tif'
  else
    statement = '\telse/if'
  end

  code = code .. statement .. ' ' .. cond:gsub('{#1}', input.evt) .. ' then\n'

  local body = ''
  local params = ''
  for j = 1, #input.args do
    body = body .. '\t\tvar ' .. input.args[j] .. ' arg' .. j .. ' = _;\n'
    params = params .. 'arg' .. j .. ', '
  end
  params = params:sub (1, -3)
  body = body .. '\t\t' .. 'await ' .. input.emitter .. '(' .. params .. ');\n'
  code = code .. body
end

code = code .. '\tend'

TO_GEN = TO_GEN .. CODE_TEMPLATE:gsub('{#1}', code) .. '\n'

maestro_src = maestro_src:gsub ('__COMPILED_EVTS__', TO_GEN)

f = io.open (arg[1], 'w')
  f:write (maestro_src)
f:close()
