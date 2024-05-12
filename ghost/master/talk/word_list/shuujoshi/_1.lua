local Kind      = require("talk.word_list._kind")

return {
  {
    word = "や",
    kind = Kind.shuujoshi, cond = {
      {
        Kind.meishi,
      },
      {
        Kind.third,
      },
    },
    apply = function(t)
      t.shuujoshi = t.shuujoshi + 1
      t.meishi = t.meishi - 1
    end,
  },
}
