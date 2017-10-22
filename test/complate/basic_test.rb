require 'test_helper'

class Complate::BasicTest < Minitest::Test
  def setup
    @renderer = Complate::Renderer.new('test/dist/simple_bundle.js')
  end

  def test_that_it_has_a_version_number
    refute_nil ::Complate::VERSION
  end

  def test_that_simple_js_calls_work
    assert_equal 'Arguments: 1, 2, 3', capture(@renderer.render('1', '2', '3'))
  end

  def test_additional_scripts
    renderer = Complate::Renderer.new('test/dist/simple_bundle.js', 'test/dist/additional_scripts.js')
    assert_equal 'Add: 21', capture(renderer.render('add', 10, 11))
  end

end
