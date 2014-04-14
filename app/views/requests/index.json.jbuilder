json.array!(@requests) do |request|
  json.extract! request, :id, :coords, :bounds, :client, :version, :overlay
  json.url request_url(request, format: :json)
end
