return {
  {
    id = "OnInitialize",
    content = function(shiori, ref)
      local __ = shiori.var
      __("_AIAvailable", false)
      local fh = io.open(__("_path") .. [[ai\model\genai_config.json]], "r")
      if fh then
        fh:close()
        __("_AIAvailable", true)
      end
      __("_Generating", false)
    end,
  },
  {
    id  = "OnBoot",
    content = function(shiori, ref)
      local __ = shiori.var
      __("_Available", "loading")
      return [=[\![raise,OnView,normal,起動中,少し時間を,くださいな]]=]
    end,
  },
  {
    id = "OnClose",
    content = function(shiori, ref)
      local __ = shiori.var
      __("_Explain", nil)
      return [=[\![embed,OnView,normal,さようなら,また会いましょう,いつの日か]\-]=]
    end,
  },
  {
    id  = "OnSecondChange",
    content = function(shiori, ref)
      local __  = shiori.var
      if __("_Available") == "loading" then
        __("_Available", shiori:saori("word2vec")("available")())
        if __("_Available") == "true" then
          return [=[\![raise,OnView,normal,語彙データ,読み込めました,ではどうぞ]]=]
        elseif __("_Available") == "false" then
          return [=[\![raise,OnView,normal,語彙データ,読み込み中に,エラー出た]]=]
        end
      elseif __("_Available") == "true" then
        if __("_Generating") then
          local process = __("_Process")
          while process:readable() do
            local line = process:readline()
            local explain = __("_Explain")
            if not(line) then
              __("_Generating", false)
              local s = __("_Senryuu")
              return string.format([=[\![raise,OnView,random,%s,%s,%s]]=], s[1], s[2], s[3])
            end
            __("_Explain", explain .. line)
          end
        else
          local count = __("_Count") or 0
          count = count + 1
          if count >= 60 then
            __("_Count", 0)
            return [=[\![raise,OnGenerate,auto]]=]
          end
          __("_Count", count)
        end
      end
      return nil
    end,
  },
  {
    id  = "OnMouseDoubleClick",
    content = function(shiori, ref)
      return [=[\![raise,OnMenu]]=]
    end,
  },
  {
    id  = "OnKeyPress",
    content = function(shiori, ref)
      if ref[0] == "t" then
        return [=[\![raise,OnMenu]]=]
      end
      return nil
    end,
  },
  {
    id  = "OnSurfaceRestore",
    content = [=[\0\s[0]]=],
  },
}

