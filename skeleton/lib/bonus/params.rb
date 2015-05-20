require 'uri'

class Params
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

  def permit(*keys)
    @permitted_params ||= {}

    keys.each { |key| @permitted_params[key] = @params[key] }
  end

  def permitted?(key)
    @permitted_params.has_key?(key)
  end

  def require(key)
    raise AttributeNotFoundError unless @params[key]
  end

  private

    def parse_www_encoded_form(www_encoded_form)
      return {} if www_encoded_form.blank?

      all_params = {}
      URI::decode_www_form(www_encoded_form).each do |(key, val)|
        parsed_keys = parse_key(key)

        current = all_params
        parsed_keys.each_with_index do |key, i|
          if i == parsed_keys.length - 1
            current[key] = val
          else
            current[key] ||= {}
            current = current[key]
          end
        end
      end

      all_params
    end

    def parse_key(key)
      keys = key.split(/\]\[|\[|\]/)
    end
end
