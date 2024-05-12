local Util  = require("talk._util")

return {
  {
    id  = "OnMenu",
    content = function(shiori, ref)
      local __ = shiori.var
      if __("_Available") == "true" and __("_Generating") == false then
        return string.format([[
\0\s[0]
\_q
\__q[OnCompose]%s\__q\n
\__q[OnViewBookmark]%s\__q\n
\__q[OnMenuClose]%s\__q\n
\_q
]], Util.render(7, 0, "一句詠んで"),
Util.render(5, 0, "お気に入りの川柳を見る"),
Util.render(3, 0, "閉じる"))
      elseif __("_Available") == false then
        return [=[\![raise,OnView,normal,作者宛,エラー報告,お願いね]]=]
      else
        return [=[\![raise,OnView,normal,まだ待って,一句読むのに,時間いる]]=]
      end
    end,
  },
  {
    id  = "OnCompose",
    content = function(shiori, ref)
      return [=[\![raise,OnGenerate,manual]]=]
    end,
  },
}
