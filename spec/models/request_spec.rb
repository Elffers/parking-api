require 'spec_helper'

describe Request do

  describe "validations" do
    it { should validate_presence_of(:coords) }
    it { should validate_presence_of(:bounds) }
    it { should validate_presence_of(:client) }
    it { should validate_presence_of(:overlay) }


  end

end
