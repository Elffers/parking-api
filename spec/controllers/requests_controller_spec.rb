require 'spec_helper'

describe RequestsController do

  let(:valid_client_geodata) { {
                                "coords"=>"(47.6090198, -122.33356800000001)",
                                "bounds"=>"((47.60540305873747, -122.3389324180298), (47.61263629117663, -122.32820358197023))",
                                "size"=>"500,500",
                                }
                              }
  # Portland
  let(:portland) { {
                    "coords" => "(45.522691, -122.673044)",
                    "bounds" => "((45.51972139168435, -122.67725739209595), (45.52573491524078, -122.6686743232483))",
                    "size"=>"500,500",
                    }
                  }

  # Seattle zoomed out
  let(:zoomed_out){ {
                      "coords" => "(47.62862941481989, -122.39090529990231)",
                      "bounds" => "((47.5823335998115, -122.45956985068358), (47.674884258347305, -122.32224074912108))",
                      "size"=>"500,500",
                    }
                  }

  let(:zoomed_out_OR) { {
                        "coords" => "(45.5234515, -122.6762071)",
                        "bounds" => "((43.96294496792905, -124.873472725), (47.041843066686624, -120.478941475))",
                        "size"=>"500,500",
                        }
                      }
  describe 'POST create' do
    let(:client){ double("Client") }

    before do
      ResqueSpec.reset!
      Request.any_instance.stub(:client).and_return client
      client.stub(:include?).with("Parking App")
    end

    context 'with valid bounds' do
      it 'is successful' do
        post :create, request: valid_client_geodata, format: :json
        expect(response.status).to eq 200
      end

      it 'sets the client' do
        post :create, request: valid_client_geodata, format: :json
        expect(assigns(:request)).to be_valid
        expect(assigns(:request).client).to eq client
      end

      it 'gets overlay' do
        post :create, request: valid_client_geodata, format: :json
        response_json = JSON.parse(response.body)
        expect(response_json["coords"]).to eq valid_client_geodata["coords"]
        expect(response_json["overlay"]).to_not be_nil
      end

      it 'enqueues save job' do
        post :create, request: valid_client_geodata, format: :json
        SaveRequestJob.should have_queue_size_of(1)
      end

      it 'returns JSON' do
        post :create, request: valid_client_geodata, format: :json
        parsed_response = JSON.parse(response.body)
        expect { JSON.parse(response.body) }.to_not raise_error
        expect(parsed_response.class).to eq(Hash)
      end
    end

    context 'bad requests' do
      it 'returns 400 if param values are nil' do
        geodata = portland
        geodata.delete("coords")
        post :create, request: geodata, format: :json
        expect(response.status).to eq 400
      end
    end

    context 'map is zoomed out too far' do
      it 'returns an error' do
        post :create, request: zoomed_out, format: :json
        expect(response.status).to eq 400
      end

      it 'does not add request to saverequest queue' do
        post :create, request: zoomed_out, format: :json
        SaveRequestJob.should have_queue_size_of(0)
      end

      it 'shows ladiezzzz' do
        Request.any_instance.stub(:client).and_return client
        post :create, request: zoomed_out, format: :json
        expect(response.body).to eq "https://s3-us-west-2.amazonaws.com/seattle-parking/ladies.png"
      end
    end

    context 'request is out of range (of Seattle)' do
      it 'returns 418 error if coords out of range' do
        post :create, request: portland, format: :json
        expect(response.status).to eq 418
      end

      it 'does not add request to saverequest queue' do
        post :create, request: portland, format: :json
        SaveRequestJob.should have_queue_size_of(0)
      end

      it 'returns dragon overlay url' do
        post :create, request: portland, format: :json
        expect(response.body).to eq "https://s3-us-west-2.amazonaws.com/seattle-parking/dragons.png"
      end
    end

    context 'request is out of range and zoomed out' do
      it 'returns 418 error if coords out of range' do
        post :create, request: zoomed_out_OR, format: :json
        expect(response.status).to eq 418
      end

      it 'does not add request to saverequest queue' do
        post :create, request: zoomed_out_OR, format: :json
        SaveRequestJob.should have_queue_size_of(0)
      end

      it 'returns dragon overlay url' do
        post :create, request: zoomed_out_OR, format: :json
        expect(response.body).to eq "https://s3-us-west-2.amazonaws.com/seattle-parking/dragons.png"
      end
    end
  end
end