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

# Create some Users
User.create!([
  {
    name: "Geddy Lee",
    username: "ged",
    email: "ged@rush.com",
    password: "foobar",
    password_confirmation: "foobar",
    admin: true
  },
  {
    name: "Alex Lifeson",
    username: "alex",
    email: "alex@rush.com",
    password: "foobar",
    password_confirmation: "foobar",
    admin: false
  }
])

# Create some reviews
ged = User.find_by(username: 'ged')
alex = User.find_by(username: 'alex')
movie = Movie.find_by(title: 'Iron Man')
movie.reviews.create!(user_id: ged.id, stars: 3, location: "Garrett, IN", comment: "I laughed, I cried, I spilled my popcorn!")
movie.reviews.create!(user_id: alex.id, stars: 5, location: "Cincinnati, OH", comment: "I'm a better reviewer than he is.")

movie = Movie.find_by(title: 'Star Wars: The Force Awakens')
movie.reviews.create!(user_id: ged.id, stars: 5, location: "Jackson Hole, WY", comment: "I loved it, though Rey was a bit overpowered.")
movie.reviews.create!(user_id: alex.id, stars: 5, location: "Jackson Hole, WY", comment: "Overall it was a good movie, though I am sexually attracted to Poe!")
