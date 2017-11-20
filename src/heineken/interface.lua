interface {
  TV = {
    inputs = {
      { ACCEPTED_ = {} },
      { CHOSEN_OPTION = {'int'} },
    },
    outputs = {
      { QUESTION = {} },
      { END_ = {} }
    }
  },
  TABLET = {
    inputs = {
      { SHOW_OPTIONS = {} },
      { KILL_APP = {} },
    },
    outputs = {
      { ACCEPT = {} },
      { CHOICE = {'int'} },
    }
  }
}
