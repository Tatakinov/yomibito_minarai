local Util  = require("talk._util")

return {
  {
    id  = "OnView",
    content = function(shiori, ref)
      local __ = shiori.var
      local s = [=[\0\s[0]]=] .. Util.render(6.5, 0, ref[1]) ..
        [[\w9\w9\w9]] .. Util.render(5, 1.5, ref[2]) .. [[\w9\w9\w9]] ..
        Util.render(3.5, 3, ref[3]) .. [[\w9\w9\w9]] ..
        Util.render(2, 8, "さや") .. [[\w9\w9\w9]]
      local e = __("_Explain")
      if e and #e > 0 then
        local result = shiori:saori("budoux")(e, 25 * 2)
        local list = {}
        for i = 0, tonumber(result()) - 1 do
          table.insert(list, result[i])
        end
        s = s .. [[\1]]
        for i, v in ipairs(list) do
          s = s .. v .. [[\n]]
        end
        s = s .. [[\0]]
      end
      if ref[0] == "bookmark" then
        s = s ..
          [=[\_q\_l[0em,0em]\__q[OnViewBookmark]]=] ..
          Util.render(0, 0, "戻る") ..
          [[\__q\_q]]
      elseif ref[0] == "random" then
        s = s ..
          [[\_q\_l[0em,0em]\q[☆,OnBookmark,]] .. ref[1] .. "," ..
          ref[2] .. "," .. ref[3] .. [[]\_q]]
      end
      return s
    end,
  },
}
