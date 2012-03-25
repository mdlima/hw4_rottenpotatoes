require 'spec_helper'

describe MoviesController do
  
	describe "GET 'index'" do

		it "should be successful" do
			get :index
			response.should be_success
		end
		
    it 'should have an element for each movie'

  end
  
  describe "GET 'show'" do
    
    before(:each) do
			@movie = create :movie
		end

		it "should be successful" do
			get :show, :id => @movie
			response.should be_success
		end

		it "should find the right movie" do
			get :show, :id => @movie
			assigns(:movie).should == @movie
		end

	end
  
	describe "GET 'new'" do
		
		it "should be successful" do
			get :new
			response.should be_success
		end
		
		it "should have a title field" do
			get :new
			response.should have_selector("input[name='movie[title]'][type='text']")
		end

		it "should have a rating field" do
			get :new
			response.should have_selector("input[name='movie[rating]'][type='select']")
		end

		it "should have a description field" do
			get :new
			response.should have_selector("input[name='movie[description]'][type='text']")
		end

		it "should have a release date field" do
			get :new
			response.should have_selector("input[name='movie[release_date]'][type='text']")
		end

		it "should have a director field" do
			get :new
			response.should have_selector("input[name='movie[director]'][type='text']")
		end
	end  

  describe "POST 'create'" do

    before(:each) do
      # t.string   "title"
      # t.string   "rating"
      # t.text     "description"
      # t.datetime "release_date"
      # t.string   "director"
      @attr = { :title => "Example Movie", :rating => "PG", :description => "Ecample Movie Description", :release_date => Time.now, :director => "Director" }
    end

  	 it "should create a movie" do
  		 lambda do
  			 post :create, :movie => @attr
  		 end.should change(Movie, :count).by(1)
  	 end

  	 it "should redirect to the user show page" do
			 post :create, :movie => @attr
  		 response.should redirect_to(movies_path)
  	 end		
	 
  	 it "should have a welcome message" do
			 post :create, :movie => @attr
  		 flash[:success].should =~ /movie created/i
  	 end

  end
  
  describe "GET 'edit'" do

    before(:each) do
      @movie = create :movie
    end

    it "should be successful" do
      get :edit, :id => @movie
      response.should be_success
    end

  end

  describe "PUT 'update'" do

	 before(:each) do
     @movie = create :movie
     @attr = { :title => "Example Movie 2", :rating => "R", :description => "Ecample Movie 2 Description", :release_date => Time.now, :director => "Director 2" }
	 end

	 it "should change the movie's attributes" do
		 put :update, :id => @movie, :movie => @attr
		 @movie.reload
		 @movie.name.should	 == @attr[:name]
		 @movie.email.should == @attr[:email]
	 end

	 it "should redirect to the movie show page" do
		 put :update, :id => @movie, :movie => @movie
		 response.should redirect_to(movie_path(@movie))
	 end

	 it "should have a flash message" do
		 put :update, :id => @movie, :movie => @attr
		 flash[:success].should =~ /updated/
	 end
  end

end