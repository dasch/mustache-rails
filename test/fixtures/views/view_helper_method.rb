class ViewHelperMethod < ActionView::Mustache
  def name
    "Josh"
  end

  def strong_name
    content_tag :strong, name
  end
end
