require 'spec_helper'

describe MoviesController do
  render_views
  
  describe "GET 'index'" do
    it "should be successful" do
        get :index
        response.should be_success
    end
                      
    it "should sort" do
        get :index, :sort => "released_date"
        response.status.should be 302
    end
                                              
    it "should filter" do
        get :index, :ratings =>{"R"=>1}
        response.status.should be 302
    end
  end
  
  describe "POST 'create'" do
     before(:each) do
          @attr = { :title => "Example User", 
            :rating => "user@example.com",
            :director => "foobar",
            :release_date => "1977-05-25" 
          }
     end
                                                                              
     it "should create a movie" do
        lambda do
            post :create, :movie => @attr
        end.should change(Movie, :count).by(1)
     end
  end
  
  describe "GET 'show'" do
    before(:each) do
      @movie = Factory(:movie)
    end
    it "should be successful" do
      get :show, :id => @movie.id
      response.should be_success
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @movie = Factory(:movie)
    end
                      
    it "should be successful" do
      get :edit, :id=>@movie.id
      response.should be_success
    end
  end
                                            
describe "PUT 'update'" do
    before(:each) do
        @movie = Factory(:movie)
    end
                    
    describe "success" do
      before(:each) do
          @attr = { :title => "New Title", :rating => "X",
          :director => "New Director", :release_date => "1-1-2099" }
      end
                                                            
      it "should change the movie's attributes" do
        put :update, :id => @movie, :movie => @attr
        @movie.reload
        @movie.title.should == @attr[:title]
        @movie.rating.should == @attr[:rating]
        @movie.director.should == @attr[:director]
        @movie.release_date.should == @attr[:release_date]
      end      
    end
end

describe "DELETE 'destroy'" do
    before(:each) do
            @movie = Factory(:movie)
    end
    it "should destroy the user" do
      lambda do
          delete :destroy, :id => @movie
      end.should change(Movie, :count).by(-1)
    end
end
                                        
  describe 'searching Similar Movies by Director' do
    before(:each) do
      @movie = Factory(:movie)
    end
    
#    it "should call model with director" do
#      movie = Movie.create!(:title => "Star Wars: A New Hope", :rating => "PG", :director => "George Lucas")
#      Movie.should_receive(:where).with(:director => "George Lucas")
#      get :same_director, :id => movie.id
#    end
    
#    it 'should controller method to receive the click on "Find With Same Director"'
    
    it 'should not select the same director template for rendering for sad path' do
      movie = Factory(:movie, :director => "")
      post :same_director, {:id => movie.id}
      response.should_not render_template('same_director')
    end
    
    it 'should make the similar director search results available to that template' do
      fake_results = [@movie, Factory(:movie), Factory(:movie)]
      Movie.stub(:same_director).and_return(fake_results)
      post :same_director, {:id => '1'}
      # look for controller method to assign @movies
      assigns(:movies).should == fake_results
    end
  end
end