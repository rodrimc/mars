local sound = nil 
local notes = {}

MARS.onConnect = function (p)
  local isSound = p:hasInterface ('SOUND') 
  local isNote  = p:hasInterface ('NOTES') 

  if isSound and not sound then
    sound = p
    for _, note in ipairs (notes) do
      map (note, 'NOTE', p, 'PLAY')
    end
  end

  if isNote then
    if sound then
      map (p, 'NOTE', sound, 'PLAY')
    else
      table.insert (notes, p)
    end
  end
end
