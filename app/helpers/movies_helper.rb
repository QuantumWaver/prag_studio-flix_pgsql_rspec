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

  def image_for(movie)
    file = movie.image_file_name.blank? ? 'placeholder.png' : movie.image_file_name
    image_tag(file)
  end

  def cancel_form_path(movie)
    movie.new? ? movies_path : movie_path(movie)
  end

end
