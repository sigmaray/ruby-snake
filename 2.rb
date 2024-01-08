require "gtk3"
require "json"
require "./state.rb"

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

window.signal_connect("key-press-event") { |_widget, event|
  # p event.inspect
  k = Gdk::Keyval.to_name(event.keyval)
    if k == 'Up'
      state_snake_up($state)
    elsif k == 'Down'
      state_snake_down($state)
    elsif k == 'Left'
      state_snake_left($state)
    elsif k == 'Right'
      state_snake_right($state)
    end
  replace_text(
    # event.inspect    
    Gdk::Keyval.to_name(event.keyval) +
    "\n\n" +
    # state_to_matrix($state).to_json
    state_to_boad_string($state)
  )
}

window.signal_connect("delete-event") { |_widget| Gtk.main_quit }

window.show_all

def replace_text(str)
  $view1.buffer.text = str
end

Gtk.main

