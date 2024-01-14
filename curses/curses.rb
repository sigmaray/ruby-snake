#!/usr/bin/env ruby

# frozen_string_literal: true

require "curses"

require_relative "../state"

USE_TIMER = %w[0 false off].include?(ENV["TIMER"]) ? false : true # rubocop:disable Style/IfWithBooleanLiteralBranches
BOARD_SIZE = ENV["SIZE"].to_i > 1 ? ENV["SIZE"].to_i : 5
TIMEOUT = 500

state = SnakeState.generate_state(BOARD_SIZE)

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

Curses.timeout = TIMEOUT if USE_TIMER

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
