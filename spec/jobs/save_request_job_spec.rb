require 'spec_helper'

describe SaveRequestJob do

  let(:zoomed_out_seattle){ {
                              "coords" => "(47.62862941481989, -122.39090529990231)",
                              "bounds" => "((47.5823335998115, -122.45956985068358), (47.674884258347305, -122.32224074912108))",
                              "size"=>"400,400",
                              "client"=>"Chrome",
                              }
                            }
  let(:portland){ {
                    "coords" => "(45.522691, -122.673044)",
                    "bounds" => "((45.51972139168435, -122.67725739209595), (45.52573491524078, -122.6686743232483))",
                    "size"=>"400,400",
                    "client"=>"Chrome",
                  }
                }
  let(:partly_in){ {
                    "coords" => "(47.7263275, -122.3520191)",
                    "bounds" => "((47.71477902988729, -122.36918523769532), (47.7378734102129, -122.3348529623047))",
                    "size"=>"400,400",
                    "client"=>"Chrome",
                    }
                  }

  let(:fully_in){ {
                    "coords" => "(47.67666029999999, -122.33759450000002)",
                    "bounds" => "((47.66510082328286, -122.35476063769534), (47.68821721639755, -122.32042836230471))",
                    "size"=>"400,400",
                    "client"=>"Chrome",
                  }
                }
  let(:valid1) { Request.new(fully_in) }
  let(:valid2) { Request.new(partly_in) }
  let(:invalid1) { Request.new(zoomed_out_seattle) }
  let(:invalid2) { Request.new(portland) }


  before do
    valid1.get_overlay
    valid2.get_overlay
    invalid1.get_overlay
    invalid2.get_overlay
  end

  describe 'with valid requests' do
    it 'saves the request' do
      p valid1.attributes
    end
  end

end