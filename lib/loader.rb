require_relative "./base"

module EVAMotionControl
  module Loader

    def self.open filename
      actions = []
      File.open("#{EVAMotionControl.root}/scripts/#{filename}.eva", "r") do |f|
        f.each_line.with_index do |line, index|
          text = line.strip
          actions.push({
            raw: line,
            method: text.match(/\A[a-z_]+/).to_s,
            arguments: text.match(/[\d\s\,]+/).to_s.gsub(/\s/, "").split(","),
            line: index + 1
          })
        end
      end
      return filename, actions
    end

  end
end
