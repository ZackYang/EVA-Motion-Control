require 'em/pure_ruby'
require 'em-http-server'
require_relative "./task"
require_relative "./data_parser"
require_relative "./controller"

module EVAMotionControl
  class FakeConnection
    def send_data data
      puts data
    end
  end

  DB = Array.new(400, 0)
  INPUT_DB = []

  def self.root
    __dir__ + "/../"
  end

  def self.set_connection connection
    @connection = connection
  end

  def self.connection
    return @connection if @connection
    FakeConnection.new
  end

  def self.set_state key, value
    @states ||= {
      "working" => false,
      "error"   => "",
      "ready"   => true
    }

    @states[key.to_s] = value
  end

  def self.states
    @states ||= {
      "working" => false,
      "error"   => "",
      "ready"   => true
    }
    @states.to_hash
  end

  def self.state key
    @states[key.to_s]
  end

  class Base < EventMachine::Connection
    attr_accessor :status

    def post_init
      EVAMotionControl.set_state :connected, true
      send_data "connected"
    end

    def receive_data data
      parser = EVAMotionControl::DataParser.new(data)
      parser.run
    end

    def unbind
      EVAMotionControl.set_state :connected, false
      puts "A connection has terminated"
    end

    class HTTPHandler < EM::HttpServer::Server
      def process_http_request
        # puts  @http_request_method
        # puts  @http_request_uri
        # puts  @http_query_string
        # puts  @http_protocol
        # puts  @http_content
        # puts  @http[:cookie]
        # puts  @http[:content_type]
        # # you have all the http headers in this hash
        # puts  @http.inspect

        response = EM::DelegatedHttpResponse.new(self)

        controller = EVAMotionControl::Controller.new(response, {
          method:       @http_request_method,
          uri:          @http_request_uri,
          query_string: @http_query_string,
          content:      @http_content,
          content_type: @http[:content_type]
        })
        controller.process
        controller.response.send_response
      end

      def http_request_errback e
        # printing the whole exception
        puts e.inspect
      end
    end
  end

  def self.run
    EventMachine.run do
      EVAMotionControl.set_connection EventMachine::connect("127.0.0.1", 5000, EVAMotionControl::Base)
      EM::start_server("0.0.0.0", 3000, EVAMotionControl::Base::HTTPHandler)
    end
  end

end
