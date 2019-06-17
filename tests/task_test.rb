require_relative "../lib/task"

Subject = EVAMotionControl::Task
subject = Subject.new("test")

puts subject.start
