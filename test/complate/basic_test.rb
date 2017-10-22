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

  def test_that_its_possible_to_load_additional_scripts
    renderer = Complate::Renderer.new('test/dist/simple_bundle.js', 'test/dist/additional_scripts.js')
    assert_equal 'Add: 21', capture(renderer.render('add', 10, 11))
  end

  def test_that_streaming_basically_works
    index = 0
    @renderer.render('streaming').each do |s|
      assert_equal "Block #{index}", s
      index += 1
    end
    assert_equal 3, index
  end

end
