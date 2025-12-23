-- mapování speciálních znaků použitých v tagech ve vimwiki na příkazy LaTeXu
local command_map = {
  ["@"] = "place", -- pro města, regiony a podobně
  [">"] = "author", -- 
}
local function get_tag(text)
  -- vytvořil jsem si různý kategorie tagů pro vimwiki, ty se musej mapovat na různý příkazy v LaTeXu
  local invisible = ""
  -- pokud tag začíní znakem !, je to neviditelný tag, takže by se neměl vypsat ve výsledným dokumentu, je určenej pro interní použití
  if text:match("^%!") then
    -- neviditelný příkazy mají prefix invisible
    invisible = "invisible"
    text = text:sub(2)
  end
  -- tagy nemůžou obsahovat mezery, používám místo toho podtržítko
  text = text:gsub("_", " ")
  local first_char = text:sub(1,1)
  if command_map[first_char] then
    local command = command_map[first_char]
    text = text:sub(2)
    return "\\tag" .. invisible .. command .. "{" .. text .. "}"
  else
    return "\\tag" .. invisible .. "basic" .. "{" .. text .. "}"
  end



end

function Span(el)
  -- zahodit interní negativní vimwiki tag
  if el.identifier
     and el.identifier:match("^%-") 
     and #el.classes == 0
     and pandoc.utils.stringify(el.content) == ""
  then
    return {}
  end

  -- normální vimwiki tag
  if el.classes:includes("tag") then
    local text = pandoc.utils.stringify(el.content)
    return pandoc.RawInline("latex", get_tag(text))
  end
end
