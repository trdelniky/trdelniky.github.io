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
    return pandoc.RawInline("latex", "\\vwtag{" .. text .. "}")
  end
end
