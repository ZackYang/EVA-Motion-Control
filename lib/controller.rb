require 'json'

module EVAMotionControl
  class Controller

    def initialize response, request={}
      @response = response
      @request  = request
    end

    def call action_name

    end

    private

    def render
    end

    def start
      if can_start?
        pattern_name = @http_request_uri.match(/[a-z\_]+/).to_s
        task = EVAMotionControl::Task.new(pattern_name)
        task.start
      end
      states
    end

    def can_start?
      false
    end

    def stop
    end

    def states
      EVAMotionControl.states.to_json
    end

  end
end
