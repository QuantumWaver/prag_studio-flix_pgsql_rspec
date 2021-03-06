require 'rails_helper'

describe "A User" do

  it "is valid with example attributes" do
    user = User.new(user_attributes)
    expect(user.valid?).to eq(true)
  end

  it "has reviews" do
    user = User.new(user_attributes)
    movie1 = Movie.new(movie_attributes(title: "Iron Man"))
    movie2 = Movie.new(movie_attributes(title: "Superman"))

    review1 = movie1.reviews.new(stars: 5, location: "Garrett", comment: "Two thumbs up!")
    review1.user = user
    review1.save!

    review2 = movie2.reviews.new(stars: 3, location: "Garrett", comment: "Cool!")
    review2.user = user
    review2.save!

    expect(user.reviews).to include(review1)
    expect(user.reviews).to include(review2)
  end

  context "with favorites" do
    it "can have many favorite movies" do
      user = User.new(user_attributes)
      movie1 = Movie.new(movie_attributes)
      movie2 = Movie.new(movie_attributes(title: "Serenity"))

      user.favorites.new(movie: movie1)
      user.favorites.new(movie: movie2)

      expect(user.favorite_movies).to include(movie1)
      expect(user.favorite_movies).to include(movie2)
    end
  end

  context "has validation: it" do
    before do
      @new_user = User.new(user_attributes)
      @other_user = User.create!(user_attributes(name: "Alex", username: "alex", email: "alex@rush.com"))
    end

    it "requires a name" do
      @new_user.name = ""
      @new_user.valid?  # populates errors
      expect(@new_user.errors[:name].any?).to eq(true)
    end

    it "requires a valid username" do
      @new_user.username = ""
      @new_user.valid?  # populates errors
      expect(@new_user.errors[:username].any?).to eq(true)
      @new_user.username = " " * 8
      @new_user.valid?  # populates errors
      expect(@new_user.errors[:username].any?).to eq(true)
    end

    it "requires a username to be at least 3 characters" do
      @new_user.username = "aa"
      @new_user.valid?  # populates errors
      expect(@new_user.errors[:username].any?).to eq(true)
    end

    it "saves usernames as lowercase" do
      mixed_case_username = "RiCHaRd.FeYnMAN"
      @new_user.username = mixed_case_username
      @new_user.save
      @new_user.reload
      expect(@new_user.username).to eq(mixed_case_username.downcase)
    end

    it "forces unique usernames" do
      @new_user.username = @other_user.username.upcase
      @new_user.valid?  # populates errors
      expect(@new_user.errors[:username].any?).to eq(true)
    end

    it "does not allow existing email address as username" do
      @new_user.username = @other_user.email
      @new_user.valid?  # populates errors
      expect(@new_user.errors[:username].any?).to eq(true)
    end

    context "has slugs based on parametrerized usernames by" do
      it "forcing slugs to be unique" do
        @new_user.slug = @other_user.slug
        @new_user.valid?  # populates errors
        expect(@new_user.errors[:slug].any?).to eq(true)
      end

      it "generating a slug on validation if needed" do
        @new_user.username = "Jeff.Sholl"
        expect do
          expect(@new_user).to be_valid
        end.to change{@new_user.slug}.from(nil).to('jeff-sholl')
      end

      it "rejecting invalid slugs on validation" do
        invalid_slugs = ['', 'My Slug', 'My@slug', 'my.slug', 'my$slug', 'my;;slug', 'MY-SLUG']
        invalid_slugs.each do |invalid_slug|
          @new_user.slug = invalid_slug
          expect(@new_user).not_to be_valid, "#{invalid_slug.inspect} should be invalid"
          expect(@new_user.errors[:slug].any?).to eq(true)
        end
      end

      it "accepting valid slugs on validation" do
        valid_slugs = %w[myslug my_slug my-slug my_slug-69]
        valid_slugs.each do |valid_slug|
          @new_user.slug = valid_slug
          expect(@new_user).to be_valid, "#{valid_slug.inspect} should be valid"
        end
      end
    end

    it "requires an email" do
      @new_user.email = ""
      @new_user.valid?  # populates errors
      expect(@new_user.errors[:email].any?).to eq(true)
    end

    it "accepts valid email address" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @new_user.email = valid_address
        @new_user.valid?  # populates errors
        expect(@new_user.errors[:email].any?).to eq(false), "#{valid_address.inspect} should be valid"
      end
    end

    it "rejects invalid email address" do
      invalid_addresses = %w[foo @hdss foo@co user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        @new_user.email = invalid_address
        @new_user.valid?  # populates errors
        expect(@new_user.errors[:email].any?).to eq(true), "#{invalid_address.inspect} should be invalid"
      end
    end

    it "forces email addresses to be unique" do
      duplicate_user = @new_user.dup
      duplicate_user.email = @new_user.email.upcase
      @new_user.save
      duplicate_user.valid?
      expect(duplicate_user.errors[:email].any?).to eq(true)
    end

    it "forces email addresses to be saved to db in lower case" do
      user_email = @new_user.email
      @new_user.email.upcase!
      @new_user.save
      @new_user.reload
      expect(@new_user.email).to eq(user_email.downcase)
    end

    it "requires a password" do
      user = User.new(password: nil)
      user.valid?  # populates errors
      expect(user.errors[:password].any?).to eq(true)
      user = User.new(password: "")
      user.valid?  # populates errors
      expect(user.errors[:password].any?).to eq(true)
    end

    it "requires a password to not be spaces" do
      user = User.new(password: " " * 8)
      user.valid?  # populates errors
      expect(user.errors[:password].any?).to eq(true)
    end

    it "requires a password to be at least 6 characters" do
      user = User.new(password: "a" * 5)
      user.valid?  # populates errors
      expect(user.errors[:password].any?).to eq(true)
    end

    it "requires a password confirmation when a password is present" do
      @new_user.password = "secret"
      @new_user.password_confirmation = ""
      @new_user.valid?
      expect(@new_user.errors[:password_confirmation].any?).to eq(true)
    end

    it "requires the password to match the password confirmation" do
      @new_user.password = "secret"
      @new_user.password_confirmation = "nomatch"
      @new_user.valid?
      expect(@new_user.errors[:password_confirmation].first).to eq("doesn't match Password")
    end

    it "does not require a password when updating" do
      user = User.create!(user_attributes)
      user.password = ""
      expect(user.valid?).to eq(true)
    end

    it "automatically encrypts the password into the password_digest attribute" do
      user = User.new(password: "secret")
      expect(user.password_digest.present?).to eq(true)
    end
  end

  context "authenticate" do
    before do
      @user = User.create!(user_attributes)
    end

    it "returns non-true value if the email does not match" do
      expect(User.authenticate("emailnomatch", @user.password)).to be_falsy
    end

    it "returns non-true value if the password does not match" do
      expect(User.authenticate(@user.email, "passnomatch")).to be_falsy
    end

    it "returns the user if the email and password match" do
      expect(User.authenticate(@user.email, @user.password)).to eq(@user)
    end
  end

  context "can query" do
    before do
      @admin = User.create!(user_attributes(name: "Geddy", username: "ged", email: "ged@rush.com", admin: true))
      @user1 = User.create!(user_attributes(name: "Neil", username: "neil", email: "neil@rush.com"))
      @user2 = User.create!(user_attributes(name: "Alex", username: "alex", email: "alex@rush.com"))
    end

    it "all non-admins ordered by name" do
      non_admins = User.non_admins
      expect(non_admins).to eq([@user2, @user1])
    end

    it "all the admins" do
      admins = User.admins
      expect(admins).to eq([@admin])
    end

  end

end