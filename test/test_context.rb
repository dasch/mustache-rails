require 'mustache_test'

class TestContext < MustacheTest
  def test_template_name
    assert_equal "template_name", @view.render(:template => "template_name")
  end

  def test_view_helper_method
    assert_equal "<strong>Josh</strong>", @view.render(:template => "view_helper_method")
  end

  def test_render_partial_from_view
    assert_equal "Hello, Josh!", @view.render(:template => "view_helper_render_partial", :locals => { :name => "Josh" })
  end

  def test_view_class_method
    assert_equal "Hello, World!", @view.render(:template => "hello")
  end

  def test_local_shaddows_view_class_method
    assert_equal "Hello, Josh!", @view.render(:template => "hello", :locals => { :name => "Josh" })
  end

  def test_render_nested_objects
    assert_equal "<h1>Category A</h1>\n<h2>Topic 1</h2>\n<h1>Category B</h1>\n",
      @view.render(:template => "nested")
  end

  def test_render_with_layout
    assert_equal "<!DOCTYPE html>\n<title>Hello</title>\nHello, World!\n",
      @view.render(:template => "hello", :layout => "application")
  end
end
