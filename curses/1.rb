#!/usr/bin/env ruby
require "../state.rb"
require "curses"

# def show_message(message)
#   height = 5
#   width  = message.length + 6
#   top    = (Curses.lines - height) / 2
#   left   = (Curses.cols - width) / 2
#   win = Curses::Window.new(height, width, top, left)
#   win.box("|", "-")
#   win.setpos(2, 3)
#   win.addstr(message)
#   win.refresh
#   win.getch
#   win.close
# end

$state = generate_state()

Curses.init_screen
Curses.noecho
Curses.curs_set 0
Curses.stdscr.keypad = true
begin
  while true
    # k = Curses.getch
    k = Curses.get_char
    # raise k.inspect
    # p k
    # case k
    # when Curses::KEY_RIGHT
    #   p 'right'
    # end

    case k
    when Curses::KEY_LEFT
      # @label.setText 'left'
      state_snake_left($state)
    when Curses::KEY_RIGHT
      # @label.setText 'left'
      state_snake_right($state)
    when Curses::KEY_UP
      # @label.setText 'up'
      state_snake_up($state)
    when Curses::KEY_DOWN
      # @label.setText 'down'
      state_snake_down($state)
    end
    
    if state_is_eating($state)
      $state[:food] = generate_random_food_position($state)
    end

    # print state_to_matrix($state).to_yaml
    # win.addch(snake_position[0][0], snake_position[0][1], '#')
    str = state_to_boad_string($state)
    Curses.setpos(0, 0)
    Curses.addstr(str)
  end
  
  # Curses.crmode
  # Curses.setpos((Curses.lines - 1) / 2, (Curses.cols - 11) / 2)
  # Curses.addstr("Hit any key")
  # Curses.refresh
  # Curses.getch
  # show_message("Hello, World!")
ensure
  Curses.close_screen
end