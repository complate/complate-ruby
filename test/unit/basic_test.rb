require File.expand_path("../../test_helper.rb", __FILE__)

class Complate::BasicTest < Minitest::Test
  def setup
    @renderer = Complate::Renderer.new('test/js/dist/simple_bundle.js')
    @logger = Minitest::Mock.new
    @renderer.logger = @logger
  end

  def test_that_it_has_a_version_number
    refute_nil ::Complate::VERSION
  end

  def test_that_simple_js_calls_work
    assert_equal 'Arguments: 1, 2, 3', @renderer.render('list', a: '1', b: '2', c: '3').to_s
  end

  def test_that_its_possible_to_load_additional_scripts
    renderer = Complate::Renderer.new(['test/js/dist/simple_bundle.js', 'test/js/dist/additional_scripts.js'])
    assert_equal 'Add: 21', renderer.render('add', a: 10, b: 11).to_s
  end

  def test_that_streaming_basically_works
    index = 0
    @renderer.render('streaming', {}).each do |s|
      assert_equal "Block #{index}", s
      index += 1
    end
    assert_equal 3, index
  end

  def test_that_rails_streaming_assumptions_actually_hold
    stream = @renderer.render('list', a: 1, b: 2, c: 3)
    assert_kind_of Enumerator, stream
  end

  def test_logging
    @logger.expect :info, nil, ['hello world']
    @renderer.render('hello', {}).to_s
    @logger.verify
  end
end
