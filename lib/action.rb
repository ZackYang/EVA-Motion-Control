require_relative "./data_parser"

module EVAMotionControl
  module Action

    EVAMotionControl::DataParser::OUTPUT_INDICES.each do |key, index|
      eval("#{key} = #{index}")
    end

    def self.init
        # Goto original point
        goto(0, 0) + turn_light_on() + []
    end

    def self.goto x, y, speed = 20.0
      [
        {
          attributes: {
            # { index：X_POSITION, value: x.to_f }
            X_POSITION => x.to_f,
            X_SPEED    => speed.to_f,
            Y_POSITION => y.to_f,
            Y_SPEED    => speed.to_f
          },
          triggers: {
            X_TRIGGER => 1,
            Y_TRIGGER => 1
          },
          delay: 500,
          complete_conditions: {
            X_COMPLETED => 1,
            Y_COMPLETED => 1
          }
        }
      ]
    end

    def self.capture index
      [
        {
          actions: ["capture"],
          delay: 1000
        }
      ]
    end

    def self.wait ms = 1000
      [
        {
          delay: ms
        }
      ]
    end

    def self.end
      turn_light_off() +
      goto(0, 0) +
      []
    end

    def self.turn_light_on
      [
        {
          triggers: {
            LIGHT => 1
          },
          complete_conditions: {
            LIGHT => 1
          }
        }
      ]
    end

    def self.turn_light_off
      [
        {
          triggers: {
            LIGHT => 0
          },
          complete_conditions: {
            LIGHT => 0
          }
        }
      ]
    end

    class << self
      alias_method :gt, :goto
      alias_method :cap, :capture
    end
  end
end
