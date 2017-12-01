MARS = {
  onConnect = nil,
  onDisconnect = nil,
  __private = {
    peers = {},
    interfaces = nil,
    connectedCallback = nil
  }
}

function interfaces (T)
  MARS.__private.interfaces = type(T) == 'table' and T or nil
end

function map (table)
  print ('mapping')
end

function mapping (M)
  MARS.__private.interfaces = type(M) == 'table' and M or nil
end

function get_mapping (evt)
  local map = {}
  -- if type(SERVER.mapping) == 'table' then
  --   for _,v in pairs (SERVER.mapping) do
  --     if v[1] == evt then
  --       table.insert(map, v)
  --     end
  --   end
  -- end
  return map
end
