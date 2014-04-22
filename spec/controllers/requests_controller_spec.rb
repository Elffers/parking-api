require 'spec_helper'

describe RequestsController do

  let(:valid_client_geodata) { {
                                "coords"=>"(47.6090198, -122.33356800000001)",
                                "bounds"=>"((47.60540305873747, -122.3389324180298), (47.61263629117663, -122.32820358197023))",
                                "size"=>"500,500",
                                }
                              }
  # Portland
  let(:invalid_client_geodata) { {
                                  "coords" => "(45.522691, -122.673044)",
                                  "bounds" => "((45.51972139168435, -122.67725739209595), (45.52573491524078, -122.6686743232483))",
                                  "size"=>"500,500"
                                  }
                                }

  describe 'POST create' do

    before do
      ResqueSpec.reset!
    end

    let(:request_object) { Request.new(valid_client_geodata) }
    let(:client){ double("Client") }

    # something with returning cached URL rather than API call if same client and within certain proximity

    context 'with valid bounds' do
      it 'is successful' do
        Request.any_instance.stub(:client).and_return client
        post :create, request: valid_client_geodata, format: :json
        expect(response.status).to eq 200
      end

      it 'sets the client' do
        Request.any_instance.stub(:client).and_return client
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
        Request.any_instance.stub(:client).and_return client
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
        geodata = invalid_client_geodata
        geodata.delete("coords")
        post :create, request: geodata, format: :json
        expect(response.status).to eq 400
      end
    end

    context 'request is out of range' do
      it 'returns 418 error if coords out of range' do
        Request.any_instance.stub(:client).and_return client
        post :create, request: invalid_client_geodata, format: :json
        expect(response.status).to eq 418
      end

      it 'returns dragon overlay url' do
        Request.any_instance.stub(:client).and_return client
        post :create, request: invalid_client_geodata, format: :json
        expect(response.body).to eq "https://s3-us-west-2.amazonaws.com/seattle-parking/dragons.png"
      end
    end
  end
end