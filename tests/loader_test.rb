require_relative "../lib/loader"

Subject = EVAMotionControl::Loader
actions = Subject.open("test")

puts actions.first[:raw]
