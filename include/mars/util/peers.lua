local peers = {}

Peer = {
  ip = -1,
  port = -1
}

function Peer:new (o)
  o = o or {}
  o.interfaces = {}
  o.outputs = {}
  o.__handler = nil

  setmetatable (o, self)
  self.__index = self
  return o
end

function Peer:addInterface (interface, index)
  if type(interface) == 'string' then
    table.insert (self.interfaces, interface)
  end
end

function Peer:addOutput (evt)
  if type(evt) == 'string' then
    table.insert (self.outputs, evt)
  end
end

function Peer:getOutputs ()
  return self.outputs
end

function Peer:getInterfaces ()
  return self.interfaces
end

return Peer
