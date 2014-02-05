#!/usr/bin/env ruby
require 'peter_pan'

p = PeterPan.new

lines = [
  "One",
  "Two",
  "Three"
]

lines.each_with_index do |line, i|
  p.write(0, (i*p.font["height"])+(1*i), line)
end

loop do
  coords = [
    [0,0],
    [0, p.buffer_height-p.font["height"]],
    [p.buffer_width-p.viewport_width, p.buffer_height-p.font["height"]],
    [p.buffer_width-p.viewport_width, 0],
    [0,0]
  ]

  p.pretty_pan_viewport(coords).each do |vp|
    print "\e[2J\e[f" # clear screen
    puts p.pretty_print_buffer # print whole buffer
    puts vp # print current viewport frame
    sleep(0.1)
  end

end
