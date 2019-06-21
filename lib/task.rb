require_relative "./loader"
require_relative "./action"

module EVAMotionControl
  class Task
    attr_reader :task_name, :actions

    def initialize pattern_name
      @task_name, @actions = EVAMotionControl::Loader.open(pattern_name)
      @current_step_index = 0
      @stop = false
      fetch_steps
      @current_step = @steps.first
    end

    def start
      EVAMotionControl.set_state :working, true
      EVAMotionControl.set_state :ready,   false
      EVAMotionControl.set_state :error,   ""
      run_current_step
    end

    def run_current_step
      return unless @current_step
      puts "Start: Step #{@current_step_index + 1}"
      @current_step[:running]   = true
      @current_step[:completed] = false
      update_attributes
    end

    def update_attributes
      puts "Updating Attributes: #{@current_step[:attributes]}"
      update @current_step[:attributes]
      EventMachine::Timer.new(0.1) do
        update_triggers
      end
    end

    def update_triggers
      puts "Updating Triggers: #{@current_step[:triggers]}"
      update @current_step[:triggers]
      EventMachine::Timer.new(0.1) do
        check_complete_conditions
      end
    end

    def check_complete_conditions
      puts "Checking complete conditions"
      begin_at = Time.now
      timer = EventMachine::PeriodicTimer.new(0.5) do
        print(".")
        result = true
        @current_step[:complete_conditions].each do |index, value|
          result = (value == EVAMotionControl::DB[index]) && result
        end if @current_step[:complete_conditions]

        if result
          current_step_complete
          timer.cancel
        end

        if ((Time.now - begin_at) > 10)
          current_step_fail
          timer.cancel
        end
      end
    end

    def current_step_complete
      puts "Step #{@current_step_index + 1} completed"
      @current_step[:running]   = false
      @current_step[:completed] = true
      @current_step_index += 1
      @current_step = @steps[@current_step_index]
      run_current_step
    end

    def current_step_fail
      puts "Current step failed"
      EVAMotionControl.set_state :working, false
      EVAMotionControl.set_state :ready,   true
      EVAMotionControl.set_state :error,   "Prev Task failed"
    end

    def update attributes
      return unless attributes
      attributes.each do |index, value|
        EVAMotionControl::DB[index] = value.to_i
        if value.is_a?(Float)
          decimal_part = value.round(2).to_s.split(".").last.to_i
          EVAMotionControl::DB[index + 1] = decimal_part
        end
      end
      write
    end

    def write
      tmp_DB = EVAMotionControl::DB.clone
      tmp_DB = tmp_DB.map do |val|
        puts val
        val.to_s(16)
      end.pack("h"*tmp_DB.size)
      EVAMotionControl.connection.send_data tmp_DB
    end

    private

    def fetch_steps
      @steps = []
      @current_step_index = 0
      @actions.each do |action|
        next if action[:method].size.zero?
        arguments = action[:arguments]
        subactions = EVAMotionControl::Action.send(action[:method], *arguments)
        subactions.each do |step|
          @steps << step
        end
      end
      @steps
    end

    def make_dir

    end

  end
end
