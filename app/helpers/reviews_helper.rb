module ReviewsHelper

  def format_review_button(review)
    review.id.nil? ? 'Post Review' : 'Update Review'
  end

end
