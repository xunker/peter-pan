# Peter Pan - a Ruby gem providing a virtual screen buffer with viewport
# panning. For the Dream Cheeky LED sign and others.
#
# Home page at https://github.com/xunker/peter_pan
#
# Author::    Matthew Nielsen (mailto:xunker@pyxidis.org)
# Copyright:: Copyright (c) 2014-2017
# License::   MIT

require 'yaml'
class PeterPan
  attr_reader :viewport_width, :viewport_height, :empty_point_character

  VERSION = "1.2.0"

  # Possible Options:
  #
  # * :viewport_width - Viewport width, integer, default 21
  # * :viewport_height - Viewport height, integer, default 7
  # * :empty_point_character - the char of an empty cell (default ' ')
  # * :buffer_width - Buffer width, integer, default 0
  # * :buffer_height - Buffer height, integer, default 0
  #
  # NOTE: The buffer will automatically expand dimensionally to hold
  # any point that is #plot()'ed or text written with #write().
  def initialize(opts={})
    @viewport_width = (opts[:viewport_width] || 21).to_i # x
    @viewport_height = (opts[:viewport_height] || 7).to_i # y
    @font_name = 'transpo' # only font for now
    @empty_point_character = (opts[:empty_point_character] || ' ')
    buffer_changed!(false)
    clear_buffer!(
      :width => (opts[:buffer_width] || 0),
      :height => (opts[:buffer_height] || 0)
    )
  end

  # Draw a point in the virtual buffer.
  # The virtual buffer will be enlarged automatically.
  def plot(x, y, value='*')
    1.upto(y+1) do |i|
      @buffer[i-1] ||= []
      1.upto(x+1) do |ii|
        @buffer[i-1][ii-1] ||= @empty_point_character
      end
    end

    @buffer[y][x] = value.to_s.slice(0,1)

    buffer_changed!
  end

  # Same as #show_buffer but  with an ascii-art border around it.
  def pretty_print_buffer
    wrap_frame_with_border(show_buffer)
  end

  # Return the current buffer as a string delimited by "\n" characters
  def show_buffer
    normalize_buffer_width

    @buffer.map{|bx| "#{bx.join}\n" }.join
  end

  # Return an integer of the width of the buffer at it's widest point.
  def buffer_width
    if !@buffer_width || buffer_changed?
      @buffer_width = 0
      @buffer.each do |by|
        @buffer_width = by.size if by.size > @buffer_width
      end
    end
    @buffer_width
  end

  # Return an integer of the height of the buffer at it tallest point
  def buffer_height
    @buffer.size
  end

  # Show a viewport area of the larger buffer.
  # width and height of the viewport can be set in the object
  # initialization for defaults, or manually here.
  # Returns a string delimited by "\n" characters.
  def show_viewport(x,y,x2=@viewport_width,y2=@viewport_height)
    normalize_buffer_width

    y.upto((y2-1)+y).map do |i|
      buffer_row = @buffer[i] || @viewport_width.times.map{@empty_point_character}
      sprintf("%-#{x2}s", buffer_row[x..((x2-1)+x)].join) + "\n"
    end.join
  end

  # Same as #show_viewort, but with an ascii-art border around it.
  def pretty_print_viewport(x,y,x2=@viewport_width,y2=@viewport_height)
    wrap_frame_with_border(show_viewport(x,y,x2,y2))
  end

  # Move the viewport over the buffer from x1/y1 to x2/y2.
  # Returns an array of strings. Each string is a frame of the pan path
  # of the kind returned by #show_viewport.
  def pan_viewport(x1, y1, x2, y2)
    calculate_integral_points(x1, y1, x2, y2).map do |px, py|
      show_viewport(px, py)
    end
  end

  # Same as #pan_viewport, but with an ascii-art border around each frame.
  def pretty_pan_viewport(x1, y1, x2, y2)
    pan_viewport(x1, y1, x2, y2).map{|vp| wrap_frame_with_border(vp) }
  end

  # Like pan_viewport, but multiple pairs of coordinates can be passed.
  # The first pair will be used as the start and the viewport will be
  # panned from coordinate-pair to coordinate-pair.
  # It expects to be passed an array-like list of coordinate pairs.
  # It returns an array of string representing the frames of the pathing.
  def path_viewport(*coordinates)
    coordinates.flatten!
    start_x = coordinates.shift
    start_y = coordinates.shift
    coordinates.flatten.each_slice(2).map do |x,y|
      pan = pan_viewport(start_x, start_y, x, y)
      start_x = x
      start_y = y
      pan
    end.flatten
  end

  # Same as #path_viewport, but with an ascii-art border around each frame.
  def pretty_path_viewport(*coordinates)
    path_viewport(coordinates).map{|vp| wrap_frame_with_border(vp) }
  end

  # Draw a text sprint to the buffer at given coordinates.
  # * sprite is an ARRAY of string representing the image.
  def plot_sprite(sprite, x, y)
    sprite.each_with_index do |line, line_y|
      line.split('').each_with_index do |c, char_x|
        plot(char_x + x, line_y + y, c)
      end
    end
  end

  # Write a string to the buffer at the given coordinates.
  def write(letter_x, letter_y, message)
    message.split('').each do |c|
      char = font_character(c)
      plot_sprite(char, letter_x, letter_y)
      letter_x = letter_x + font['width'] + 1
    end
  end

  # clears everything out of the buffer.
  # By default, sets the buffer dimensions to 0x0. Optionally, you can pass
  # :width and :height args and the buffer dimentions will be set accordingly.
  # By default the buffer will be filled with space character, but you can
  # set the char to be used by passing :clear_with
  def clear_buffer!(opts={})
    opts = { :width => 0, :height => 0, :clear_with => @empty_point_character }.merge(opts)
    @buffer = [[]]
    opts[:height].times do |y|
      @buffer[y] = []
      opts[:width].times do |x|
        @buffer[y][x] = opts[:clear_with].to_s.slice(0,1)
      end
    end
    buffer_changed!
  end

  # returns a data structure representing the current font used by #write.
  def font
    @font ||= YAML.load(File.new("#{Gem.loaded_specs['peter_pan'].full_gem_path}/fonts/#{@font_name}.yml").read)
  end

  # slide buffer contents one pixel up
  def shift_up
    @buffer << @buffer.shift
  end

  # slide buffer contents one pixel down
  def shift_down
    @buffer.unshift(@buffer.pop)
  end

  # slide buffer contents one pixel left
  def shift_left
    @buffer.each do |row|
      row << row.shift
    end
  end

  # slide buffer contents one pixel right
  def shift_right
    @buffer.each do |row|
      row.unshift(row.pop)
    end
  end

private

  # return the font character for a given character. If no character exists,
  # return '?' instead.
  def font_character(char)
    (font['characters'][char] || font['characters']['?']).map{|l|l.gsub('.', @empty_point_character)}
  end

  def buffer_changed!(val = true)
    @buffer_changed = val
  end

  def buffer_changed?
    !!@buffer_changed
  end

  def normalize_buffer_width
    return unless buffer_changed?

    @buffer.each do |by|
      if by.size < buffer_width
        (by.size-1).upto(buffer_width-1) do |i|
          by[i] = @empty_point_character
        end
      end
    end

    buffer_changed!
  end


  def wrap_frame_with_border(content)
    content_width = content.index("\n")
    str = "+#{'-' * content_width}+\n"
    vp = content
    str << vp.gsub(/^/, '|').gsub(/$/, '|').gsub(/^\|$/, '')
    str << "+#{'-' * content_width}+\n"
    str
  end

  # Why yes, actually, I did fail Jr. High math. Why do you ask?
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
