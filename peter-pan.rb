#!/usr/bin/env ruby

class PeterPan
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
end

p = PeterPan.new
[0,7,14,21,28,35,42].each do |i|
  10.times do |ii|
    p.plot(i+ii,ii, i)
  end
end
# p.plot(0,6, 'A')
# p.plot(2,6, 'B')
# p.plot(4,6, 'C')
# p.plot(35,6, 'D')

puts p.show_buffer

42.times do |i|
  puts p.show_viewport(i,0)
  sleep(0.1)
end
15.times do |i|
  puts p.show_viewport(0,i)
  sleep(0.1)
end
