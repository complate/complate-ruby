require File.expand_path("../test_helper.rb", __FILE__)

class Complate::Test < ActionDispatch::IntegrationTest

  def test_the_basics
    get "/fancy/index"
    content = css_select('.container span').text
    assert_equal "Hello World!", content
  end

  def test_jsx_view_files
    get "/fancy/jsx"
    content = css_select('span').text
    assert_equal "Hello World!", content
  end

  def test_valid_content
    get "/fancy/jsx"
    assert_equal 1, response_body_if_short.scan(/<!DOCTYPE/).size
    assert_no_match /\[object Object\]/, response_body_if_short
    assert_no_match /&gt;|&lt;/, response_body_if_short
  end

  def test_jsx_layouts
    get "/fancy/jsx?jsx_layout=1"
    content = css_select('span')[0].text
    assert_equal "Hello World!", content
  end

  def test_jsx_layouts_return_valid_content
    get "/fancy/jsx?jsx_layout=1"
    assert_equal 1, response_body_if_short.scan(/<!DOCTYPE/).size
    assert_no_match /\[object Object\]/, response_body_if_short
    assert_no_match /&gt;|&lt;/, response_body_if_short
  end

end
