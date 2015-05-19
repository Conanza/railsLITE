require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req
        .cookies
        .select { |cookie| cookie.name == "_rails_lite_app" }
        .first

      @cookie_val = cookie.nil? ? {} : JSON.parse(cookie.value)
    end

    # grants ability to manipulate the cookie
    def [](key)
      @cookie_val[key]
    end

    def []=(key, val)
      @cookie_val[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    # i.e
    # save any changes made to the cookie and turn it back to json
    # store the cookie in our response
    def store_session(res)
      new_cookie = WEBrick::Cookie.new("_rails_lite_app", @cookie_val.to_json)

      res.cookies << new_cookie
    end
  end
end
