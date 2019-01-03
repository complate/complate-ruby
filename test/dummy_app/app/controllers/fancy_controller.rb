class FancyController < ApplicationController
  def index
    complate("FrontPage", text: "Hello World!")
  end
end
