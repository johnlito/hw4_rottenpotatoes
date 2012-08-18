require 'spec_helper'
describe "RESTful route for Find Similar Movies" do
  it "routes /movies/:id/same_director to movies#same_director for movie" do
    expect(:get => "/movies/1/same_director").to route_to(
      :controller => "movies",
      :action => "same_director",
      :id => "1"
    )
  end
                              
  it "does not expose a list of movies" do
    expect(:get => "/movie/some_director").not_to be_routable
  end
end