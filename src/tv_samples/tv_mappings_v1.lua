tvs = {}
controls = {}

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
      map (p, 'SPACE', tv, 'PLAY')
    end
  end

  if isTv then
    for _,control in ipairs (controls) do
      map (control, 'SPACE', p, 'PLAY')
    end
  end
end
