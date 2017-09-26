module ApplicationHelper

  def title(title)
    content_for(:title, title) if title
  end

  def page_title
    title = content_for?(:title) ? "Jeff's Flix - #{content_for(:title)}" : "Jeff's Flix"
    content_tag(:title, title)
  end

end
