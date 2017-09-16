module MoviesHelper
  # any methods defined in this module will be automatically
  # accessible in any views

  def format_total_gross(movie)
    if movie.flop?
      content_tag(:strong, 'Flop!')
    else
      number_to_currency(movie.total_gross)
    end
  end

  def format_release_date(movie)
    "#{movie.released_on.to_s(:release_date)}" +
    " (#{time_ago_in_words(movie.released_on)})"
  end

end
