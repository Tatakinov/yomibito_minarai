local Kind      = require("talk.word_list._kind")

return {
  {
    word = "は",
    kind = Kind.joshi_shu,
    cond = {
      {
        Kind.meishi
      },
      {
        Kind.second, Kind.third,
      }
    },
    apply = function(t)
      t.meishi = t.meishi - 1
      t.doushi = t.doushi - 1
    end,
  },
  {
    word = "が",
    kind = Kind.joshi_shu,
    cond = {
      {
        Kind.meishi
      },
      {
        Kind.second, Kind.third,
      }
    },
    apply = function(t)
      t.meishi = t.meishi - 1
      t.doushi = t.doushi - 1
    end,
  },
  {
    word = "の",
    kind = Kind.joshi_shoyuu,
    cond = {
      {
        Kind.meishi
      },
      {
        Kind.second, Kind.third
      }
    },
    apply = function(t)
      t.meishi = t.meishi - 2
    end,
  },
  {
    word  = "を",
    kind = Kind.joshi_mokuteki1,
    cond = {
      {
        Kind.meishi
      },
      {
        Kind.second, Kind.third,
      }
    },
    apply = function(t)
      t.joshi_mokuteki = t.joshi_mokuteki + 1
      t.meishi = t.meishi - 1
    end,
  },
  {
    word = "に",
    kind = Kind.joshi_mokuteki2,
    cond = {
      {
        Kind.meishi
      },
      {
        Kind.second, Kind.third,
      }
    },
    apply = function(t)
      t.joshi_mokuteki = t.joshi_mokuteki + 1
      t.meishi = t.meishi - 1
    end,
  },
  {
    word = "へ",
    kind = Kind.joshi_mokuteki2,
    cond = {
      {
        Kind.meishi
      },
      {
        Kind.second, Kind.third,
      }
    },
    apply = function(t)
      t.meishi = t.meishi - 1
    end,
  },
  {
    word = "で",
    kind = Kind.joshi_shudan,
    cond = {
      {
        Kind.meishi
      },
      {
        Kind.second, Kind.third,
      }
    },
    apply = function(t)
      t.meishi = t.meishi - 1
    end,
  },
}
