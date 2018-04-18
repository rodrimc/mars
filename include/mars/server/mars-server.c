int flag = 0;

int
ceu_callback_media (int cmd, tceu_callback_val p1, tceu_callback_val p2
#ifdef CEU_FEATURES_TRACE
                      , tceu_trace trace
#endif
                      )

{
  int is_handled = 0;
  if (cmd == CEU_CALLBACK_STEP)
  {
    if (flag == 0)
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
      optind = 0;

      tceu_input_INIT p = {interface_file, mapping_file};

      ceu_input (CEU_INPUT_INIT, &p);

      flag = 1;
      is_handled = 1;
    }
  }
  return is_handled;
}

tceu_callback cb = { &ceu_callback_media, NULL };

