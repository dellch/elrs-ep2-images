#!/usr/bin/env ruby

puts "Generating markdown for image table"

files = Dir["../images/*.jpg"]

class Ep2
  attr_accessor :filename, :manufacturer, :side
  def initialize(filepath)
    @filename = filepath.split("/")[-1]
    split = @filename.split("_")
    @manufacturer = split[1]
    @side = @filename.include?("front") ? "front": "back"
  end

  def front?
    @side == "front"
  end

  def back?
    !front?
  end
end

def markdown_image filepath
  "![#{filepath}](#{filepath})"
end

puts "Found files\n\t#{ files.join("\n\t") }"
markdown = []

back = "_back"
front = "_front"
start = "../images/ep2_"

data = {}

files.each{ |filepath| 
  ep2 = Ep2.new(filepath)
  location = "./images/#{ep2.filename}"
  if !data.has_key?(ep2.manufacturer)
    data[ep2.manufacturer] = {}
  end

  data[ep2.manufacturer][ep2.front? ? "front" : "back" ] = location

  markdown = data.keys.inject([]){ |result, mfg|
    rx = data[mfg]
    result.push("| #{ mfg } | #{ markdown_image(rx["front"]) } | #{ markdown_image(rx["back"]) } |")
  }
}

puts "Results:\n\n------------------------------------------------\n#{markdown.join("\n")}\n--------------------------------------------------"
