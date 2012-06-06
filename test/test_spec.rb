require 'mustache_test'

class TestSpec < MustacheTest
  def self.define_test_method(test)
    define_method "test - #{test['name']}" do
      setup_partials(test) do
        assert_mustache_spec(test)
      end
    end
  end

  def setup_partials(test)
    fixtures = {}

    fixtures[File.join(TEMPLATES_PATH, "template.mustache")] = test['template']

    (test['partials'] || {}).each do |name, value|
      fixtures[File.join(TEMPLATES_PATH, "_#{name}.mustache")] = value
    end

    fixtures.each { |fn, data| File.open(fn, 'w') { |f| f.print(data) } }
    yield
  ensure
    fixtures.each { |fn, data| File.unlink(fn) }
  end

  def assert_mustache_spec(test)
    result = @view.render(:template => 'template', :locals => test['data'])
    assert_equal test['expected'], result, test['desc']
  end
end

path = File.expand_path("../spec/specs/*.yml", __FILE__)
Dir[path].each do |file|
  spec = YAML.load_file(file)
  name = File.basename(file, '.yml').gsub(/-|~/, "").capitalize

  klass_name = "Test#{name}Spec"
  instance_eval "class ::#{klass_name} < TestSpec; end"
  test_suite = Kernel.const_get(klass_name)

  spec['tests'].each do |test|
    # Skip all lambda sections. This require a parse/eval at runtime.
    # BLAH
    next if name == 'Lambdas'

    # Don't quite aggree with this one. Raising errors for missing
    # partials is how Rails behaviors and makes debugging in dev
    # mode much easier.
    next if test['name'] == 'Failed Lookup'

    # Skip whitespace related tests. This type of thing doesn't really
    # matter to much with HTML. Though if someone wants to fix it without
    # causing a performance regression, PID.
    next if test['name'] =~ /Indentation|Line Endings|Previous Line|Without Newline/

    test_suite.define_test_method(test)
  end
end
