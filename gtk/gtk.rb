# frozen_string_literal: true

require "gtk3"

require_relative "../lib/options"
require_relative "../lib/state"

options = parse_env

state = SnakeState.generate_state(options[:size])

window = Gtk::Window.new("Snake in Ruby/GTK3")
window.set_size_request(400, 400)
window.set_border_width(10)

text_view = Gtk::TextView.new
font_description = Pango::FontDescription.new("Monospace 16")
text_view.override_font(font_description)
text_view.set_editable(false)
window.add(text_view)
def replace_text(text_view, str)
  text_view.buffer.text = str
end

if options[:use_timer]
  GLib::Timeout.add(options[:timeout]) do
    state = SnakeState.on_timer(state)
    replace_text text_view, SnakeState.state_to_string(state)
  end
end

window.signal_connect("key-press-event") do |_widget, event|
  k = Gdk::Keyval.to_name(event.keyval)
  case k
  when "Up"
    state = SnakeState.on_key_press(state, "up")
  when "Down"
    state = SnakeState.on_key_press(state, "down")
  when "Left"
    state = SnakeState.on_key_press(state, "left")
  when "Right"
    state = SnakeState.on_key_press(state, "right")
  when "r", "R", "к", "К"
    state = SnakeState.on_key_press(state, "r")
  end

  replace_text(
    text_view,
    SnakeState.state_to_string(state)
  )
end

window.signal_connect("delete-event") { |_widget| Gtk.main_quit }

window.show_all

replace_text(text_view, SnakeState.state_to_string(state))

Gtk.main
