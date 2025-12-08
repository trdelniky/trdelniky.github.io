-- we need to find the vimwiki path, to import the vimwiki files
local nvim = io.popen("nvim --headless -c 'echo g:vimwiki_list[0].path | quit' 2>&1", "r")
local vimwiki_path = nvim:read("*a"):gsub("%s+$", ""):gsub("^%s+", "") 
if not vimwiki_path:match("%/$") then vimwiki_path = vimwiki_path .. "/" end
local tex_path = "cs/"
nvim:close()
if vimwiki_path == "" then
  print("Error: Could not determine Vimwiki path.")
  print("Cannot update the annotated bibliography.")
  os.exit()
end

local function get_links(filename)
  -- get list of links to local vimwiki files, so we can import them and convert to LaTeX too
  local links = {}
  local f = io.open(filename, "r")
  local content = f:read("*a")
  f:close()
  -- find local links in the vimwiki file and replace \href commands with \hyperlink
  content = content:gsub("href{(%d+%-%d+)}", function(link)
    links[#links+1] = link .. ".wiki"
    print(link)
    return "hyperref[" .. link .. "]"
  end)
  -- write the modified content back to the file
  local f = io.open(filename, "w")
  f:write(content)
  f:close()

  return links
end

local function add_to_bibliography(f,filename)
  -- add a vimwiki file to the bibliography
  f:write("\\input{" .. filename:gsub("%.wiki$", ".tex") .. "}\n")
end

local function add_hypertarget(filename, link)
  local f = io.open(filename, "r")
  local content = f:read("*a")
  f:close()
  -- remove the wiki extension from link, to get just the label
  local label = "label{" .. link:gsub("%.wiki$", "") .. "}"
  -- place 
  content = content:gsub("label{.-}", label)
  -- replace \section with \subsection, so that the vimwiki files are imported as subsections
  content = content:gsub("\\subsection" , "\\subsubsection")
  content = content:gsub("\\section" , "\\subsection")
  local f = io.open(filename, "w")
  f:write(content)
  f:close()
end


local function convert(filename, output_name)
  -- convert a vimwiki file to a tex file
  if not output_name then 
    output_name = filename:gsub("%.wiki$", ".tex")
  end
  local input_file = vimwiki_path .. filename
  local output_path = tex_path .. output_name
  local pandoc = io.popen("pandoc -f vimwiki -t latex -o " .. output_path .. " " .. input_file .. " 2>&1", "r")
  pandoc:read("*a")
  pandoc:close()
  return output_path
end

local converted_file = convert("240203-2251.wiki", "bibliography.tex")
local links = get_links(converted_file)
local outputs = {}
for _, link in ipairs(links) do
  outputs[#outputs+1] = convert(link)
end

-- add the converted linked wiki files to the bibliography
local f = io.open("cs/bibliography.tex", "a")
f:write("\\section{Překlady}\n")
for i, filename in ipairs(outputs) do
  add_to_bibliography(f,filename)
  add_hypertarget(filename, links[i])
end
f:close()





