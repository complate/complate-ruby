class FancyController < ApplicationController
  def index
    old_path = Rails.configuration.complate.bundle_path
    Rails.configuration.complate.bundle_path = Rails.root.join("../js/dist/bundle.js")
    complate("FrontPage", text: "Hello World!")
  ensure
    Rails.configuration.complate.bundle_path = old_path if old_path
  end

  def jsx
    @text = "Hello World!"
    render layout: "jsx_layout" if params[:jsx_layout] == "1"
  end

end
