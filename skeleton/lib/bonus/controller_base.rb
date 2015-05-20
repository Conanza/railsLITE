require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative 'flash'
require_relative 'session'
require_relative 'params'
require_relative 'router'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = Params.new(req, route_params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "already_built_response" if already_built_response?

    @res["Location"] = url
    @res.status = 302
    @already_built_response = true

    session.store_session(@res)
  end

  def render_content(content, content_type)
    raise "already built response" if already_built_response?
    @res.body = content
    @res.content_type = content_type
    @already_built_response = true

    session.store_session(@res)
  end

  def render(template_name)
    controller_name = self.class.name.underscore
    template = File.read("views\/#{controller_name}\/#{template_name}.html.erb")
    erb_template = ERB.new(template)

    render_content(erb_template.result(binding), "text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  def invoke_action(name)
    send(name)
    render name unless already_built_response?
  end
end
