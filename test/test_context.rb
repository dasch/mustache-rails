require 'mustache_test'

class TestContext < MustacheTest
  def test_template_name
    assert_equal "template_name", @view.render(:template => "template_name")
  end

  def test_view_class_method
    assert_equal "Hello, World!", @view.render(:template => "hello")
  end

  def test_local_shaddows_view_class_method
    assert_equal "Hello, Josh!", @view.render(:template => "hello", :locals => { :name => "Josh" })
  end
end
