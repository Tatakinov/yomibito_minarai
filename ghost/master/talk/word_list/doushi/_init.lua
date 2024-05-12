local Kind      = require("talk.word_list._kind")

local function wrap(t)
  local ret = {}
  for _, v in ipairs(t) do
    table.insert(ret, {
      word = v, kind = Kind.doushi, cond = {
        {
          Kind.meishi, Kind.joshi
        },
        {
          Kind.third,
        },
      },
      apply = function(t)
        t.doushi  = t.doushi + 1
      end,
    })
  end
  return ret
end

local List = require(string.format("talk.word_list.doushi._list"))

return List
