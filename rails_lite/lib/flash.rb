require 'json'

class Flash
  attr_accessor :now
  
  def initialize(req)
    @now = (req.cookies["_rails_lite_app_flash"] ? JSON.parse(req.cookies["_rails_lite_app_flash"]) : {})
    @flash = {}
  end

  def [](key)
    self.now[key.to_s] || self.now[key]
  end

  def now
    @now.merge!(@flash)
  end

  def []=(key, val)
    @flash[key] = val
  end

  def store_flash(res)
    res.set_cookie("_rails_lite_app_flash", @flash.to_json)
  end
end