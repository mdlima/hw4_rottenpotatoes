require 'spec_helper'

describe Movie do

  before(:each) do
    # t.string   "title"
    # t.string   "rating"
    # t.text     "description"
    # t.datetime "release_date"
    # t.string   "director"
    @attr = { :title => "Example Movie", :rating => "PG", :description => "Ecample Movie Description", :release_date => Time.now, :director => "Director" }
  end
  
  it "should create a new instance given valid attributes" do
    Movie.create!(@attr)
  end
  

  
end