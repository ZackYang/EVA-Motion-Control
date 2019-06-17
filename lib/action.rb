module EVAMotionControl
  module Action
    # X定位激活	M0.4
    # X急停	M0.5
    # X定位状态参量	M0.6
    # X搜参点	M0.7
    # X搜参状态	M1.0
    # Y轴激活	M1.1
    # Y完成状态	M1.2
    # Y当前方向	M1.3
    # Y定位激活	M1.4
    # Y急停	M1.5
    # Y定位状态参量	M1.6
    # Y搜参点	M1.7
    # 背光控制系统	M2.0
    # X轴错误代码	VB401
    # X定位错误	VB405
    # X搜参错误	VB409
    # Y轴错误代码	VB413
    # Y定位错误	VB417
    # Y搜参错误	VB421
    # X当前位置	VD1
    # X当前速度	VD5
    # X移动位置	VD9
    # X移动速度	VD13
    # VD17
    # VD21
    # Y当前位置	VD25
    # Y当前速度	VD29
    # Y移动位置	VD33
    # Y移动速度	VD37
    # VD41
    # VD45
    Y_REST_STATE = 0  # Y搜参状态	M0.0
    X_ACTIVATION = 1 # X轴激活	M0.1
    X_READY      = 2 # X完成状态	M0.2
    X_DIRECTION  = 3 # X当前方向	M0.3
    X_TRIGGER    = 4  #4 X定位激活	   M0.4
    X_COMPLETED  = 6  #6 X定位状态参量	M0.6
    Y_TRIGGER    = 14 #14 Y定位激活	   M1.4
    Y_COMPLETED  = 16 #16 Y定位状态参量  M1.6
    LIGHT        = 20 #20 背光控制系统  M2.0
    # 以下为双精度数
    X_POSITION   = 59 #309 X移动位置	   VD9
    X_SPEED      = 63 #313 X移动速度	   VD13
    Y_POSITION   = 83 #333 Y移动位置	   VD33
    Y_SPEED      = 87 #337 Y移动速度	   VD37

    def self.init
        # Goto original point
        goto(0, 0) + turn_light_on() + []
    end

    def self.goto x, y, speed = 20
      [
        {
          attributes: {
            # { index：X_POSITION, value: x.to_f }
            X_POSITION => x.to_i,
            X_SPEED    => speed.to_i,
            Y_POSITION => y.to_i,
            Y_SPEED    => speed.to_i
          },
          triggers: {
            X_TRIGGER => 1,
            Y_TRIGGER => 1
          },
          delay: 5000,
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
