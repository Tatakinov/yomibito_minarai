local Kind      = require("talk.word_list._kind")

local Meishi        = require("talk.word_list.meishi._init")
local Joshi         = require("talk.word_list.joshi._init")
local Shuujoshi     = require("talk.word_list.shuujoshi._init")
local Doushi        = require("talk.word_list.doushi._init")
local Keiyoushi     = require("talk.word_list.keiyoushi._init")
local Keiyoudoushi  = require("talk.word_list.keiyoudoushi._init")
local Fukushi       = require("talk.word_list.fukushi._init")

local list  = {{}, {}, {}, {}, {}, {}, {}}

for i, v in ipairs(Meishi) do
  for _, v in ipairs(v) do
    table.insert(list[i], {
      word = v[1], orig = v[2], kind = Kind.meishi, cond = {
        {
          Kind.none, Kind.keiyoushi, Kind.keiyoudoushi,
          Kind.joshi_shu, Kind.joshi_shoyuu,
        },
        {
          Kind.first, Kind.second, Kind.third, Kind.last,
        },
      },
      apply = function(t)
        t.meishi  = t.meishi + 1
      end,
    })
  end
end

for i, v in ipairs(Joshi) do
  for _, v in ipairs(v) do
    table.insert(list[i], v)
  end
end

for i, v in ipairs(Shuujoshi) do
  for _, v in ipairs(v) do
    table.insert(list[i], v)
  end
end

for i, v in ipairs(Doushi) do
  for _, v in ipairs(v) do
    table.insert(list[i], {
      word = v[1], orig = v[2], kind = Kind.doushi, cond = {
        {
          Kind.meishi, Kind.joshi_shu, Kind.joshi_mokuteki1,
          Kind.joshi_mokuteki2, Kind.joshi_shudan,
          Kind.fukushi,
        },
        {
          Kind.third, Kind.last,
        },
      },
      apply = function(t)
        t.doushi  = t.doushi + 1
      end,
    })
  end
end

for i, v in ipairs(Keiyoushi) do
  for _, v in ipairs(v) do
    table.insert(list[i], {
      word = v[1], orig = v[2], kind = Kind.keiyoushi, cond = {
        {
          Kind.joshi_shu, Kind.joshi_shoyuu,
        },
        {
          Kind.second, Kind.third, Kind.last
        },
      },
      apply = function(t)
        t.meishi  = t.meishi - 1
      end,
    })
  end
end

for i, v in ipairs(Keiyoudoushi) do
  for _, v in ipairs(v) do
    table.insert(list[i], {
      word = v[1], orig = v[2], kind = Kind.keiyoudoushi, cond = {
        {
          Kind.none,
          Kind.joshi_shu, Kind.joshi_shoyuu,
        },
        {
          Kind.first, Kind.second, Kind.third, Kind.last
        },
      },
      apply = function(t)
        t.meishi  = t.meishi - 1
      end,
    })
  end
end

for i, v in ipairs(Fukushi) do
  for _, v in ipairs(v) do
    table.insert(list[i], {
      word = v[1], orig = v[2], kind = Kind.fukushi, cond = {
        {
          Kind.none,
          Kind.joshi_shu, Kind.joshi_mokuteki1, Kind.joshi_mokuteki2,
        },
        {
          Kind.first, Kind.second, Kind.third
        },
      },
      apply = function(t)
        t.fukushi = t.fukushi + 1
      end,
    })
  end
end

local ret   = {{}, {}, {}, {}, {}, {}, {}}

for i = 1, 7 do
  ret[i]  = {
    none  = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    meishi    = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    joshi_shu = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    joshi_shoyuu = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    joshi_mokuteki1 = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    joshi_mokuteki2 = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    joshi_shudan = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    doushi    = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    keiyoushi = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    keiyoudoushi  = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    shuujoshi = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
    fukushi = {
      first   = {},
      second  = {},
      third   = {},
      last    = {},
    },
  }
  for _, v in ipairs(list[i]) do
    for _, c1 in ipairs(v.cond[1]) do
      for _, c2 in ipairs(v.cond[2]) do
        table.insert(ret[i][c1][c2], {
          word  = v.word,
          orig  = v.orig,
          kind  = v.kind,
          apply = v.apply,
        })
      end
    end
  end
end

return ret
