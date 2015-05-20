require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = parse_www_encoded_form(req).merge(route_params)
    end

    def [](key)
      value = @params[key.to_sym]
      value ||= @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument formate
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      query_string = www_encoded_form.query_string
      body = www_encoded_form.body
      return {} if query_string.blank? && body.blank?

      all_params = {}

      [query_string, body].each do |param|
        next if param.blank?

        URI::decode_www_form(param).each do |(key, val)|
          # all_params[key] = val
          parsed_keys = parse_key(key)
          pkeys_length = parsed_keys.length

          builds = []
          (pkeys_length - 1).downto(0) do |i|
            temp_hash = {}
            current_key = parsed_keys[i]
            last_level = builds.pop

            if i == pkeys_length - 1
              temp_hash = { current_key => val }
            else
              temp_hash = { current_key => last_level }
            end

            builds << temp_hash
          end

          all_params.merge!(builds.last)
        end
      end
      p all_params
      all_params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      keys = key.split(/\]\[|\[|\]/)
    end
  end
end
