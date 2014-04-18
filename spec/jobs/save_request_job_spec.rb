require 'spec_helper'

describe SaveRequestJob do
  let(:request_params){ {
                        "coords"=>"foo",
                        "bounds"=>"-122.341331, 47.657289, -122.310042, 47.693368",
                        "size"=>"400,400",
                        "client"=>"Chrome",
                        "query"=>"http://placekitten.com/200/200",
                        "url"=>"/Users/hsing-huihsu/Ada-class/capstone/parking_api/public/uploads/tmp/1397784381-15581-7614/export.png"
                        }
                      }
  let(:request) { Request.new(request_params) }

  before do
    request.get_overlay
  end

  it 'resets the url' do
    request = SaveRequestJob.perform(request_params)
    p request.overlay.inspect
    p "REQUEST", request
    expect(request.url).to eq 'bar'
  end


end