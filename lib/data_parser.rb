module EVAMotionControl
  class DataParser
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

    INPUT_INDICES = {
      Y_REST_STATE: 0, # Y搜参状态	M0.0
      X_ACTIVATION: 1, # X轴激活	M0.1
      X_READY:      2, # X完成状态	M0.2
      X_DIRECTION:  3, # X当前方向	M0.3
      X_TRIGGER:    4,  #4 X定位激活	   M0.4
      X_COMPLETED:  6,  #6 X定位状态参量	M0.6
      Y_TRIGGER:    14, #14 Y定位激活	   M1.4
      Y_COMPLETED:  16, #16 Y定位状态参量  M1.6
      LIGHT:        20, #20 背光控制系统  M2.0
      # 以下为双精度数
      X_POSITION:   300, #309 X移动位置	   VD9
      X_SPEED:      302, #313 X移动速度	   VD13
      Y_POSITION:   304, #333 Y移动位置	   VD33
      Y_SPEED:      306  #337 Y移动速度	   VD37
    }

    OUTPUT_INDICES = {
      Y_REST_STATE:  0, # Y搜参状态	M0.0
      X_ACTIVATION:  1, # X轴激活	M0.1
      X_READY:       2, # X完成状态	M0.2
      X_DIRECTION:   3, # X当前方向	M0.3
      X_TRIGGER:     4,  #4 X定位激活	   M0.4
      X_COMPLETED:   6,  #6 X定位状态参量	M0.6
      Y_TRIGGER:     14, #14 Y定位激活	   M1.4
      Y_COMPLETED:   16, #16 Y定位状态参量  M1.6
      LIGHT:         20, #20 背光控制系统  M2.0
      # 以下为双精度数
      X_POSITION:    200, #309 X移动位置	   VD9
      X_SPEED:       202, #313 X移动速度	   VD13
      Y_POSITION:    204, #333 Y移动位置	   VD33
      Y_SPEED:       206 #337 Y移动速度	   VD37
    }

    DOUBLE_VARIABLES = [
      :X_POSITION,
      :X_SPEED,
      :Y_POSITION,
      :Y_SPEED
    ]


    MAPPING = []
    INPUT_INDICES.each do |index_name, index|
      MAPPING.push([index, OUTPUT_INDICES[index_name.to_sym]])
      if DOUBLE_VARIABLES.include?(index_name.to_sym)
        MAPPING.push([index + 1, OUTPUT_INDICES[index_name.to_sym] + 1])
      end
    end

    def initialize data
      @data = data
      parse data
    end

    def run
      update_db
    end

    private

    def parse data
      data.unpack("C*").each_with_index do |value, index|
        puts value
        EVAMotionControl::INPUT_DB[index] = value
      end
    end

    def update_db
      # puts MAPPING
      MAPPING.each do |pair|
        EVAMotionControl::DB[pair.last] = EVAMotionControl::INPUT_DB[pair.first] || 0
      end
      puts "DB updated"
    end
  end
end
