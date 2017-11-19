
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

f = io.open (arg[2], 'r')
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
'do\n'                                                    ..
'{#1}'                                                    ..
'end'

local HANDLER_CHECK_TEMPLATE =
'\tif _strcmp(&&evt[0],"{#1}") == 0 then\n'               ..
  '\t\t{#2}\n'                                            ..
  '\t\tawait Emit_{#3}_Event ({#4});\n'                   ..
'\tend\n'

local CODE_TEMPLATE =
  'code/await Emit_{#1}_Event ({#2}) -> none\ndo\n'       ..
    '\tawait async ({#3}) do\n'                           ..
    '\t\temit {#4} ({#5});\n'                             ..
    '\tend\n'                                             ..
  'end\n'

function capitalize_first (str)
  return str:lower():gsub('_.', string.upper):gsub('^.', string.upper)
end

function decl_param (type_, index)
  return 'var ' .. type_ .. ' param' .. index
end

function get_vars_from_params (params)
  if params == 'none' then
    return '_'
  else
    return params:gsub('var (.-) ', '')
  end
end

function get_emit_args_from_vars (args)
  if args == '_' then
    return ''
  else
    return args
  end
end

function interface (T)
  local gen = ''
  local checks = ''

  for k,v in pairs (T) do
    for _,intable in pairs (v.inputs) do
      for evt, args in pairs (intable) do
        if srcinputs[evt] == true then
          local code = CODE_TEMPLATE:gsub ('{#0}', evt)
                                    :gsub ('{#1}', capitalize_first(evt))
          local varcheckdecl = ''
          local paramdecl = ''
          for i=1, #args do
            paramdecl = paramdecl .. decl_param (args[i], i) .. ','
            varcheckdecl = varcheckdecl .. decl_param (args[i], i) ..
                            ' = [[ CLIENT.remote.args[' .. i .. '] ]];\n\t\t'
          end

          if paramdecl == '' then
            paramdecl = 'none'
          else
            paramdecl = paramdecl:sub(1, -2)
          end

          code = code:gsub('{#2}', paramdecl)

          local async_args = get_vars_from_params (paramdecl)
          local emit_args  = get_emit_args_from_vars (async_args)
          code = code:gsub('{#3}', async_args)
                     :gsub('{#4}', evt:upper())
                     :gsub('{#5}', emit_args)

          gen = gen .. code .. '\n\n'

          local check = HANDLER_CHECK_TEMPLATE:gsub ('{#1}', evt)
                                              :gsub ('{#2}', varcheckdecl)
                                              :gsub ('{#3}', capitalize_first(evt))
                                              :gsub ('{#4}', emit_args)
          checks = checks .. check .. '\n'
        end
      end
    end
  end

  gen = gen .. HANDLER_TEMPLATE:gsub('{#1}', checks)

  if arg[3] then
    f = io.open (arg[3], 'w')
    f:write (gen)
    f:close()
  end
end

local success, err = pcall(load (defs))
if  success then
  print ('Output generated!')
else
  print ('[error:] ' .. tostring (err))
end
