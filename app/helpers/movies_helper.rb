module MoviesHelper

  def format_release_date(movie)
    "#{movie.released_on.to_s(:release_date)}" +
    " (#{time_ago_in_words(movie.released_on)})"
  end

end
