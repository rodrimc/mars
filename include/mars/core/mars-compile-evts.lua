
if not arg[1] then
  print ('Error: no input source specified')
  return
end

if not arg[2] then
  print ('Error: no prog file specified')
  return
end

CODE_TEMPLATE =
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
    table.insert (inputs_evt, line)
  end
end

local TO_GEN = ''
for i=1, #inputs_evt do
  local input = inputs_evt[i]
  input = input:sub (5 + 1):gsub("^%s*(.-)%s*$", "%1")

  local args = input:match ("%((.-)%)")
  local evt  = input:match ("%).-$"):sub(2):gsub("^%s*(.-)%s*;$", "%1")

  code_name = evt:lower():gsub('_.', string.upper):gsub('^.', string.upper)

  local code = string.gsub (CODE_TEMPLATE, '{#1}', code_name)

  local params = ''
  if args == 'none' then
    params = args
  else
    local i = 1
    for arg in args:gmatch('([^,]+)') do
      arg = arg:gsub("^%s*(.-)%s*$", "%1")
      params = params .. 'var ' .. arg .. ' arg' .. i .. ', '
      i = i + 1
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

  TO_GEN = TO_GEN .. code .. '\n'
end


maestro_src = maestro_src:gsub ('__COMPILED_EVTS__', TO_GEN)

f = io.open (arg[1], 'w')
  f:write (maestro_src)
f:close()
