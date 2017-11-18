interface {
  TV = 
    {
      inputs = {
        { TURN_ON = {'int', 'ssize'} },
        { TURN_OFF = {'s64'} },
        { PLAY = {} },
        { PAUSE = {} },
        { SEEK_FORWARD = {} },
        { SEEK_BACKWARD = {} },
      },
      outputs = {},
    },
  CONTROL_V1 = 
    {
      inputs = {},
      outputs = {
        { SPACE = {} },
        { P = {'int', 'int', 'ssize'} },
        { RIGHT = {} },
        { LEFT = {} },
        { UP = {} },
        { DOWN = {} },
        { RETURN_ = {} },
        { ESC = {} },
      }
    },
  CONTROL_V2 =
    {
      inputs = {},
      outputs ={
        { KEY_PRESSED = {'int'} },
      }
    }
}

