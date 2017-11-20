interface {
  TV = 
    {
      inputs = {
        { TURN_ON = {} },
        { TURN_OFF = {} },
        { PLAY = {} },
        { PAUSE = {} },
        { SEEK_FORWARD = {} },
        { SEEK_BACKWARD = {} },
        { VOLUME_UP = {} },
        { VOLUME_DOWN = {} },
      },
      outputs = {},
    },
  CONTROL_V1 = 
    {
      inputs = {},
      outputs = {
        { SPACE = {} },
        { P = {} },
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
