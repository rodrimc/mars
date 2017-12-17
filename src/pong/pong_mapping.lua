local player1 = nil
local amount = 10

function t (player, dir)
  return {[1] = player, [2] = dir == 1 and -amount or amount }
end

MARS.onConnect = function (p, player, dir)
  map (p, 'MOVE', p, 'UPDATE_POS', 
    function (_, player, dir) return true, t (player, dir) end)

  if player1 then
    map (player1, 'MOVE', p, 'UPDATE_POS', 
      function (_, player, dir) return true, t (player, dir) end)

    map (p, 'MOVE', player1, 'UPDATE_POS', 
      function (_, player, dir) return true, t (player, dir) end)
    
    player1 = nil
  else
    player1 = p
  end
end
