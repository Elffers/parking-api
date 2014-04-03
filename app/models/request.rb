class Request
  include Mongoid::Document
  field :coords, type: String
  field :bounds, type: String
  field :client, type: String
  field :version, type: String
  field :overlay, type: String

  def get_overlay
    bounds = {"bbox"=>self.bounds}.to_query
    image = HTTParty.get("http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export?#{bounds}&bboxSR=4326&layers=7&layerdefs=&size=&imageSR=&format=png&transparent=false&dpi=&time=&layerTimeOptions=&f=image")
    # save the image somewhere else
    image
  end
end