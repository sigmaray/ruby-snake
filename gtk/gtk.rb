require "gtk3"
require "json"

require_relative "../state"

USE_TIMER = %w[0 false off].include?(ENV["TIMER"]) ? false : true # rubocop:disable Style/IfWithBooleanLiteralBranches
BOARD_SIZE = ENV["SIZE"].to_i > 1 ? ENV["SIZE"].to_i : 5
TIMEOUT = 500

$state = SnakeState.generate_state(BOARD_SIZE)
# raise $state.inspect

window = Gtk::Window.new("First example")
window.set_size_request(400, 400)
window.set_border_width(10)

# button = Gtk::Button.new(:label => "Say hello")
# button.signal_connect "clicked" do |_widget|
#   puts "Hello World!!"
# end

# window.add(button)


$view1 = Gtk::TextView.new
window.add($view1)
def replace_text(str)
  $view1.buffer.text = str
end

window.signal_connect("key-press-event") { |_widget, event|
  # p event.inspect
  k = Gdk::Keyval.to_name(event.keyval)
  case k
  when 'Up'
    # SnakeState.state_snake_up($state)
    $state, can_move = SnakeState.change_direction($state, "up")
  when 'Down'
    # SnakeState.state_snake_down($state)
    $state, can_move = SnakeState.change_direction($state, "down")
  when 'Left'
    # SnakeState.state_snake_left($state)
    $state, can_move = SnakeState.change_direction($state, "left")
  when 'Right'
    # SnakeState.state_snake_right($state)
    $state, can_move = SnakeState.change_direction($state, "right")
  when "r", "R", "к", "К"
    $state = SnakeState.generate_state(BOARD_SIZE)
    can_move = false
  end
  # if SnakeState.eating?($state)
  #   $state[:food] = SnakeState.generate_random_food_position($state)
  # end

  $state = SnakeState.move_snake($state) if can_move

  $state = SnakeState.eat_and_gen_food($state)

  $state = SnakeState.maybe_end_game($state)


  replace_text(
    # event.inspect    
    # Gdk::Keyval.to_name(event.keyval) +
    # "\n\n" +
    # state_to_matrix($state).to_json
    SnakeState.state_to_string($state)
  )
}

window.signal_connect("delete-event") { |_widget| Gtk.main_quit }

window.show_all

replace_text(SnakeState.state_to_string($state))

Gtk.main

