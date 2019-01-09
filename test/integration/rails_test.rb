require File.expand_path("../test_helper.rb", __FILE__)

class Complate::Test < ActionDispatch::IntegrationTest

  def test_the_basics
    get "/fancy/index"
    content = css_select('.container span')[0].text
    assert_equal "Hello World!", content
  end

  def test_jsx_view_files
    get "/fancy/jsx"
    content = css_select('span')[0].text
    assert_equal "Hello World!", content
  end

  def test_valid_html
    get "/fancy/jsx"
    assert_equal 1, response_body_if_short.scan(/<!DOCTYPE/).size
  end

end
