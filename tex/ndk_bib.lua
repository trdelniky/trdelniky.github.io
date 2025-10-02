local help = [[ndk_bib.lua -- A Lua script to download bibliographic records from the Czech digital library
usage: texlua ndk_bib.lua <options> URL
options:
  -h, --help        show this help message and exit
  -o FILE, --output FILE
                    write output to FILE (default: stdout)
  -f FORMAT, --format FORMAT
                    output format: bibtex (default), wiki
]]

local cite_template = "https://citace.ceskadigitalniknihovna.cz/api/v1?url=$url&format=html&lang=cs&exp=$format"
local https = require("ssl.https")
local ltn12 = require("ltn12")

local function make_citeurl(url, format)
  local uuid = url:match("(uuid:[a-f0-9%-]+)")
  if not uuid then
    print("Error: Invalid URL, UUID not found")
    print("Used URL: " .. url)
    os.exit(1)
  end
  local api_url = "https://api.ceskadigitalniknihovna.cz&uuid=" .. uuid
  return cite_template:gsub("%$url", api_url):gsub("%$format", format)
end

local function download_https(url)
    local response_body = {}

    local res, code, headers, status = https.request{
        url = url,
        sink = ltn12.sink.table(response_body)
    }

    if not res then
        return nil, code, headers, status
    end

    return table.concat(response_body), code, headers, status
end

local function parse_options(args)
  local options = {
    output = nil,
    format = "bibtex",
    url = nil,
  }
  local i = 1
  while i <= #args do
    local arg = args[i]
    if arg == "-h" or arg == "--help" then
      print(help)
      os.exit(0)
    elseif arg == "-o" or arg == "--output" then
      i = i + 1
      options.output = args[i]
    elseif arg == "-f" or arg == "--format" then
      i = i + 1
      options.format = args[i]
    else
      options.url = arg
    end
    i = i + 1
  end
  if not options.url then
    print("Error: URL is required")
    print(help)
    os.exit(1)
  end
  return options
end 

local options = parse_options(arg)

local cite_url = make_citeurl(options.url, options.format)
local result, code, headers, status = download_https(cite_url)

if not result then
  print("Error: Failed to download data from " .. cite_url)
  print("HTTP error code: " .. tostring(code))
  os.exit(1)
end

print(result)

