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

  def image_for(movie, img_style=:small)
    file = movie.has_image? ? movie.image.url(img_style) : 'placeholder.png'
    image_tag(file)
  end

  def cancel_form_path(movie)
    movie.new_record? ? movies_path : movie_path(movie)
  end

  def format_average_stars(movie)
    if movie.unreviewed?
      content_tag(:strong, 'No reviews yet!')
    else
      content_tag(:strong,
        pluralize(number_with_precision(movie.average_stars, precision: 1), 'star'))
    end
  end

end
