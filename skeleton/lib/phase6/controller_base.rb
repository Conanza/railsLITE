require_relative '../phase5/controller_base'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      router = Router.new
      http_method = @req.request_method
      controller_class = self.class
      pattern = Regexp.new(@req.path)
      router.send(http_method, pattern, controller_class, name)

      render name unless already_built_response?
    end
  end
end
