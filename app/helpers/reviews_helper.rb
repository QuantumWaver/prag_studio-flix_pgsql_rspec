module ReviewsHelper

  def format_review_button(review)
    review.new_record? ? 'Post Review' : 'Update Review'
  end

end
