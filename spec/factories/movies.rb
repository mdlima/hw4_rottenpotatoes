# spec/factories/movie.rb

FactoryGirl.define do
  factory :movie do
    title         'A Fake Title' # default values
    rating        'PG'
    release_date  { 10.years.ago }
  	description   "Movie Description"
  	director      "Director"
  end
end