# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
#    debug movie
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
#  %{Then I should see /.*#{e1}.*#{e2}/}
  n1 = page.body.index(e1)
  n2 = page.body.index(e2)
  
  n1.should > n2
#  assert page.body =~ /.*#{e1}.*#{e2}/
#  p page.body =~ /.*#{e1}.*#{e2}/, "Wrong order of elements"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |un, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    (un) ? uncheck("ratings_#{rating}") : check("ratings_#{rating}")
  end
end

Then /I should see only following ratings: (.*)/ do |rating_list|
  rating_is = rating_list.split(',')
  rating_not = Movie.all_ratings - rating_a
  
#  rec_count =  Movie.find(:all, :conditions => {:rating => rating_a}).count()
#   page.find(:xpath, "//tbody[@id=\"movielist\"][count(tr)=#{rec_count}]")

  r = page.find(:xpath, "//table[@id=\"movies\"]/tbody/*/td[2]/text()")
end

Then /I should (not )?see movies rated: (.*)/ do |no, rating_list|
  # ensure elements are (not)? visible by comparing
  #  number of movies in the database, with the one shown
  # Then I should see PG,R movies
    ratings = rating_list.split(",").uniq
    s = page.find(:xpath, "//table[@id=\"movies\"]/tbody").all(:xpath, "./*/td[2]/text()")
    b = true
    a = []
    s.each do |r|
      a.push(r.text)
    end
    a.uniq!
    
    if no
      b = (ratings - a) == ratings
    else
      b = (a + ratings).uniq == a
    end
    print ratings, " ", a, " ", b, " ",no
    
    assert b
end
               
When /I (un)?check all ratings$/ do |un|
  Movie.all_ratings.each do |r|
    (un) ? uncheck("ratings_#{r}") : check("ratings_" + r)
  end
end

Then /I should (not )?see all of the movies/ do |n|
  rec_count = 0
  rec_count = Movie.all.count() if not n
  assert page.has_xpath?("//tbody[@id=\"movielist\"][count(tr) = #{rec_count}]")
end

Then /the director of "(.*)" should be "(.*)"/ do |e1, e2|
  direc=Movie.find_by_title(e1).director
  assert_equal(direc, e2, "Did not match movie with director")  
end  



