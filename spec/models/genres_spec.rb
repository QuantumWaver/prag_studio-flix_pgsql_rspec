require 'rails_helper'

describe "A Genre" do

  context "has validation as it" do
    before do
      @new_genre = Genre.new
    end

    it "requires a name" do
      @new_genre.name = ""
      @new_genre.valid?  # populates errors
      expect(@new_genre.errors[:name].any?).to eq(true)
    end

    it "forces a unique name" do
      genre = Genre.create!(name: "Genre1")
      @new_genre.name = genre.name.upcase
      @new_genre.valid?  # populates errors
      expect(@new_genre.errors[:name].any?).to eq(true)
    end
  end

end