require 'rails_helper'

describe "A Movie" do

  it "is valid with example attributes" do
    movie = Movie.new(movie_attributes)
    expect(movie.valid?).to eq(true)
  end

  context "has validation as it" do
    it "requires a title" do
      movie = Movie.new(title: "  ")
      movie.valid?  # populates errors
      expect(movie.errors[:title].any?).to eq(true)
    end

    context "sets up constraints for slugs by" do
      before do
        @new_movie = Movie.new(movie_attributes)
        @existing_movie = Movie.create!(movie_attributes(title: "X-balls the Last Balls"))
      end

      it "requiring a unique title" do
        @new_movie.title = @existing_movie.title.upcase
        @new_movie.valid?  # populates errors
        expect(@new_movie.errors[:title].any?).to eq(true)
      end

      it "requiring a unique slug" do
        @new_movie.slug = @existing_movie.slug
        @new_movie.valid?  # populates errors
        expect(@new_movie.errors[:slug].any?).to eq(true)
      end

      it "generating a slug on validation if needed" do
        @new_movie.title = "X-Men New Movie"
        expect do
          expect(@new_movie).to be_valid
        end.to change{@new_movie.slug}.from(nil).to('x-men-new-movie')
      end

      it "rejecting invalid slugs on validation" do
        invalid_slugs = ['', 'My Slug', 'My@slug', 'my.slug', 'my$slug', 'my;;slug', 'MY-SLUG']
        invalid_slugs.each do |invalid_slug|
          @new_movie.slug = invalid_slug
          expect(@new_movie).not_to be_valid, "#{invalid_slug.inspect} should be invalid"
          expect(@new_movie.errors[:slug].any?).to eq(true)
        end
      end

      it "accepting valid slugs on validation" do
        valid_slugs = %w[myslug my_slug my-slug my_slug-69]
        valid_slugs.each do |valid_slug|
          @new_movie.slug = valid_slug
          expect(@new_movie).to be_valid, "#{valid_slug.inspect} should be valid"
        end
      end
    end

    it "requires a description" do
      movie = Movie.new(description: "")
      movie.valid?
      expect(movie.errors[:description].any?).to eq(true)
    end

    it "requires a released on date" do
      movie = Movie.new(released_on: "")
      movie.valid?
      expect(movie.errors[:released_on].any?).to eq(true)
    end

    it "requires a duration" do
      movie = Movie.new(duration: "")
      movie.valid?
      expect(movie.errors[:duration].any?).to eq(true)
    end

    it "requires a description over 24 characters" do
      movie = Movie.new(description: "X" * 24)
      movie.valid?
      expect(movie.errors[:description].any?).to eq(true)
    end

    it "accepts a $0 total gross" do
      movie = Movie.new(total_gross: 0.00)
      movie.valid?
      expect(movie.errors[:total_gross].any?).to eq(false)
    end

    it "accepts a positive total gross" do
      movie = Movie.new(total_gross: 10000000.00)
      movie.valid?
      expect(movie.errors[:total_gross].any?).to eq(false)
    end

    it "rejects a negative total gross" do
      movie = Movie.new(total_gross: -10000000.00)
      movie.valid?
      expect(movie.errors[:total_gross].any?).to eq(true)
    end

    it "attributes of image are set" do
      movie = Movie.new(movie_attributes)
      expect(movie).to be_valid
      expect(movie.image_content_type).to eq('image/jpeg')
      expect(movie.image_file_size).to eq(9511)
    end

    it "accepts any rating that is in an approved list" do
      ratings = %w[G PG PG-13 R NC-17]
      ratings.each do |rating|
        movie = Movie.new(rating: rating)
        movie.valid?
        expect(movie.errors[:rating].any?).to eq(false)
      end
    end

    it "rejects any rating that is not in the approved list" do
      ratings = %w[R-13 R-16 R-18 R-21]
      ratings.each do |rating|
        movie = Movie.new(rating: rating)
        movie.valid?
        expect(movie.errors[:rating].any?).to eq(true)
      end
    end
  end

  it "is a flop if the total gross is less than $50M" do
    movie = Movie.new(movie_attributes(total_gross: 49000000.00))

    expect(movie.flop?).to eq(true)
  end

  it "is a flop if the total gross is blank" do
    movie = Movie.new(movie_attributes(total_gross: nil))

    expect(movie.flop?).to eq(true)
  end

  it "is not a flop if the total gross exceeds $50M" do
    movie = Movie.new(movie_attributes(total_gross: 51000000.00))

    expect(movie.flop?).to eq(false)
  end

  it "is not a flop if the total gross is less than $50M and has cult following" do
    movie = Movie.create(movie_attributes(total_gross: 49000000.00))
    user = User.create!(user_attributes)

    1.upto(50) do
      movie.reviews.create(review_attributes(stars: rand(4..5), user: user))
    end

    expect(movie.flop?).to eq(false)
  end

  it "is released when the released on date is in the past" do
    movie = Movie.create(movie_attributes(released_on: 3.months.ago))
    expect(Movie.released).to include(movie)
  end

  it "is not released when the released on date is in the future" do
    movie = Movie.create(movie_attributes(released_on: 3.months.from_now))
    expect(Movie.released).not_to include(movie)
  end

  it "returns released movies ordered with the most recently-released movie first" do
    movie1 = Movie.create(movie_attributes(released_on: 3.months.ago))
    movie2 = Movie.create(movie_attributes(title: "movie2", released_on: 2.months.ago))
    movie3 = Movie.create(movie_attributes(title: "movie3", released_on: 1.months.ago))

    expect(Movie.released).to eq([movie3, movie2, movie1])
  end

  context "upcoming query" do
    it "returns the movies with a released on date in the future" do
      movie1 = Movie.create!(movie_attributes(released_on: 3.months.ago))
      movie2 = Movie.create!(movie_attributes(title: "movie2", released_on: 3.months.from_now))

      expect(Movie.upcoming).to eq([movie2])
    end
  end

  context "rated query" do
    it "returns released movies with the specified rating" do
      movie1 = Movie.create!(movie_attributes(released_on: 3.months.ago, rating: "PG"))
      movie2 = Movie.create!(movie_attributes(title: "movie2", released_on: 3.months.ago, rating: "PG-13"))
      movie3 = Movie.create!(movie_attributes(title: "movie3", released_on: 1.month.from_now, rating: "PG"))

      expect(Movie.rated("PG").released).to eq([movie1])
    end
  end

  context "recent query" do
    before do
      @movie1 = Movie.create!(movie_attributes(released_on: 3.months.ago))
      @movie2 = Movie.create!(movie_attributes(title: "movie2", released_on: 2.months.ago))
      @movie3 = Movie.create!(movie_attributes(title: "movie3", released_on: 1.month.ago))
      @movie4 = Movie.create!(movie_attributes(title: "movie4", released_on: 1.week.ago))
      @movie5 = Movie.create!(movie_attributes(title: "movie5", released_on: 1.day.ago))
      @movie6 = Movie.create!(movie_attributes(title: "movie6", released_on: 1.hour.ago))
      @movie7 = Movie.create!(movie_attributes(title: "movie7", released_on: 1.day.from_now))
    end

    it "returns a specified number of released movies ordered with the most recent movie first" do
      expect(Movie.recent(2)).to eq([@movie6, @movie5])
    end

    it "returns a default of 5 released movies ordered with the most recent movie first" do
      expect(Movie.recent).to eq([@movie6, @movie5, @movie4, @movie3, @movie2])
    end
  end

  context "with Reviews" do
    before do
      @user = User.create!(user_attributes)
    end

    it "can have many reviews" do
      movie = Movie.new(movie_attributes)

      review1 = movie.reviews.new(review_attributes(user: @user))
      review2 = movie.reviews.new(review_attributes(user: @user))

      expect(movie.reviews).to include(review1)
      expect(movie.reviews).to include(review2)
    end

    it "deletes all associated reviews" do
      movie = Movie.create(movie_attributes)

      movie.reviews.create(review_attributes(user: @user))

      expect {
        movie.destroy
      }.to change(Review, :count).by(-1)
    end

    it "calculates the average stars" do
      movie = Movie.create(movie_attributes)

      movie.reviews.create(review_attributes(stars: 5, user: @user))
      movie.reviews.create(review_attributes(stars: 3, user: @user))
      movie.reviews.create(review_attributes(stars: 1, user: @user))
      movie.reviews.create(review_attributes(stars: 2, user: @user))
      movie.reviews.create(review_attributes(stars: 4, user: @user))

      expect(movie.average_stars).to eq(3)
    end
  end

  context "with fans" do
    it "can have many fans" do
      movie = Movie.new(movie_attributes)

      user1 = User.new(user_attributes)
      user2 = User.new(user_attributes(name: "ged", username: "ged", email: "ged@rush.com"))

      movie.favorites.new(user: user1)
      movie.favorites.new(user: user2)

      expect(movie.fans).to include(user1)
      expect(movie.fans).to include(user2)
    end
  end

end