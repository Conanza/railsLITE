require 'json'
require 'webrick'

class Flash
  def now

  end
end



class Session
  def initialize(req)
    cookie = req
      .cookies
      .select { |cookie| cookie.name == "_rails_lite_app" }
      .first

    @cookie_val = cookie.nil? ? {} : JSON.parse(cookie.value)
  end

  def [](key)
    @cookie_val[key]
  end

  def []=(key, val)
    @cookie_val[key] = val
  end

  def store_session(res)
    new_cookie = WEBrick::Cookie.new("_rails_lite_app", @cookie_val.to_json)

    res.cookies << new_cookie
  end
end
