tceu_callback_ret evt_cb (int cmd,
    tceu_callback_arg p1,
    tceu_callback_arg p2,
    const char* filename,
    u32 line)
{
  static int flag = 0;
  tceu_callback_ret ret = { .is_handled=0 };
  if (flag == 0 && cmd == CEU_CALLBACK_STEP)
  {
    char *interface_file = NULL;
    char *mapping_file = NULL;
    char c;

    while ((c = getopt (CEU_APP.argc, CEU_APP.argv, "i:m:")) != -1)
    {
      switch (c)
      {
        case 'i':
          {
            interface_file = optarg;
            break;
          }
        case 'm':
          {
            mapping_file = optarg;
            break;
          }
      }
    }

    tceu_input_INIT p = {interface_file, mapping_file};

    ceu_input (CEU_INPUT_INIT, &p);

    flag = 1;
    ret.is_handled = 1;
  }
  return ret;
}

tceu_callback cb = { &evt_cb, NULL };

