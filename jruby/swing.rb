# frozen_string_literal: true

java_import javax.swing.JFrame, javax.swing.SwingUtilities, java.awt.Dimension, java.awt.FlowLayout,
            javax.swing.JLabel, java.awt.Font, java.awt.event.KeyEvent, javax.swing.Timer

require_relative "../lib/options"
require_relative "../lib/state"

# JRuby/Swing UI for snake game
class TopFrame < JFrame
  def initialize
    super
    init_components
    pack
    set_visible(true)

    @options = parse_env

    @state = SnakeState.generate_state(@options[:size], @options[:use_timer])

    print_to_label SnakeState.state_to_string(@state)

    addKeyListener(java.awt.event.KeyListener.impl do |name, event|
      keyPressed(event) if name == :keyPressed
    end)

    return unless @options[:use_timer]

    timer = Timer.new(@options[:timeout], nil)
    timer.add_action_listener do |_e|
      @state = SnakeState.on_timer(@state)
      print_to_label SnakeState.state_to_string(@state)
    end
    timer.start
  end

  def init_components
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    set_preferred_size(Dimension.new(400, 300))

    setLayout(FlowLayout.new)

    @label = JLabel.new
    @label.setFont(Font.new("Monospaced", Font::PLAIN, 24))
    getContentPane.add(@label)
  end

  def keyPressed(event) # rubocop:disable Naming/MethodName
    k = if event.getKeyChar < 256
      event.getKeyChar.chr
    else
      event.keyCode
    end
    
    case k
    when KeyEvent::VK_UP, "w", "W", "ц", "Ц"
      @state = SnakeState.on_key_press(@state, "up")
    when KeyEvent::VK_DOWN, "s", "S", "Ы", "Ы"
      @state = SnakeState.on_key_press(@state, "down")
    when KeyEvent::VK_LEFT, "a", "A", "ф", "Ф"
      @state = SnakeState.on_key_press(@state, "left")
    when KeyEvent::VK_RIGHT, "d", "D", "в", "В"
      @state = SnakeState.on_key_press(@state, "right")
    when "r", "R", "к", "К"
      @state = SnakeState.on_key_press(@state, "r")
    end

    print_to_label SnakeState.state_to_string(@state)
  end

  def print_to_label(str)
    @label.setText "<html><pre>#{str}</pre></html>"
  end
end

SwingUtilities.invoke_later do
  TopFrame.new
end
