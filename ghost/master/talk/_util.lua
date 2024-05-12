local utf8  = require("lua-utf8")

local function toList(str)
  local t = {}
  for _, c in utf8.codes(str) do
    local s = utf8.char(c)
    s = string.gsub(s, "ー", "｜")
    table.insert(t, s)
  end
  return t
end
local function render(x, y, str)
  local t = toList(str)
  local s = ""
  for i, v in ipairs(t) do
    s = s .. string.format([[\_l[%.1fem,%.1fem]%s]], x, y + i - 1, v)
  end
  return s
end

return {
  render  = render,
}
