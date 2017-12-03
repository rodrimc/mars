local peers = {}

Peer = {
  id = -1,
  ip = -1,
  port = -1
}

function Peer:new (o)
  o = o or {}
  o.interfaces = {}
  o.__mapping = {}

  setmetatable (o, self)
  self.__index = self
  return o
end

function Peer:addInterface (name, events)
  self.interfaces[name] = events
end

function Peer:getInterfaces ()
  return self.interfaces
end

function Peer:getInterfaceOfEvent (evt)
  for name,args in pairs (self.interfaces) do
    if _hasEvent (evt, args.inputs) or _hasEvent (evt, args.outputs) then
      return name
    end
  end
  return nil
end

function _hasEvent (evt, t)
  local has = false
  for k,_ in pairs (t) do
    has = has or k == evt
  end
  return has
end

return Peer
