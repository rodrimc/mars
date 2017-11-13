CLIENT.mapping.events =
  {
    {"CHOICE", nil, "OPPONENT_CHOICE", nil, 
        function (args, from)
          local toEmit = from == CLIENT.role.name
          return not toEmit 
        end,
      }
    }
