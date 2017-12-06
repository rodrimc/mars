tvs = {}
controls = {}

function link_control_tv (control, tv)
  map (control, 'KEY_PRESSED', tv, 'TURN_ON',       function (_, key) return key == 0 end)
  map (control, 'KEY_PRESSED', tv, 'PLAY',          function (_, key) return key == 1 end)
  map (control, 'KEY_PRESSED', tv, 'PAUSE',         function (_, key) return key == 2 end)
  map (control, 'KEY_PRESSED', tv, 'SEEK_FORWARD',  function (_, key) return key == 3 end)
  map (control, 'KEY_PRESSED', tv, 'SEEK_BACKWARD', function (_, key) return key == 4 end)
  map (control, 'KEY_PRESSED', tv, 'VOLUME_UP',     function (_, key) return key == 5 end)
  map (control, 'KEY_PRESSED', tv, 'VOLUME_DOWN',   function (_, key) return key == 6 end)
  map (control, 'KEY_PRESSED', tv, 'TURN_OFF',      function (_, key) return key == 7 end)
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
    elseif i == 'CONTROL_V2' then
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

