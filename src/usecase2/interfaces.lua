interfaces {
  TEACHER =
  {
    inputs =
    {
      SHOW_SLIDE_ = {'int'},
      SEEK_ = {'int'},
      REQUEST_CONTROL = {'int'},
      SEEK_REQUEST = {'int', 'int'}
    },
    outputs =
    {
      NEW_SLIDE = {'int'},
      REPLY_CONTROL = {'int'},
      PERFORM_SEEK = {'int'}
    },
  },
  STUDENT =
  {
    inputs =
    {
      SHOW_SLIDE = {'int'},
      SEEK = {'int'},
      CONTROL_CHANGED = {'int'}
    },
    outputs =
    {
      TRY_GET_CONTROL = {'int'},
      REWIND = {'int', 'int'}
    }
  }
}
