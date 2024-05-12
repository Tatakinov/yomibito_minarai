local WL  = require("talk.word_list._init")
local Kind  = require("talk.word_list._kind")
local Process = require("process")

local function contains(list, e)
  for _, v in ipairs(list) do
    if v == e then
      return true
    end
  end
  return false
end

local function shuffle(t)
  for i = #t, 2, -1 do
    local j = math.random(i)
    t[i], t[j] = t[j], t[i]
  end
end

-- 品詞と文字数の情報を持った川柳を作る。
local function generate(n, kind, info, score, max)
  local a = math.random(n)
  if max == 1 then
    a = n
  end

  local kinds = { kind }
  if info.head then
    table.insert(kinds, Kind.first)
  elseif n == a then
    if info.tail then
      table.insert(kinds, Kind.last)
    else
      table.insert(kinds, Kind.third)
    end
  else
    table.insert(kinds, Kind.second)
  end

  local t = WL[a][kinds[1]][kinds[2]]
  if #t == 0 then
    return "", "grep 0", nil, nil
  end

  local w = t[math.random(#t)]
  local s, err, kind, morph
  if n - a == 0 then
    s, err, kind, morph = "", nil, w.kind, {}
  else
    s, err, kind, morph = generate(n - a, w.kind, {
      head = false,
      tail = info.tail,
    }, score, max - 1)
  end
  if err then
    return "", err, nil, nil
  end

  table.insert(morph, 1, {
    word = w.word,
    orig = w.orig,
    kind = w.kind,
    len  = a,
  })

  score.count = score.count + 1
  w.apply(score)

  return w.word .. s, nil, kind, morph
end

-- 終助詞が2つ以上ある等おかしくないかチェックする
local function check(score)
  for _, v in pairs(score) do
    if v < 0 then
      return false
    end
  end
  if score.shuujoshi > 1 then
    return false
  end
  return true
end

-- 川柳っぽさを品詞などを見てスコア付けする
local function calc(score)
  local sum = 0
  for k, v in pairs(score) do
    if k == "count" or k == "shuujoshi" or k == "fukushi" then
      sum = sum + v
    else
      --sum = sum - v
    end
  end
  return sum
end

-- 品詞と文字数をそのままに、日本語的に違和感が少なくなるような
-- 言葉選びをする。例: 紙が畳む -> 紙が燃える
local function convert(saori, morph)
  local t = {}
  local s
  local base
  local index = 1
  while index <= #morph do
    local m = morph[index]
    if index == 1 then
      s = m.word
      base = { m.orig }
      index = index + 1
    elseif m.sep then
      table.insert(t, s)
      s = ""
      index = index + 1
    elseif m.orig == nil then
      s = s .. m.word
      index = index + 1
    else
      -- 品詞+文字数が同じ単語をリストアップする
      local list = {}
      for _, v in pairs(WL[m.len]) do
        for _, v in pairs(v) do
          for _, v in ipairs(v) do
            local is_valid = v.kind == m.kind and v.orig and not(contains(base, v.orig)) and not(list[v.word])
            if is_valid then
              for _, e in ipairs(list) do
                if e.word == v.word then
                  is_valid = false
                  break
                end
              end
            end
            if is_valid then
              list[v.word] = v
            end
          end
        end
      end
      -- word2vecを用いて似通った単語順に並べる
      local list2 = {}
      for _, v in pairs(list) do
        --local similarity = math.abs(tonumber(saori("similarity", base, v.orig)()))
        local arg = {"similarity_ex", 1, "+" .. v.orig }
        --table.insert(arg, #base + 1)
        table.insert(arg, #base)
        for _, v in ipairs(base) do
          table.insert(arg, "+" .. v)
        end
        --table.insert(arg, "+" .. m.orig)
        local similarity = math.abs(tonumber(saori(table.unpack(arg))()))
        table.insert(list2, {similarity = similarity, word = v.word, orig = v.orig})
      end
      table.sort(list2, function(a, b) return a.similarity > b.similarity end)
      -- 上位10単語からランダムに選ぶ
      local list3 = {}
      for i, v in ipairs(list2) do
        if i > 10 then
          break
        end
        table.insert(list3, v)
      end
      local data = list3[math.random(#list3)]
      s = s .. data.word
      table.insert(base, data.orig)
      while #base >= 2 do
        table.remove(base, 1)
      end
      index = index + 1
    end
  end
  table.insert(t, s)
  return t
end

return {
  {
    id = "OnGenerate",
    content = function(shiori, ref)
      local __ = shiori.var
      local a, b, c, err, kind, tmp
      local saori = shiori:saori("distribution")
      local list = {}
      for i = 1, 10 do
        local s
        local morpheme
        repeat
          local score = {
            count = 0,
            meishi = 0,
            doushi = 0,
            joshi_mokuteki = 0,
            shuujoshi = 0,
            fukushi = 0,
          }
          morpheme = {}
          local morph
          local head = true
          repeat
            a, err, kind, morph = generate(5, Kind.none, {
              head = head,
              tail = false,
            }, score, 3)
          until err == nil
          for _, v in ipairs(morph) do
            table.insert(morpheme, v)
          end
          table.insert(morpheme, {sep = true})
          tmp = kind
          if contains({Kind.doushi, Kind.meishi, Kind.shuujoshi}, tmp) then
            tmp = Kind.none
            head = true
          else
            head = false
          end
          repeat
            kind  = tmp
            b, err, kind, morph = generate(7, kind, {
              head  = head,
              tail  = false,
            }, score, 3)
          until err == nil
          for _, v in ipairs(morph) do
            table.insert(morpheme, v)
          end
          table.insert(morpheme, {sep = true})
          tmp = kind
          if contains({Kind.doushi, Kind.meishi, Kind.shuujoshi}, tmp) then
            tmp = Kind.none
            head = true
          else
            head = false
          end
          repeat
            kind = tmp
            c, err, kind, morph = generate(5, kind, {
              head = head,
              tail = true,
            }, score, 3)
          until err == nil
          s = score
          for _, v in ipairs(morph) do
            table.insert(morpheme, v)
          end
        until check(s)
        table.insert(list, { score = s, morph = morpheme })
      end
      table.sort(list, function(a, b) return calc(a.score) > calc(b.score) end)
      local first = list[1]
      print("----")
      for _, v in ipairs(first.morph) do
        print(v.len)
      end
      local t = convert(shiori:saori("word2vec"), first.morph)
      if __("_AIAvailable") then
        local process = Process({
          command = __("_path") .. "ai/AIInterpreter.exe",
          chdir = true,
        })
        process:spawn()
        process:writeline([[あなたは教師です。ユーザーの入力した文章の意味を、文脈を考慮してわかりやすく教えてください。回答は日本語でお願いします。]])
        process:writeline(string.format([[%s、%s、%s。]], t[1], t[2], t[3]))
        __("_Generating", true)
        __("_Explain", "")
        __("_Process", process)
        __("_Senryuu", t)
        return [=[\![raise,OnView,normal,作るから,少し待ってて,くださいね]]=]
      else
        __("_Explain", nil)
        return string.format([=[\![raise,OnView,random,%s,%s,%s]]=], t[1], t[2], t[3])
      end
    end,
  },
}
