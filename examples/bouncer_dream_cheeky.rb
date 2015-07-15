#!/usr/bin/env ruby
#
# Makes a virtual "ball" bounce around the screen. Uses the peter_pan gem and
# dream-cheeky-led gem (https://github.com/Aupajo/dream-cheeky-led).
require 'peter_pan'
require 'dream-cheeky/led'

message_board = DreamCheeky::LEDMessageBoard.first

height = 7
width = 21

p = PeterPan.new(
  viewport_width: width,
  viewport_height: height,
  buffer_width: width,
  buffer_height: height
)

position_x = rand(6)
position_y = rand(20)

direction_x = 1
direction_y = 1

buffer = []
height.times do
  buffer << []
  width.times do
    buffer.last << 0
  end
end
loop do
  buffer.each_with_index do |bx, i|
    buffer[i] = bx.map{|v| v -= 1 if v > 0; v}
  end

  direction_x = -1 if position_x >= (height-1)
  direction_y = -1 if position_y >= (width-1)
  direction_x = 1 if position_x <= 0
  direction_y = 1 if position_y <= 0

  position_x += direction_x
  position_y += direction_y
  
  buffer[position_x][position_y] = 8

  buffer.each_with_index do |bx, i|
    # puts bx.map{|v|(v == 0 ? ' ' : v)}.join
    bx.each_with_index do |by, ii|
      p.plot(ii,i, (by > 0 ? by : ' '))
    end
  end
  puts p.show_buffer

  message_board.draw(p.show_buffer)

  # message_board.draw_pixels(buffer)
  # message_board.draw_pixels(buffer.map{|b|b.map{|v|(v>0?1:0)}})
  sleep 0.04
  print "\e[2J\e[f" # clear screen
end
