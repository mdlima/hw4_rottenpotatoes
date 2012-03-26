require 'spec_helper'

describe MoviesController do
  render_views
  
	describe "GET 'index'" do

		it "should be successful" do
			get :index
			response.should be_success
		end
		
    # it 'should have an element for each movie'

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
		
  #     it "should have a title field" do
  #       get :new
  #       response.body.should have_selector("input[name='movie[title]'][type='text']")
  #     end
  #     
  #     it "should have a rating field" do
  #       get :new
  #       response.body.should have_selector("input[name='movie[rating]'][type='select']")
  #     end
  #     
  #     it "should have a description field" do
  #       get :new
  #       response.body.should have_selector("input[name='movie[description]'][type='text']")
  #     end
  #     
  #     it "should have a release date field" do
  #       get :new
  #       response.body.should have_selector("input[name='movie[release_date]'][type='text']")
  #     end
  #     
  #     it "should have a director field" do
  #       get :new
  #       response.body.should have_selector("input[name='movie[director]'][type='text']")
  #     end
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
  		 flash[:notice].should =~ /#{@attr[:title]} was successfully created./i
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
		 @movie.title.should        == @attr[:title]
		 @movie.rating.should       == @attr[:rating]
		 @movie.description.should  == @attr[:description]
     # @movie.release_date.should == @attr[:release_date]
		 @movie.director.should     == @attr[:director]
	 end

	 it "should redirect to the movie show page" do
		 put :update, :id => @movie, :movie => @attr
		 response.should redirect_to(movie_path(@movie.id))
	 end

	 it "should have a flash message" do
		 put :update, :id => @movie, :movie => @attr
		 flash[:notice].should =~ /#{@attr[:title]} was successfully updated./
	 end
  end

  describe "DELETE 'destroy'" do

   before(:each) do
     @movie = create :movie
   end

   it "should destroy the movie" do
     lambda do
       delete :destroy, :id => @movie
     end.should change(Movie, :count).by(-1)
   end

   it "should redirect to the movies page" do
     delete :destroy, :id => @movie
     response.should redirect_to(movies_path)
   end

  end

  describe "sorting movies" do
    
    before :each do
      create :movie
      create :movie, :title => "AAA", :release_date => 10.months.ago
    end
    
    it "should sort movies by title" do
      session[:ratings] = Hash[Movie.all_ratings.map {|r| [r,"1"]}]
      session[:sort] = 'title'
      get :index, :ratings => session[:ratings], :sort => session[:sort]
			response.should be_success
    end
    
    it "should sort movies by release date" do
      session[:ratings] = Hash[Movie.all_ratings.map {|r| [r,"1"]}]
      session[:sort] = 'release_date'
      get :index, :ratings => session[:ratings], :sort => session[:sort]
			response.should be_success
    end
    
    it "should keep sorting by title when navigating to index" do
      session[:ratings] = Hash[Movie.all_ratings.map {|r| [r,"1"]}]
      session[:sort] = 'title'
      get :index
      response.code.should == "302"
      response.should redirect_to :ratings => session[:ratings], :sort => session[:sort]
    end
    
    it "should keep sorting by release when navigating to index" do
      session[:ratings] = Hash[Movie.all_ratings.map {|r| [r,"1"]}]
      session[:sort] = 'release_date'
      get :index
      response.code.should == "302"
      response.should redirect_to :ratings => session[:ratings], :sort => session[:sort]
    end
    
    
    it "should keep ratings filter when navigating to index" do
      session[:ratings] = Hash[Movie.all_ratings.map {|r| [r,"1"]}]
      session[:sort] = 'release_date'
      get :index, :sort => session[:sort]
      response.code.should == "302"
      response.should redirect_to :ratings => session[:ratings], :sort => session[:sort]
    end
  end

  describe "finding related movies" do
    
    before :each do
      @movie = create :movie
      @related_movie = create :movie, :title => "Related Movie", :director => @movie.director
    end
    
    it "should find movies with same director" do
      get :find_with_same_director, :id => @movie
      response.body.should have_content @related_movie.title
    end
    
    it "should show a message for a movie with no director" do
      @other_movie = create :movie, :title => "Other Movie", :director => ""
      get :find_with_same_director, :id => @other_movie
      response.code.should == "302"
      response.should redirect_to root_path
    end
  end
end