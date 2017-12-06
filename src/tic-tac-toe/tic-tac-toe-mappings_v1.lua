local previous_peer = nil

MARS.onConnect = function (p)
  local interfaces = p:getInterfaces()
  local isPlayer = false

  for i, _ in pairs (interfaces) do
    if i == 'PLAYER' then
      isPlayer = true
      break
    end
  end

  if isPlayer then
    if not previous_peer then
      previous_peer = p
    else
      map (p, 'MY_MOVE', previous_peer, 'OPPONENT_MOVE')
      map (previous_peer, 'MY_MOVE', p, 'OPPONENT_MOVE')

      previous_peer = nil
    end
  end
end
