## Peter Pan - a Ruby gem providing a virtual screen buffer with viewport panning. For the Dream Cheeky LED sign and others.

Peter Pan gives you a large, virtual text frame buffer and a virtual
viewport you can move around over it. You can plot points or draw text in the
buffer and scroll the viewport over it to simulate scrolling text or scrolling
graphics.

It was written to make it easier to get text on the Dream Cheeky LED sign, but
it'll work for any thing that that accepts a formatted text string as input.

The dream-cheeky-led gem (https://github.com/Aupajo/dream-cheeky-led) is not a
dependency, but it can be used in conjunction with this gem to get scrolling
text and graphics on your Dream Cheeky LED sign.

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

There are basic examples in the `examples/` directory:

  dream_cheeky.rb: write to a USB Dream Cheeky Sign
  to_screen.rb:    write to the screen

These examples show the basic concepts of drawing text to the buffer and
panning the viewport over the buffer.

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

## Documentation

TODO: add link to RDOC here.
