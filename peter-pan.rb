#!/usr/bin/env ruby
require 'yaml'

class PeterPan
  attr_reader :viewport_width, :viewport_height

  def initialize(opts={})
    @viewport_width = (opts[:viewport_width] || 21).to_i # x
    @viewport_height = (opts[:viewport_height] || 7).to_i # y
    @buffer_changed = false
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

    @buffer_changed = true
  end

  def show_buffer
    normalize_buffer_size

    str = "+#{'-' * @buffer.first.size}+\n"
    @buffer.each do |bx|
      str << '|'
      str << bx.join
      str << "|\n"
    end
    str << "+#{'-' * @buffer.first.size}+\n"
    str
  end

  def buffer_width
    if !@buffer_width || @buffer_changed
      @buffer_width = 0
      @buffer.each do |by|
        @buffer_width = by.size if by.size > @buffer_width
      end
    end
    @buffer_width
  end

  def normalize_buffer_size
    return unless @buffer_changed

    @buffer.each do |by|
      if by.size < buffer_width
        (by.size-1).upto(buffer_width-1) do |i|
          by[i] = ' '
        end
      end 
    end
  end

  def show_viewport(x,y,x2=@viewport_width,y2=@viewport_height)
    normalize_buffer_size

    str = ""
    y.upto((y2-1)+y) do |i|
      buffer_row = @buffer[i] || @viewport_width.times.map{' '}
      str << sprintf("%-#{x2}s", buffer_row[x..((x2-1)+x)].join)
      str << "\n"
    end
    
    str
  end

  def pretty_print_viewport(x,y,x2=@viewport_width,y2=@viewport_height)
    str = "+#{'-' * (x2)}+\n"
    vp = show_viewport(x,y,x2,y2)
    str << vp.gsub(/^/, '|').gsub(/$/, '|').gsub(/^\|$/, '')
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

  def buffer_height
    @buffer.size
  end

  def calculate_integral_points(x1, y1, x2, y2)
    x_integrals = calculate_integrals(x1, x2)
    y_integrals = calculate_integrals(y1, y2)

    (x_integrals, y_integrals) = standardize_integral_lengths(x_integrals, y_integrals)

    x_integrals.zip(y_integrals)
  end

  def standardize_integral_lengths(one, two)
    while one.length < two.length
      one.unshift(one.first)
    end

    while two.length < one.length
      two.unshift(two.first)
    end

    [one, two]
  end

  def calculate_integrals(starting, ending)
    integrals = []
    if starting < ending
      starting.upto(ending) do |i|
        integrals << i
      end
    else
      starting.downto(ending) do |i|
        integrals << i
      end
    end
    integrals
  end
end

p = PeterPan.new

font = YAML.load(File.new('./fonts/transpo.yml').read)
# p.write(font, 0, 0, 'Hello,')
# p.write(font, 0, font["height"]+1, 'world!')
# lines = [
#   "Hello,", "world!"
# ]

lines = [
  "One",
  "Two",
  "Three",
  "Four",
  "Five"
]

lines.each_with_index do |line, i|
  puts "#{(i*font["height"])} #{line}"
  puts p.buffer_width
  p.write(font, 0, (i*font["height"]), line)
end

puts p.show_buffer

require 'dream-cheeky/led'
message_board = DreamCheeky::LEDMessageBoard.first

#test if sign connected
begin
  message_board.draw('x')
rescue NoMethodError
  puts "Sign not connected"
  message_board = nil
end

def pan_to(p, message_board, x1, y1, x2, y2)
  p.calculate_integral_points(x1, y1, x2, y2).each do |px, py|
    puts "x1: #{x1} y1: #{y1}, x2: #{x2} y2:#{y2}"
    puts p.pretty_print_viewport(px, py)
    message_board.draw(p.show_viewport(px, py)) if message_board
    sleep(0.1)
  end
end

# loop do
#   start_x=0
#   start_y=0

#   lines.each_with_index do |line, i|
#     [
#       [(line.size*font["width"])-p.viewport_width,(i*(font["height"]))],
#       [0,(i+1*(font["height"]))+(i==lines.size-1 ? 0:1)]
#     ].each do |x,y|
#       pan_to(p, message_board, start_x, start_y, x, y)
#       start_x = x
#       start_y = y
#     end
#   end
#   pan_to(p, message_board, start_x, start_y, 0, 0)
# end

# pan_to(p, message_board, 0, 0, p.buffer_width-p.viewport_width,p.buffer_height-font["height"])
