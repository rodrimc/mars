local peers = {}

Peer = {}

Peer.ip = -1 
Peer.port = -1 
Peer.interfaces = {}
Peer.outputs = {}

function Peer:new (o)
  o = o or {}
  setmetatable (o, self)
  self.__index = self
  return o
end

function Peer:addInterface (interface, index)
  if type(interface) == 'string' and type(index) == 'number' then
    table.insert (self.interfaces, {interface = interface, index = index})
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

peers.Peer = Peer

return peers
