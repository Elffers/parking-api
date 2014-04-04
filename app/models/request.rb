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
    query = request_params
    image = HTTParty.get("#{uri}?#{query}")
    filename = "overlays/#{Time.now.to_i}.png"
    img_file = File.new("#{Rails.root.to_s}/app/assets/images/#{filename}", 'w', :encoding => 'ASCII-8BIT')
    # TODO: save the image in S3 bucket
    img_file.write(image.parsed_response)

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

  def request_params
    layer = 7
    spatial_reference = 4326
    {
      "bbox"        => self.bounds,
      "bboxSR"      => spatial_reference,
      "layers"      => layer,
      "format"      => "png",
      "transparent" => "true",
    }.to_query

  end
end