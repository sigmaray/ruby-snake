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

    @state = SnakeState.generate_state(@options[:size])

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
    case event.keyCode
    when KeyEvent::VK_LEFT
      @state = SnakeState.on_key_press(@state, "left")
    when KeyEvent::VK_RIGHT
      @state = SnakeState.on_key_press(@state, "right")
    when KeyEvent::VK_UP
      @state = SnakeState.on_key_press(@state, "up")
    when KeyEvent::VK_DOWN
      @state = SnakeState.on_key_press(@state, "down")
    end

    if event.getKeyChar < 256 && %w[r R к К].include?(event.getKeyChar.chr)
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
