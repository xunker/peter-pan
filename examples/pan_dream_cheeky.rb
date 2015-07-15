#!/usr/bin/env ruby
#
# Example of using peter_pan with the Dream Cheeky LED display via the
# dream-cheeky-led gem (https://github.com/Aupajo/dream-cheeky-led).
require 'peter_pan'
require 'dream-cheeky/led'

p = PeterPan.new

lines = [
  "One",
  "Two",
  "Three",
  "Four",
  "Five"
]

lines.each_with_index do |line, i|
  p.write(0, (i*p.font["height"])+(1*i), line)
end

puts p.pretty_print_buffer

message_board = DreamCheeky::LEDMessageBoard.first

loop do
  coords = [
    [0,0],
    [0, p.buffer_height-p.font["height"]],
    [p.buffer_width-p.viewport_width, p.buffer_height-p.font["height"]],
    [p.buffer_width-p.viewport_width, 0],
    [0,0]
  ]

  p.path_viewport(coords).each do |vp|
    message_board.draw(vp)
    sleep(0.05)
  end
end
