require 'mustache_test'

class TestSpec < MustacheTest
  def self.define_test_method(test)
    define_method "test - #{test['name']}" do
      # setup_partials(test)
      assert_mustache_spec(test)
    end
  end

  def assert_mustache_spec(test)
    message = "#{test['desc']}\n"
    message << "Data: #{test['data'].inspect}\n"
    message << "Template: #{test['template'].inspect}\n"
    message << "Partials: #{(test['partials'] || {}).inspect}\n"

    result = @view.render({:inline => test['template'], :type => :mustache}, :locals => test['data'])
    assert_equal test['expected'], result, message
  end
end

path = File.expand_path("../spec/specs/*.yml", __FILE__)
Dir[path].each do |file|
  spec = YAML.load_file(file)
  name = File.basename(file, '.yml').gsub(/-|~/, "").capitalize

  next if name == 'Lambdas'

  # TODO: Fix these
  next if name == 'Delimiters'
  next if name == 'Interpolation'
  next if name == 'Inverted'
  next if name == 'Partials'
  next if name == 'Sections'

  klass_name = "Test#{name}Spec"
  instance_eval "class ::#{klass_name} < TestSpec; end"
  test_suite = Kernel.const_get(klass_name)

  spec['tests'].each do |test|
    test_suite.define_test_method(test)
  end
end
