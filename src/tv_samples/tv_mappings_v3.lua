mapping {
    {"KEY_PRESSED", "CONTROL_V2", "TURN_ON", "TV", function (arg) return arg[1] == 0 end},
    {"KEY_PRESSED", "CONTROL_V2", "PLAY", "TV", function (arg) return arg[1] == 1 end},
    {"KEY_PRESSED", "CONTROL_V2", "PAUSE", "TV", function (arg) return arg[1] == 2 end},
    {"KEY_PRESSED", "CONTROL_V2", "SEEK_FORWARD", "TV", function (arg) return arg[1] == 3 end},
    {"KEY_PRESSED", "CONTROL_V2", "SEEK_BACKWARD", "TV", function (arg) return arg[1] == 4 end},
    {"KEY_PRESSED", "CONTROL_V2", "VOLUME_UP", "TV", function (arg) return arg[1] == 5 end},
    {"KEY_PRESSED", "CONTROL_V2", "VOLUME_DOWN", "TV", function (arg) return arg[1] == 6 end},
    {"KEY_PRESSED", "CONTROL_V2", "TURN_OFF", "TV", function (arg) return arg[1] == 7 end},
  }
