require 'test_helper'

class Complate::ComplateJsTest < Minitest::Test
  def setup
    @renderer = Complate::Renderer.new('test/js/dist/bundle.js')
  end

  def test_simple_complate_rendering
    s = capture(@renderer.render('FrontPage'))
    assert_equal "<!DOCTYPE html>\n<div class=\"container\"><span>lorem ipsum</span></div>", s
  end

end
