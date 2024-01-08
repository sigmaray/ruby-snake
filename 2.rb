require "gtk3"

window = Gtk::Window.new("First example")
window.set_size_request(400, 400)
window.set_border_width(10)

# button = Gtk::Button.new(:label => "Say hello")
# button.signal_connect "clicked" do |_widget|
#   puts "Hello World!!"
# end

# window.add(button)


text_view = Gtk::TextView.new
window.add(text_view)

window.signal_connect("key-press-event") do |_widget, event|
  # Gdk::Keyval::name
  # p event.inspect
  # Gdk::Keyval
  # p event.keyval
  # p Gdk::Keyval.to_name(event.keyval)
  text_view.buffer.set_text(Gdk::Keyval.to_name(event.keyval))
  text_view.set_editable(false)
  if ["Up", "Down", "Left", "Right"].include?(Gdk::Keyval.to_name(event.keyval))
    p 'in arrows'
  end
end

window.signal_connect("delete-event") { |_widget| Gtk.main_quit }

window.show_all

Gtk.main
