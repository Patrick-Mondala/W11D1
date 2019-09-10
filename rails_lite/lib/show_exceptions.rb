require 'erb'

class ShowExceptions
  attr_reader :app
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      var = @app.call(env)
    rescue => e
      var = Rack::Response.new
      var.status = "500"
      var["Content-type"] = "text/html"
      var.body = render_exception(e)
      var.finish
    end
  end

  private

  def render_exception(e)
    @error = e
    ERB.new(File.read('./lib/templates/rescue.html.erb')).result(binding)
  end

end
