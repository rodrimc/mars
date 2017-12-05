tvs = {}
controls = {}

function link_control_tv (control, tv)
  map (control, 'RETURN_', tv, 'TURN_ON')
  map (control, 'ESC',     tv, 'TURN_OFF')
  map (control, 'P',       tv, 'PLAY')
  map (control, 'SPACE',   tv, 'PAUSE')
  map (control, 'RIGHT',   tv, 'SEEK_FORWARD')
  map (control, 'LEFT',    tv, 'SEEK_BACKWARD')
  map (control, 'UP',      tv, 'VOLUME_UP')
  map (control, 'DOWN',    tv, 'VOLUME_DOWN')
end


MARS.onConnect = function (p)
  local interfaces = p:getInterfaces()
  local isControl = false
  local isTv = false

  print (serialize(p))

  for i,_ in pairs (interfaces) do
    print (i)
    if i == 'TV' then
      table.insert (tvs, p)
      isTv = true
    elseif i == 'CONTROL_V1' then
      table.insert (controls, p)
      isControl = true
    end
  end

  if isControl then
    for _,tv in ipairs(tvs) do
      link_control_tv (p, tv)
    end
  end

  if isTv then
    for _,control in ipairs (controls) do
      link_control_tv (control, p)
    end
  end
end
