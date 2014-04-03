class Request
  include Mongoid::Document
  field :coords, type: String
  field :bounds, type: String
  field :client, type: String
  field :version, type: String
end
