#!/usr/bin/env ruby
require 'yaml'

class PeterPan
  attr_reader :viewport_width, :viewport_height

  def initialize(opts={})
    @viewport_width = (opts[:viewport_width] || 21).to_i # x
    @viewport_height = (opts[:viewport_height] || 7).to_i # y

    @buffer = []
  end

  def plot(x,y, value='X')
    1.upto(y+1) do |i|
      @buffer[i-1] ||= []
      1.upto(x+1) do |ii|
        @buffer[i-1][ii-1] ||= ' '
      end
    end

    @buffer[y][x] = value.to_s.slice(0,1)
  end

  def show_buffer
    str = "+#{'-' * @buffer.first.size}+\n"
    @buffer.each do |bx|
      str << '|'
      str << bx.join
      str << "|\n"
    end
    str << "+#{'-' * @buffer.first.size}+\n"
    str
  end

  def show_viewport(x,y,x2=@viewport_width,y2=@viewport_height)
    str = "+#{'-' * (x2)}+\n"
    y.upto((y2-1)+y) do |i|
      buffer_row = @buffer[i] || @viewport_width.times.map{' '}
      str << '|'
      str << sprintf("%-#{x2}s", buffer_row[x..((x2-1)+x)].join)
      str << "|\n"
    end
    str << "+#{'-' * (x2)}+\n"
    str
  end

  def plot_sprite(sprite, x, y)
    sprite.each_with_index do |line, line_y|
      line.split('').each_with_index do |c, char_x|
        plot(char_x + x, line_y + y, c)
      end
    end
  end

  def write(font, x, y, message)
    letter_x = x
    message.split('').each do |c|
      char = font['characters'][c].map{|l|l.gsub('.', ' ')}
      plot_sprite(char, letter_x, y)
      letter_x = letter_x + font['width'] + 1
    end
  end

  def buffer_width
    @buffer.first.size+1
  end

  def buffer_height
    @buffer.size+1
  end

  def calculate_integral_points(x1, y1, x2, y2)
    # pt1 = [x1, y1]
    # pt2 = [x2, y2]
    # m = (pt1[1] - pt2[1]) / (pt1[0] - pt2[0])
    # b = pt1[1] - m * pt1[0]

    # i = pt1[0]
    # points = []
    # while i <= pt2[0] do
    #   points << [i, m * i + b]
    #   i += 1
    # end
    # points

    x_integrals = []
    if x1 < x2
      x1.upto(x2) do |i|
        x_integrals << i
      end
    else
      x1.downto(x2) do |i|
        x_integrals << i
      end
    end

    y_integrals = []
    if y1 < y2
      y1.upto(y2) do |i|
        y_integrals << i
      end
    else
      y1.downto(y2) do |i|
        y_integrals << i
      end
    end

    while x_integrals.length < y_integrals.length
      x_integrals.unshift(x_integrals.first)
    end

    while y_integrals.length < x_integrals.length
      y_integrals.unshift(y_integrals.first)
    end

    x_integrals.zip(y_integrals)
    # [ x_integrals, y_integrals ]
  end
end

p = PeterPan.new
# [0,7,14,21,28,35,42].each do |i|
# 0.step(100, 7) do |i|
#   25.times do |ii|
#     p.plot(i+ii,ii, i)
#   end
# end
# p.plot(0,6, 'A')
# p.plot(2,6, 'B')
# p.plot(4,6, 'C')
# p.plot(35,6, 'D')
# p.plot(5,6, 'F')
# p.plot(7,6, 'G')
# p.plot(9,6, 'H')
# p.plot(30,4, 'I')

# puts p.show_buffer

# # 42.times do |i|
# #   puts p.show_viewport(i,0)
# #   sleep(0.1)
# # end
# # 15.times do |i|
# #   puts p.show_viewport(0,i)
# #   sleep(0.1)
# # end

# pt1 = [0, 0]
# pt2 = [10, 10]
# m = (pt1[1] - pt2[1]) / (pt1[0] - pt2[0])
# b = pt1[1] - m * pt1[0]

# i = pt1[0]
# points = []
# while i <= pt2[0] do
#   points << [i, m * i + b]
#   i += 1
# end

# # puts points.inspect
# points.each do |px, py|
#   puts p.show_viewport(px, py)
#   sleep(0.1)
# end

###

# font = YAML.load(File.new('./fonts/transpo.yml').read)
# p.write(font, 0, 0, 'Hello, world!')
# puts p.show_buffer

# pt1 = [0, 0]
# pt2 = [p.buffer_width-1, 0]
# m = (pt1[1] - pt2[1]) / (pt1[0] - pt2[0])
# b = pt1[1] - m * pt1[0]

# i = pt1[0]
# points = []
# while i <= pt2[0] do
#   points << [i, m * i + b]
#   i += 1
# end

# # puts points.inspect
# points.each do |px, py|
#   puts p.show_viewport(px, py)
#   sleep(0.05)
# end

###

font = YAML.load(File.new('./fonts/transpo.yml').read)
p.write(font, 0, 0, 'Hello,')
p.write(font, 0, font["height"]+1, 'world!')
puts p.show_buffer

loop do
  p.calculate_integral_points(0,0,p.buffer_width-p.viewport_width,0).each do |px, py|
    puts p.show_viewport(px, py)
    sleep(0.05)
  end

  p.calculate_integral_points(p.buffer_width-p.viewport_width,0,0,font["height"]+1).each do |px, py|
    puts p.show_viewport(px, py)
    sleep(0.05)
  end

  p.calculate_integral_points(0, font["height"]+1,p.buffer_width-p.viewport_width, font["height"]+1).each do |px, py|
    puts p.show_viewport(px, py)
    sleep(0.05)
  end

  p.calculate_integral_points(p.buffer_width-p.viewport_width, font["height"]+1, 0, 0).each do |px, py|
    puts p.show_viewport(px, py)
    sleep(0.05)
  end
end