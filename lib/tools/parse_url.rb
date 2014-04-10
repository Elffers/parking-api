def parse_url(url)
  uri, query = url.split("?")
  params = query.split("&")
  params_hash = {}
  params.each do |param|
    k, v = param.split("=")
    params_hash[k] = parse_value(v)
  end
  params_hash
end

def parse_value(value)
  value.gsub(/%2C/, ',').gsub(/%3A/, ':') if value
end