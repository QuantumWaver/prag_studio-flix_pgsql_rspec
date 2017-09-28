require 'rails_helper'

describe "Filtering movies" do

  it "shows hit or flop movies" do
    hit = Movie.create!(movie_attributes(title: "A Damn Great Movie", released_on: 1.day.ago, total_gross: 300_000_000))
    flop = Movie.create!(movie_attributes(title: "A Shit Movie", released_on: 1.day.ago, total_gross: 49_000_000))

    visit movies_url
    click_link "Hits"
    expect(current_path).to eq(filtered_movies_path(:hits))
    expect(page).to have_text(hit.title)
    expect(page).not_to have_text(flop.title)

    visit movies_url
    click_link "Flops"
    expect(current_path).to eq(filtered_movies_path(:flops))
    expect(page).to have_text(flop.title)
    expect(page).not_to have_text(hit.title)
  end

  it "shows upcoming or recent movies" do
    future = Movie.create!(movie_attributes(title: "Hold Your Fire", released_on: 1.day.from_now))
    recent = Movie.create!(movie_attributes(title: "Clockwork Angels", released_on: 1.day.ago))

    visit movies_url
    click_link "Upcoming"
    expect(current_path).to eq(filtered_movies_path(:upcoming))
    expect(page).to have_text(future.title)
    expect(page).not_to have_text(recent.title)

    visit movies_url
    click_link "Recent"
    expect(current_path).to eq(filtered_movies_path(:recent))
    expect(page).to have_text(recent.title)
    expect(page).not_to have_text(future.title)
  end
end