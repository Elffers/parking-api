class Request
  include Mongoid::Document
  field :coords, type: String
  field :bounds, type: String
  field :client, type: String
  field :version, type: String
  field :overlay, type: String
  validates :coords, :bounds, :client, presence: true

  def get_overlay
    bounds = {"bbox"=>self.bounds}.to_query
    uri = "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export"
    image = HTTParty.get("#{uri}?#{bounds}&bboxSR=4326&layers=7&layerdefs=&size=&imageSR=&format=png&transparent=true&dpi=&time=&layerTimeOptions=&f=image")

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

  def request_params
    # layer = 7
    # spatial_reference = 4326
    # {
    #   "bbox"        => self.bounds,
    #   "bboxSR"      => spatial_reference,
    #   "layers"      => layer,
    #   "format"      => "png",
    #   "transparent" => "true",
    # }.to_query

    # "bbox=48.607765%2C-124.333297%2C48.609747%2C-124.331580&bboxSR=4326&layers=7&layerdefs=&size=&imageSR=&format=png&transparent=false&dpi=&time=&layerTimeOptions=&f=image"

  end
end