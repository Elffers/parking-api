require 'spec_helper'

describe SaveRequestJob do
  let(:request_params){ {
                        "coords" => "(47.67666029999999, -122.33759450000002)",
                        "bounds" => "((47.66510082328286, -122.35476063769534), (47.68821721639755, -122.32042836230471))",
                        "size"=>"400,400",
                        "client"=>"Chrome",
                        "query"=>"http://placekitten.com/200/200",
                        }
                      }
  let(:request) { Request.new(request_params) }

  before do
    request.get_overlay
  end

end