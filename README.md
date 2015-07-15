### Peter Pan - a Ruby gem providing a virtual screen buffer with viewport panning. For the Dream Cheeky LED sign and others, also works just fine with computer screen.

Peter Pan gives you a large, virtual text frame buffer and a virtual
viewport you can move around over it. You can plot points or draw text in the
buffer and scroll the viewport over it to simulate scrolling text or scrolling
graphics.

![Animated image of words panning over an LED display](https://github.com/xunker/peter_pan/raw/master/panning_text_example.gif)

It was written to make it easier to get text on the Dream Cheeky LED sign, but
it'll work for any thing that that accepts a formatted text string as input. It
will also work just fine on your computer screen.

The dream-cheeky-led gem (https://github.com/Aupajo/dream-cheeky-led) is not
a runtime dependency, but it can be used in conjunction with this gem to get
scrolling text and graphics on your Dream Cheeky LED sign. It is a
development dependency in order to make `examples/dream_cheeky.rb` work.

This gem uses the "transpo" font from Lewis Clayton's dcled_ruby project
(https://github.com/Lewis-Clayton/dcled_ruby).

## Installation

Install normally:

    $ gem install peter_pan

And then require it normally:

```ruby
  require 'peter_pan'
```

To write to a Dream Cheeky LED sign using `examples/dream_cheeky.rb`, also
install the dream-cheeky-led gem:

    $ gem install dream-cheeky-led --pre

## Examples

There are basic examples in the `examples/` directory that illustrate basic
concepts of drawing text to the buffer and panning the viewport over the it.

    * bouncer_dream_cheeky.rb - A pixel that bounces around the Dream Cheeky LED sign.
    * pan_dream_cheeky.rb - Pans the Dream Cheeky LED sign over a larger virtual buffer.
    * pan_to_screen.rb - Same as _pan_dream_cheeky.rb_, but outputs to screen -- no Dream Cheeky LED sign required!

## Usage

### Dots

Print dots to the buffer, render the viewport in two places illustrating how
it only shows the area of the newport:

```ruby
> require 'peter_pan'
> p = PeterPan.new
> p.plot(1,1)
> p.plot(3,3)
> p.plot(8,8)
> p.plot(21,2)
> p.plot(25,4)
> puts p.pretty_print_buffer
+--------------------------+
|                          |
| *                        |
|                     *    |
|   *                      |
|                         *|
|                          |
|                          |
|                          |
|                          |
+--------------------------+
> puts p.pretty_print_viewport(0,0)
+---------------------+
|                     |
| *                   |
|                     |
|   *                 |
|                     |
|                     |
|                     |
+---------------------+
> puts p.pretty_print_viewport(5,0)
+---------------------+
|                     |
|                     |
|                *    |
|                     |
|                    *|
|                     |
|                     |
+---------------------+
```

### Text

Print text to the buffer and render the viewport over a portion.

```ruby
> require 'peter_pan'
> p = PeterPan.new
> p.write(0, 0, "Hello.")
> puts p.pretty_print_buffer
+-----------------------------------+
|*   *        **    **              |
|*   *         *     *              |
|*   *  ***    *     *    ***       |
|***** *   *   *     *   *   *      |
|*   * *****   *     *   *   *      |
|*   * *       *     *   *   *  **  |
|*   *  ***   ***   ***   ***   **  |
+-----------------------------------+
> puts p.pretty_print_viewport(5,0)
+---------------------+
|        **    **     |
|         *     *     |
|  ***    *     *    *|
| *   *   *     *   * |
| *****   *     *   * |
| *       *     *   * |
|  ***   ***   ***   *|
+---------------------+
```

### Change viewport size

The viewport dimensions default to 21x7, the size of the Dream Cheeky LED,
but can be changed by passing arguments to the initializer.

```ruby
> p = PeterPan.new( viewport_width: 5, viewport_height: 5 )
> p.write(0, 0, "Hello.")
> puts p.pretty_print_viewport(5,0)
+-----+
|     |
|     |
|  ***|
| *   |
| ****|
+-----+
```

### Printing without ascii borders

To print the buffer and viewport without the ascii-art borders, replace
`pretty_print_viewport`  with 'show_viewport` using the same arguments:

```ruby
> p = PeterPan.new( viewport_width: 5, viewport_height: 5 )
> p.write(0, 0, "Hello.")
> puts p.show_viewport(5,0)


  ***
 *
 ****
```

All other `pretty_*` methods have `show_*` counterparts that will return data
without the enclosing border.

### Animated panning the viewport

Check out `examples/pan_dream_cheeky.rb` and `examples/pan_to_screen.rb` to see
how to animate the movement of the viewport over the buffer.

[This animated image](https://github.com/xunker/peter_pan/raw/master/panning_text_example.gif) shows how `examples/pan_dream_cheeky.rb` looks when running on an actual Dream Cheeky LED sign.

## Documentation

Detailed docs available [at rubydoc.org](http://rubydoc.org/github/xunker/peter_pan/master/frames)


## Source

Source lives on Github: [xunker/peter_pan](https://github.com/xunker/peter_pan).

## Contributing

You'll notice there are no tests in this repo, and that's my fault. That means
that if you'd like to make some changes or fix some bug, you don't need to
write tests if you don't want to! Yay!

Here's the process if you'd like to contribute:

  * Fork the repo.
  * Make your changes. If you can, please make your changes in a topic branch, not master.
  * Test your changes as well as you can. I'll believe you if you say you did.
  * Make a pull request.
