require File.expand_path("../test_helper.rb", __FILE__)

class Complate::Test < ActionDispatch::IntegrationTest

  def test_the_basics
    get "/fancy/index"
    content = css_select('.container span')[0].text
    assert_equal "Hello World!", content
  end

end
