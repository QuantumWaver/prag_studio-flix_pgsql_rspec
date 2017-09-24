# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Movie.create!([
  {
    title: "Iron Man",
    rating: "PG-13",
    total_gross: 318412101.00,
    description: "Tony Stark builds an armored suit to fight the throes of evil",
    released_on: "2008-05-02",
    cast: "Robert Downey Jr., Gwyneth Paltrow and Terrence Howard",
    director: "Jon Favreau",
    duration: "126 min",
    image_file_name: "ironman.jpg"
  },
  {
    title: "Star Wars: The Empire Strikes Back",
    rating: "PG",
    total_gross: 192012121.00,
    duration: "124 min",
    cast: "Mark Hamill, Harrison Ford, Carrie Fisher",
    director: "Irvin Kershner",
    description: "Once again Luke, Han, Leia, and Chewie battle the empire, but this time Han gets his ass frozen in carbonite!",
    released_on: "1980-05-20",
    image_file_name: "empire_strikes_back.jpg"
  },
  {
    title: "Serenity",
    rating: "PG-13",
    total_gross: 403706375.00,
    duration: "126 min",
    description: " Malcum Reynolds and crew pilot a Firefly class ship called Serenity",
    released_on: "2002-05-03"
  },
  {
    title: "Catwoman",
    rating: "PG-13",
    total_gross: 40200000.00,
    description: "Patience Philips has a more than respectable career as a graphic designer",
    released_on: "2004-07-23",
    cast: "Halle Berry, Sharon Stone and Benjamin Bratt",
    director: "Jean-Christophe 'Pitof' Comar",
    duration: "101 min",
    image_file_name: "catwoman.jpg"
  },
  {
    title: "Star Wars: The Force Awakens",
    rating: "PG-13",
    total_gross: 121010001.00,
    duration: "126 min",
    cast: "Daisy Ridley, John Boyega, Oscar Isaac",
    director: "J.J. Abrams",
    description: "Three decades after the Empire's defeat, a new threat arises in the militant First Order. Stormtrooper defector Finn and spare parts scavenger Rey are caught up in the Resistance's search for the missing Luke Skywalker.",
    released_on: "2015-12-15",
    image_file_name: "force_awakens.jpg"
  }
])

# Create some reviews
movie = Movie.find_by(title: 'Iron Man')
movie.reviews.create!(name: "Roger Ebert", stars: 3, location: "Garrett, IN", comment: "I laughed, I cried, I spilled my popcorn!")
movie.reviews.create!(name: "Gene Siskel", stars: 5, location: "Cincinnati, OH", comment: "I'm a better reviewer than he is.")
movie.reviews.create!(name: "Peter Travers", stars: 4, location: "Garrett, IN", comment: "It's been years since a movie superhero was this fierce and this funny.")

movie = Movie.find_by(title: 'Serenity')
movie.reviews.create!(name: "Elvis Mitchell", stars: 5, location: "Jackson Hole, WY", comment: "It's a bird, it's a plane, it's a blockbuster!")

movie = Movie.find_by(title: 'Star Wars: The Force Awakens')
movie.reviews.create!(name: "Jeff", stars: 5, location: "Jackson Hole, WY", comment: "I loved it, though Rey was a bit overpowered.")
movie.reviews.create!(name: "Jake P McGrew", stars: 5, location: "Jackson Hole, WY", comment: "Overall it was a good movie, though I am sexually attracted to Poe!")
movie.reviews.create!(name: "Drew Etienne", stars: 5, location: "Jackson Hole, WY", comment: "A great movie, but it sucks they did away with the old canon!")

User.create!([
  {
    name: "Geddy Lee",
    username: "ged",
    email: "ged@rush.com",
    password: "geddylee",
    password_confirmation: "geddylee",
    admin: true
  }
])