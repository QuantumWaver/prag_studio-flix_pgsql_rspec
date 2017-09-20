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
    title: "Star Wars",
    rating: "PG",
    total_gross: 134218018.00,
    duration: "126 min",
    description: "Luke, Han, Chewie, and Leia battle the Empire!",
    released_on: "1977-07-15"
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
    released_on: "2004-07-23"
    cast: "Halle Berry, Sharon Stone and Benjamin Bratt",
    director: "Jean-Christophe 'Pitof' Comar",
    duration: "101 min",
    image_file_name: "catwoman.jpg"
  },
  {
    title: "Blade Runner",
    rating: "R",
    total_gross: 413452101.00,
    duration: "126 min",
    description: "Harrison Ford plays a dude named Decker, I think, and hunts fucking replicants or some such shit",
    released_on: "1982-01-21"
  }
])

# Create some reviews
movie = Movie.find_by(title: 'Iron Man')
movie.reviews.create!(name: "Roger Ebert", stars: 3, location: "Garrett, IN", comment: "I laughed, I cried, I spilled my popcorn!")
movie.reviews.create!(name: "Gene Siskel", stars: 5, location: "Cincinnati, OH", comment: "I'm a better reviewer than he is.")
movie.reviews.create!(name: "Peter Travers", stars: 4, location: "Garrett, IN", comment: "It's been years since a movie superhero was this fierce and this funny.")

movie = Movie.find_by(title: 'Serenity')
movie.reviews.create!(name: "Elvis Mitchell", stars: 5, location: "Jackson Hole, WY", comment: "It's a bird, it's a plane, it's a blockbuster!")