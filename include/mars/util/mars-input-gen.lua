
if not arg[1] then
  print ('Error: no interfaces file specified')
  return
end

if not arg[2] then
  print ('Error: no source file specified')
  return
end

local f = io.open (arg[1], 'r')
local defs = f:read ('*all')
f:close()

f = io.open (arg[3], 'r')
local src = f:read ('*all')
f:close()

local srcinputs = {}
for line in io.lines (arg[2]) do
  line = line:gsub("^%s*(.-)%s*$", "%1")
  if line:sub (1, 5) == 'input' then
    local evt = line:match ("%).-$"):sub(2):gsub("^%s*(.-)%s*;$", "%1");
    srcinputs[evt] = true
  end
end

local HANDLER_TEMPLATE =
'code/await Emit_Input_Event (var& [] byte evt) -> none\n' ..
'throws Exception.Lua\n'                                   ..
'do\n'                                                     ..
'{#1}'                                                     ..
'end'

local HANDLER_CHECK_TEMPLATE =
'\tif _strcmp(&&evt[0],"{#1}") == 0 then\n'                ..
  '\t\t{#2}\n'                                             ..
  '\t\t_emit_{#3}_event ({#4});\n'                         ..
'\tend\n'

local CODE_TEMPLATE =
  '\tvoid emit_{#1}_event ({#2})\n'                        ..
  '\t{\n'                                                  ..
  '\t\ttceu_input_{#3} p = {{#4}};\n'                      ..
  '\t\tceu_input (CEU_INPUT_{#3}, &p);\n'                  ..
  '\t}'

function capitalize_first (str)
  return str:lower():gsub('_.', string.upper):gsub('^.', string.upper)
end

function decl_param (type_, index)
  return type_ .. ' param' .. index
end

function get_vars_from_params (params)
  local toReturn = ''
  local tmp = 0
  for token in params:gmatch ('(.-) ') do
    tmp = tmp + 1
    if tmp % 2 == 0 then
      toReturn = toReturn .. token
    end
  end
  return toReturn
end

function get_emit_args_from_vars (args)
  if args == '_' then
    return ''
  else
    return args
  end
end

function interfaces (T)
  local gen = ''
  local checks = ''
  local decl_funcs = ''

  for name, t in pairs (T) do
    for evt, args in pairs (t.inputs) do
      if srcinputs[evt] == true then
        local code = CODE_TEMPLATE:gsub ('{#1}', evt:lower())
        decl_funcs = decl_funcs .. '\t_emit_' .. evt:lower() .. '_event,\n'

        local varcheckdecl = ''
        local paramdecl = ''
        for i=1, #args do
          paramdecl = paramdecl .. decl_param (args[i], i) .. ', '
          varcheckdecl = varcheckdecl .. 'var ' .. decl_param (args[i], i) ..
            ' = [[ MARS.message.args[' .. i .. '] ]];\n\t\t'
        end

        if paramdecl ~= '' then
          paramdecl = paramdecl:sub(1, -3) .. ' '
        end

        local evt_args  = get_vars_from_params (paramdecl)
        local emit_args = paramdecl

        code = code:gsub('{#2}', paramdecl)
                   :gsub('{#3}', evt:upper())
                   :gsub('{#4}', evt_args)

        gen = gen .. code .. '\n\n'

        local check = HANDLER_CHECK_TEMPLATE:gsub ('{#1}', evt)
                                            :gsub ('{#2}', varcheckdecl)
                                            :gsub ('{#3}', evt:lower())
                                            :gsub ('{#4}', evt_args)
        checks = checks .. check .. '\n'
      end
    end
  end

  if decl_funcs ~= '' then
    decl_funcs = 'native/nohold\n' .. decl_funcs .. '\n;'
  end

  src = src:gsub ('__DECL_EMIT_FUNCTIONS__', decl_funcs)
  src = src:gsub ('__EMIT_FUNCTIONS__', gen)
  src = src:gsub ('__INTERFACES__', defs:gsub ('interfaces', 'MARS.interfaces = '))
  src = src:gsub ('__INPUTS__', HANDLER_TEMPLATE:gsub('{#1}', checks))

  if arg[3] then
    f = io.open (arg[3], 'w')
    f:write (src)
    f:close()
  end
end

local success, err = pcall(load (defs))
if  success then
  print ('Output generated!')
else
  print ('[error:] ' .. tostring (err))
end
