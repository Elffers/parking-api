require 'spec_helper'

describe SaveRequestJob do
  let(:request_params){ {
                        "coords"=>"foo",
                        "bounds"=>"-122.341331, 47.657289, -122.310042, 47.693368",
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