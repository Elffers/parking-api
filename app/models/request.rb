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
    bounds = {"bbox"=>self.bounds}.to_query
    spatial_reference = "4326"
    image = HTTParty.get("#{uri}?#{bounds}&bboxSR=#{spatial_reference}&layers=7&layerdefs=&size=&imageSR=&format=png&transparent=true&dpi=&time=&layerTimeOptions=&f=image")

    # http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export?bbox=47.607765%2C-122.333297%2C47.609747%2C-122.331580&bboxSR=4326&layers=7&layerdefs=&size=&imageSR=&format=png&transparent=true&dpi=&time=&layerTimeOptions=&f=image

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

#   def request_params
#     layer = 7
#     spatial_reference = 4326
#     {
#       "bbox"        => self.bounds,
#       "bboxSR"      => spatial_reference,
#       "layers"      => layer,
#       "transparent" => "true",
#       "format"      => "png",
#     }.to_query
# "bbox=47.607765%2C-122.333297%2C47.609747%2C-122.331580&bboxSR=4326&format=png&layers=7&transparent=true"


# # "bbox=47.607765%2C-122.333297%2C47.609747%2C-122.331580&bboxSR=4326&layers=7&layerdefs=&size=&imageSR=&format=png&transparent=true&dpi=&time=&layerTimeOptions=&f=image"

#   end
end