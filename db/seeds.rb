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
    released_on: "2008-05-02"
  },
  {
    title: "Star Wars",
    rating: "PG",
    total_gross: 134218018.00,
    description: "Luke, Han, Chewie, and Leia battle the Empire!",
    released_on: "1977-07-15"
  },
  {
    title: "Serenity",
    rating: "PG-13",
    total_gross: 403706375.00,
    description: " Malcum Reynolds and crew pilot a Firefly class ship called Serenity",
    released_on: "2002-05-03"
  },
  {
    title: "Catwoman",
    rating: "PG-13",
    total_gross: 40200000.00,
    description: "Patience Philips has a more than respectable career as a graphic designer",
    released_on: "2004-07-23"
  },
  {
    title: "Blade Runner",
    rating: "R",
    total_gross: 413452101.00,
    description: "Harrison Ford plays a dude named Decker, I think, and hunts fucking replicants or some such shit",
    released_on: "1982-01-21"
  }
])