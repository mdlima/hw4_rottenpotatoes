# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    
    Movie.create!(movie)
  end
  # assert false, "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  # assert false, "Unimplemented"
  regexp = Regexp.new(/(#{e1}){1}.*(#{e2}){1}/m)
  # puts page.body
  assert regexp.match(page.body)
  # step %Q{I should see /(#{e1}){1}.+(#{e2}){1}/m}
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |r|
    step %Q{I #{uncheck}check "ratings_#{r.strip}"}
  end
end

Then /I should (not )?see the movies/ do |neg, movies_table|
  movies_table.hashes.each do |movie|
    step %Q{I should #{neg}see "#{movie[:title]}"}
  end
  # assert false, "Unimplemented"
end

Then /I should (not )?see (all|any) of the movies/ do |neg, all|
  Movie.all.each do |movie|
    step %Q{I should #{neg}see "#{movie[:title]}"}
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |title, director|
  assert Movie.find_by_title(title).director == director, "Director not altered"
  step %Q{I should see "#{title}"}
end

