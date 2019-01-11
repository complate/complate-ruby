class FancyController < ApplicationController

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

  def custom_registration
    # This wont work in production mode if the view is placed outside rails view paths
    # since the view won't be added to the production bundle (with `rake complate:precompile`)
    id, compilate = Complate::TemplateHandler.register_source(Rails.root.join('app/views/fancy/simple_jsx.html.jsx'))
    complate(id, text: "This mode of operation supports chunking!", bundle_path: compilate.path)
  end

end
