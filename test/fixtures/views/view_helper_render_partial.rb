class ViewHelperRenderPartial < ActionView::Mustache
  def render_name_partial
    render :partial => "hello"
  end
end
