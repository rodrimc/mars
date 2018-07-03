local peers = {}
local together = true

function handler (from, to, args)
  local ok
  if together then
    ok = true
  else
    ok = from == to
  end

  return ok, {args}
end


MARS.onConnect = function (p)
  table.insert(peers, p)
  map (p, 'SET_VID_POS', p, 'SEEK', handler)

  for _,instance in ipairs(peers) do
    if instance ~= p then
      map (p, 'SET_VID_POS', instance, 'SEEK', handler)
      map (instance, 'SET_VID_POS', p, 'SEEK', handler)
    end
  end
end

MARS.onOutputEvent = function (from, evt, args)
  if (evt == 'TOGGLE_TOGETHERNESS') then
    together = args[1] == 1
  end
end
