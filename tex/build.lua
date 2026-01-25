local pages = {}

local base_url = "https://trdelniky.github.io/"

local function make_sitemap(filename, builddir,  files)
  -- I want to generate a sitemap.xml file
  print("Generating sitemap at " .. filename)
  local sitemap = io.open(filename, "w")
  if not sitemap then
    print("Error: could not open file " .. filename .. " for writing")
    return
  end
  sitemap:write("<?xml version='1.0' encoding='UTF-8'?>\n")
  sitemap:write("<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>\n")


  for _, file in pairs(files) do
    -- files is a table of file paths, we need to filter html files
    if file:match("%.html$") then
      -- the output files start with the builddir path, so we need to remove it
      local url = base_url .. file:gsub("^" .. builddir .. "/?", "")
      sitemap:write("<url><loc>" .. url .. "</loc></url>\n")
    end
  end
  sitemap:write("</urlset>\n")
  sitemap:close()
end

Make:match(".*.tmp", function(filename, par)
  -- get all generated files
  local files = Make.lgfile.files
  -- write sitemap.xml file in the output directory
  make_sitemap(par.outdir .. "/sitemap.xml", par.builddir, files)

  -- for key, page in pairs(Make.lgfile.files) do
  --   print(key, page)
  -- end
end)
