class Request
  include Mongoid::Document
  field :coords, type: String
  field :bounds, type: String
  field :client, type: String
  field :version, type: String
  field :overlay, type: String
  field :url, type: String
  validates :coords, :bounds, :client, presence: true
  # TODO: validation on coordinates being within Seattle lat/long range

  def get_overlay
    uri = "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export"
    query = self.request_params_to_query
    image = HTTParty.get("#{uri}?#{query}")
    self.url = uri + "?" + query

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
    # TODO: figureout how size affects bounding box
    size = "500,500"
    # dpi = 96

    {
      "dpi"=>"96",
      "transparent"=>"true",
      "format"=>"png8",
      "layers"=>"show:#{layers}",
      "bbox"=>self.bounds,
      "bboxSR"=> spatial_reference,
      "imageSR"=> spatial_reference,
      "size"=> size,
      "f"=>"image"
      # "bbox"        => self.bounds,
      # "bboxSR"      => spatial_reference,
      # "imageSR"     => spatial_reference,
      # "layers"      => "show:#{layers}",
      # "f"           =>"image",
      # # "size"        => size,
      # "transparent" => "true",
      # "format"      =>"png8",
    }.to_query
  end

# {
#
# }
end