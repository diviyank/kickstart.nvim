return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup {
      org_agenda_files = '~/orgfiles/agenda/**/*',
      org_default_notes_file = '~/orgfiles/refile.org',
      org_startup_folded = 'content',
      org_log_done = 'time',
      org_todo_keywords = { 'TODO', 'WAIT', 'MEET', 'MAIL', 'TEST', 'CURR', 'PRIO1', 'PRIO2', 'PRIO3', '|', 'DONE', 'DELEG', 'KILL' },
      org_todo_keyword_faces = {
        TODO = ':foreground #FFFFFF :background #4185B2',
        WAIT = ':foreground #FFD700',
        MEET = ':foreground #6A5ACD',
        MAIL = ':foreground #87CEEB',
        TEST = ':foreground #FFFFFF :background #2E8B57',
        CURR = ':foreground #F54927',
        PRIO1 = ':foreground #FFFFFF :background #DC143C :weight bold',
        PRIO2 = ':foreground #000000 :background #FF8C00 :weight bold',
        PRIO3 = ':foreground #000000 :background #FFC72C :weight bold',
        DONE = ':foreground green',
        DELEG = ':foreground green',
        KILL = ':foreground #4D4D4D',
      },
    }

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
}
