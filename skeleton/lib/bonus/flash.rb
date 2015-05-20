require 'json'
require 'webrick'

class Flash
  def initialize(req)
    cookie = req
      .cookies
      .select { |cookie| cookie.name == "_rails_lite_app_flash" }
      .first

    @flash_now = cookie.nil? ? {} : JSON.parse(cookie.value)
    @flash = {}
  end

  def [](key)
    {}.merge(@flash_now).merge(@flash)[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def now
    @flash_now
  end

  def store_flash(res)
    new_cookie = WEBrick::Cookie.new(
      "_rails_lite_app_flash",
      @flash.to_json
    )

    new_cookie.path = "flashorsomething"

    res.cookies << new_cookie
  end
end
