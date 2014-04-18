require 'spec_helper'

describe Request do
  let(:params) { { coords: "foo", bounds: "-122.341331, 47.657289, -122.310042, 47.693368", size: "400,400"}}
  let(:request) { Request.new(params) }

  describe "validations" do
    it { should validate_presence_of(:coords) }
    it { should validate_presence_of(:bounds) }
    it { should validate_presence_of(:client) }
    # it { should validate_presence_of(:overlay) }
  end

  describe '.get_overlay' do
  end

  describe '.set_client' do

  end

  describe '.request_params_to_query' do
  end

end
