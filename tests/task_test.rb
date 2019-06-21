require_relative "../lib/task"

Subject = EVAMotionControl::Task
subject = Subject.new("test")

EventMachine.run do
  puts subject.start
end
