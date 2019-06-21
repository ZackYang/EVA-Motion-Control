require_relative "../lib/base"
require_relative "../lib/controller"

controller = EVAMotionControl::Controller.new(nil, {
  method:       "POST",
  uri:          "/start/test",
})

raise unless controller.send(:fetch_action) == "start"
raise unless controller.send(:fetch_params) == ["test"]


controller = EVAMotionControl::Controller.new(nil, {
  method:       "GET",
  uri:          "/states",
})

raise unless controller.send(:fetch_action) == "states"
raise unless controller.send(:fetch_params) == []

response = EM::DelegatedHttpResponse.new(self)
controller = EVAMotionControl::Controller.new(response, {
  method:       "GET",
  uri:          "/states",
})

controller.process
puts controller.response.content
