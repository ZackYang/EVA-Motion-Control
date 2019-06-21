require_relative "../lib/base"
require_relative "../lib/data_parser"

input_test_data = Array.new(400, 0)

input_test_data[300] = 10
input_test_data[301] = 4

puts input_test_data.map { |val| val.to_s(16) }.join(",")

input_test_data = input_test_data.map { |val| val.to_s(16) }.pack("h"*input_test_data.size)

parser = EVAMotionControl::DataParser.new(input_test_data)
parser.run
puts EVAMotionControl::DB.join(",")
puts EVAMotionControl::DB.size
raise unless EVAMotionControl::DB[200] == 10
raise unless EVAMotionControl::DB[201] == 4
