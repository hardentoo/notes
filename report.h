  OPTION__(report_t, budget_format_, CTOR(report_t, budget_format_) {
      on(none,
         "%(justify(scrub(get_at(total_expr, 0)), 12, -1, true, color))"
         " %(justify(scrub(- get_at(total_expr, 1)), 12, -1, true, color))"
         " %(justify(scrub(get_at(total_expr, 1) + "
         "                 get_at(total_expr, 0)), 12, -1, true, color))"
         " %(justify((get_at(total_expr, 1) ? "
         "           scrub((100% * get_at(total_expr, 0)) / "
         "                 - get_at(total_expr, 1)) : 0), "
         "           5, -1, true, magenta "
         "               if (color and get_at(total_expr, 1) and "
         "                   ((quantity(get_at(total_expr, 0)) / "
         "                    - quantity(get_at(total_expr, 1))) > 1))))"
         "  %(!options.flat ? depth_spacer : \"\")"
         "%-(ansify_if(partial_account(options.flat), blue if color))\n"
         "%/"
         "%(justify(scrub(get_at(total_expr, 0)), 12, -1, true, color))"
         " %(justify(scrub(- get_at(total_expr, 1)), 12, -1, true, color))"
         " %(justify(scrub(get_at(total_expr, 1) + "
         "                 get_at(total_expr, 0)), 12, -1, true, color))"
         " %(justify((get_at(total_expr, 1) ? "
         "           scrub((100% * get_at(total_expr, 0)) / "
         "                 - get_at(total_expr, 1)) : 0), "
         "           5, -1, true, magenta "
         "               if (color and get_at(total_expr, 1) and "
         "                   ((quantity(get_at(total_expr, 0)) / "
         "                    - quantity(get_at(total_expr, 1))) > 1))))\n%/"
         "------------ ------------ ------------ -----\n");
    });
