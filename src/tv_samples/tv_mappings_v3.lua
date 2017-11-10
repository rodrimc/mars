CLIENT.mapping.events =
  {
    {"KEY_PRESSED", "CONTROL", "TURN_ON", "TV", function (arg) return arg[1] == 0 end},
    {"KEY_PRESSED", "CONTROL", "PLAY", "TV", function (arg) return arg[1] == 1 end},
    {"KEY_PRESSED", "CONTROL", "PAUSE", "TV", function (arg) return arg[1] == 2 end},
    {"KEY_PRESSED", "CONTROL", "SEEK_FORWARD", "TV", function (arg) return arg[1] == 3 end},
    {"KEY_PRESSED", "CONTROL", "SEEK_BACKWARD", "TV", function (arg) return arg[1] == 4 end},
    {"KEY_PRESSED", "CONTROL", "VOLUME_UP", "TV", function (arg) return arg[1] == 5 end},
    {"KEY_PRESSED", "CONTROL", "VOLUME_DOWN", "TV", function (arg) return arg[1] == 6 end},
    {"KEY_PRESSED", "CONTROL", "TURN_OFF", "TV", function (arg) return arg[1] == 7 end},
  }

--CLIENT.mapping.apply = apply
