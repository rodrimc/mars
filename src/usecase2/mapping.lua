local students = {}
local teacher = nil

function link (teacher, student)
  map (teacher, 'NEW_SLIDE', student, 'SHOW_SLIDE')
  map (teacher, 'REPLY_CONTROL', student, 'CONTROL_CHANGED')
  map (teacher, 'PERFORM_SEEK', student, 'SEEK')
  map (student, 'TRY_GET_CONTROL', teacher, 'REQUEST_CONTROL')
  map (student, 'REWIND', teacher, 'SEEK_REQUEST')
end

MARS.onConnect = function (p)
  local interfaces = p:getInterfaces ()

  for i,_ in pairs (interfaces) do
    if i == 'TEACHER' then
      teacher = p
      map (p, 'NEW_SLIDE', p, 'SHOW_SLIDE_')
      map (p, 'PERFORM_SEEK', p, 'SEEK_')

      for _, s in pairs (students) do
        link (teacher, s)
      end
    elseif i == 'STUDENT' then
      table.insert (students, p)
      if teacher ~= nil then
        link (teacher, p)
      end
    end
  end
end
