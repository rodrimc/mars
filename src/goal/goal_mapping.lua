local previous = nil

MARS.onConnect = function (p)
  if previous then
    map (p,        'MY_MOVE', previous, 'OPPONENT_MOVE')
    map (previous, 'MY_MOVE', p,        'OPPONENT_MOVE')
    previous = nil
  else
    previous = p
  end
end
