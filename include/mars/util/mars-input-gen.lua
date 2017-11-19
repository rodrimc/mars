
if not arg[1] then
  print ('Error: no interfaces file specified')
  return
end

if not arg[2] then
  print ('Error: no type specified')
  return
end

local OUTPUT = nil

if arg[3] then
  OUTPUT = arg[3]
end

local TYPE = arg[2]

local f = io.open (arg[1], 'r')
local defs = f:read ('*all')
f:close()

local CODE_TEMPLATE =
  'code/await Emit_{#1}_Event ({#2}) -> none\ndo\n' ..
    '\tawait async ({#3}) do\n'                     ..
    '\t\temit {#4} ({#5});\n'                       ..
    '\tend\n'                                       ..
  'end'

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
  if not T[TYPE]  then
    error ('Unknown type') 
  end

  local gen = ''

  for k,v in pairs (T) do
    if k == TYPE then
      for _,intable in pairs (v.inputs) do
        for evt, args in pairs (intable) do
          local code = CODE_TEMPLATE:gsub ('{#1}', capitalize_first(evt))
          local paramdecl = ''
          for i=1, #args do
            paramdecl = paramdecl .. decl_param (args[i], i) .. ','
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
        end
      end
    end
  end

  if OUTPUT then
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