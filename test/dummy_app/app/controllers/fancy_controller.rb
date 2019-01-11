class FancyController < ApplicationController

  include ActionController::Live

  def index
    # Bundle is taken from somewhere else! It is not managed by complate-ruby
    complate("FrontPage", text: "Hello World!", bundle_path: Rails.root.join("../js/dist/bundle.js"))
  end

  def simple_jsx
    @text = "Hello World!"
    render layout: "jsx_layout" if params[:jsx_layout] == "1"
  end

  def partials_in_erb
  end

  def chunking
    @text = "This mode of operation supports chunking!"
    complate_stream(:simple_jsx)
  end

end
