require 'mustache_test'

class TestGeneratorLineNumbers < MustacheTest
  def test_etag
    assert_raise_on_line_number 1 do
      render "{{b00m}}"
    end

    assert_raise_on_line_number 1 do
      render "Hello, {{b00m}}!"
    end

    assert_raise_on_line_number 2 do
      render "Hello\n{{b00m}}!"
    end
  end

  def test_utag
    assert_raise_on_line_number 1 do
      render "{{{b00m}}}"
    end

    assert_raise_on_line_number 1 do
      render "Hello, {{{b00m}}}!"
    end

    assert_raise_on_line_number 2 do
      render "Hello\n{{{b00m}}}!"
    end
  end

  def test_section
    assert_raise_on_line_number 2 do
      render "{{#user}}\n{{b00m}}\n{{/user}}", :user => true
    end

    assert_raise_on_line_number 3 do
      render "{{#user}}\n{{/user}}\n{{b00m}}"
    end


    # TODO: Mustache parser doesn't disambiguate between trailing
    # whitespace after a section tag.
    #
    # assert_raise_on_line_number 1 do
    #   render "{{#user}}{{b00m}}\n{{/user}}", :user => true
    # end
    #
    # assert_raise_on_line_number 2 do
    #   render "{{#user}}{{/user}}\n{{b00m}}"
    # end
    #
    # assert_raise_on_line_number 1 do
    #   render "{{#user}}{{/user}}{{b00m}}"
    # end
  end

  def test_inverted
    assert_raise_on_line_number 2 do
      render "{{^user}}\n{{b00m}}\n{{/user}}", :user => false
    end

    assert_raise_on_line_number 3 do
      render "{{^user}}\n{{/user}}\n{{b00m}}"
    end

    # TODO: Mustache parser doesn't disambiguate between trailing
    # whitespace after a inverted tag.
    #
    # assert_raise_on_line_number 1 do
    #   render "{{^user}}{{b00m}}{{/user}}", :user => false
    # end
    #
    # assert_raise_on_line_number 2 do
    #   render "{{^user}}{{/user}}\n{{b00m}}"
    # end
    #
    # assert_raise_on_line_number 1 do
    #   render "{{^user}}{{/user}}{{b00m}}"
    # end
  end

  def render(text, context = {})
    context = { :b00m => lambda { raise "b00m" } }.merge(context)
    @view.render(:inline => text, :type => :mustache, :locals => context)
  end

  def assert_raise_on_line_number(line_number)
    begin
      yield
    rescue ActionView::Template::Error => e
      assert_equal line_number, e.line_number.to_i, e.annoted_source_code
    else
      flunk "No exception raised"
    end
  end
end
