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
      @params = parse_www_encoded_form(req.query_string)
        .merge(parse_www_encoded_form(req.body))
        .merge(route_params)
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
      return {} if www_encoded_form.blank?

      all_params = {}
      URI::decode_www_form(www_encoded_form).each do |(key, val)|
        parsed_keys = parse_key(key)
        main_key = parsed_keys.shift
        pkeys_length = parsed_keys.length

        builds = []
        if pkeys_length.zero?
          builds << val
        else
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
        end

        if all_params.has_key?(main_key)
          all_params[main_key].merge!(builds.last)
        else
          all_params.merge!({ main_key => builds.last })
        end
      end

      all_params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      keys = key.split(/\]\[|\[|\]/)
    end
  end
end
