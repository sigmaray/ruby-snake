#!/usr/bin/env ruby

# frozen_string_literal: true

require "curses"

require_relative "../lib/options"
require_relative "../lib/state"

options = parse_env

state = SnakeState.generate_state(options[:size])

Curses.init_screen

# Disable automatic output
# Curses.noecho

# Hide cursor
Curses.curs_set 0

# Make it possible to handle arrow keys
Curses.stdscr.keypad = true

def print_to_terminal(str)
  Curses.clear
  Curses.setpos(0, 0)
  Curses.addstr(str)
end

print_to_terminal(SnakeState.state_to_string(state))

Curses.timeout = options[:timeout] if options[:use_timer]

begin
  loop do
    k = Curses.get_char

    can_move = true

    case k
    when Curses::KEY_LEFT
      state = SnakeState.on_key_press(state, "left")
    when Curses::KEY_RIGHT
      state = SnakeState.on_key_press(state, "right")
    when Curses::KEY_UP
      state = SnakeState.on_key_press(state, "up")
    when Curses::KEY_DOWN
      state = SnakeState.on_key_press(state, "down")
    when "r", "R", "к", "К"
      state = SnakeState.on_key_press(state, "r")
    when nil
      state = SnakeState.on_timer(state)
    end

    print_to_terminal(SnakeState.state_to_string(state))
  end
ensure
  Curses.close_screen
end
