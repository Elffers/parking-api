class Request
  include Mongoid::Document
  field :coords, type: String
  field :bounds, type: String
  field :client, type: String
  field :version, type: String
  field :overlay, type: String
  validates :coords, :bounds, :client, presence: true

  def get_overlay
    uri = "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export"
    query = self.request_params_to_query
    image = HTTParty.get("#{uri}?#{query}")

    p image.inspect

    p "URI", "#{uri}?#{query}"

    filename = "overlays/#{Time.now.to_i}.png"

    img_file = File.new("#{Rails.root.to_s}/app/assets/images/#{filename}", 'w', :encoding => 'ASCII-8BIT')

    img_file.write(image.parsed_response)
    # save the image somewhere else

    self.overlay = filename
  end

  def set_client(user_agent_string)
    ua = AgentOrange::UserAgent.new(user_agent_string)
    device = ua.device
    if device.is_mobile?
      self.client = device.platform
      self.version = device.platform.version
    else device.is_computer?
      self.client = device.engine.browser.name
      self.version = device.engine.browser.version
    # elsif other conditions for not mobile or computer? BOT?
    end
  end

  def request_params_to_query
    layers = "7,6,8,9"
    spatial_reference = 4326
    size = '350,350'

    {
      "bbox"        => self.bounds,
      "bboxSR"      => spatial_reference,
      "layers"      => "show:#{layers}",
      "f"           =>"image",
      "size"        => size,
      "transparent" => "true",
    }.to_query
  end

# this one works:
# http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export?bbox=47.607765%2C-122.333297%2C47.609747%2C-122.331580&bboxSR=4326&f=image&layers=show%3A7%2C6%2C8%2C9&size=&transparent=true

# {
#     "bbox"=>"47.607765,-122.333297,47.609747,-122.331580",
#     "bboxSR"=>"4326",
#     "f"=>"image",
#     "layers"=>"show:7,6,8,9",
#     "size"=>nil,
#     "transparent"=>"true"
# }

end