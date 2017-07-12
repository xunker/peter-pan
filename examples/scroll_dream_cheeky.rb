#!/usr/bin/env ruby
#
# Example of infinitely scrolling text using peter_pan with the Dream Cheeky LED
# display via dream-cheeky-led gem (https://github.com/Aupajo/dream-cheeky-led).
require 'peter_pan'
require 'dream-cheeky/led'

p = PeterPan.new(viewport_width: 21, viewport_height: 7)

# message = "One Two Three Four Five"
message = "One Two "

p.write(0, 0, message)

puts p.pretty_print_buffer

message_board = DreamCheeky::LEDMessageBoard.first

loop do
  print "\e[2J\e[f" # clear screen
  message_board.draw(p.show_viewport(0,0))
  puts p.pretty_print_buffer # print whole buffer
  puts p.show_viewport(0,0) # print current viewport frame
  sleep(0.1)
  p.shift_left
end
