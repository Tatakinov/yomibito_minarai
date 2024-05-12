local Util  = require("talk._util")

return {
  {
    id  = "OnBookmark",
    content = function(shiori, ref)
      local __  = shiori.var
      local bookmark  = __("Bookmark") or {}
      __("Bookmark", bookmark)
      local is_contains = false
      for _, v in ipairs(bookmark) do
        if v[1] == ref[0] and v[2] == ref[1] and v[3] == ref[2] then
          is_contains = true
          break
        end
      end
      if not(is_contains) then
        local e = __("_Explain")
        if e then
          table.insert(bookmark, {
            ref[0], ref[1], ref[2], e
          })
        else
          table.insert(bookmark, {
            ref[0], ref[1], ref[2]
          })
        end
        return [=[\C\c[line,1]]=]
      end
      return nil
    end,
  },
  {
    id  = "OnViewBookmark",
    content = function(shiori, ref)
      local __  = shiori.var
      local bookmark  = __("Bookmark") or {}
      local page  = __("_Page") or 1
      if ref[0] == "next" then
        page = page + 1
      elseif ref[0] == "prev" then
        page = page - 1
      end
      __("_Page", page)
      local s = [=[\0\s[0]\_q]=]
      local max = 4
      for i = 1, max do
        local index = (page - 1) * max + i
        local h = bookmark[index]
        if h then
          s = s ..
          string.format([=[\__q[OnViewBookmarkEx,%s,%s,%s]]=], h[1], h[2], h[3]) ..
          Util.render(3 + 1.5 * (max - i), 0, h[1]) ..
          [[\__q]]
        end
      end
      if page > 1 then
        s = s .. [=[\_l[0em,0em]\q[＜,OnViewBookmark,prev]]=]
      end
      if #bookmark > page * max then
        s = s .. [=[\_l[1em,0em]\q[＞,OnViewBookmark,next]]=]
      end
      s = s .. [=[\_l[0.5em,3em]\__q[OnMenuClose]]=] ..
        Util.render(0.5, 3, "閉じる") .. [[\__q]]
      return s
    end,
  },
  {
    id = "OnViewBookmarkEx",
    content = function(shiori, ref)
      local __  = shiori.var
      local bookmark  = __("Bookmark") or {}
      local is_contains = false
      for _, v in ipairs(bookmark) do
        if v[1] == ref[0] and v[2] == ref[1] and v[3] == ref[2] then
          __("_Explain", v[4])
          is_contains = true
          break
        end
      end
      if is_contains then
        return string.format([=[\![raise,OnView,bookmark,%s,%s,%s]]=], ref[0], ref[1], ref[2])
      end
    end,
  }
}

