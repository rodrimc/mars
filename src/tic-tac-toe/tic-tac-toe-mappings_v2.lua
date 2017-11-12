CLIENT.mapping.events =
  {
    {"MY_MOVE", nil,  "OPPONENT_MOVE", nil,
        function (args, from, me) 
          local toEmit = from == CLIENT.role.name
          return not toEmit 
        end
      },
  }
