require 'json'

module EVAMotionControl
  class Controller

    attr_reader :request, :response

    def initialize response, request={}
      @response = response
      @request  = request
    end

    def process
      @response.status = 200
      result = self.send(fetch_action)
      @response.content      = result
      @response.content_type "application/json"
    end

    private

    def start
      pattern_name = fetch_params.first
      if can_start?
        task = EVAMotionControl::Task.new(pattern_name)
        task.start
      end
      states
    end

    def can_start?
      EVAMotionControl.states["ready"] && !EVAMotionControl.states["working"]
    end

    def stop
    end

    def states
      EVAMotionControl.states.to_json
    end

    def split_uri
      @params ||= request[:uri].scan(/[a-z_]+/)
    end

    def fetch_action
      split_uri.first
    end

    def fetch_params
      split_uri[1..-1]
    end

    def state code
      @response.status = code
    end

  end
end
