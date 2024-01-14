# frozen_string_literal: true

java_import javax.swing.JFrame, javax.swing.SwingUtilities, java.awt.Dimension, java.awt.FlowLayout,
            javax.swing.JLabel, java.awt.Font, java.awt.event.KeyEvent, javax.swing.Timer

require_relative "../state"

USE_TIMER = %w[0 false off].include?(ENV["TIMER"]) ? false : true # rubocop:disable Style/IfWithBooleanLiteralBranches
BOARD_SIZE = ENV["SIZE"].to_i > 1 ? ENV["SIZE"].to_i : 5
TIMEOUT = 500

# JRuby/Swing UI for snake game
class TopFrame < JFrame
  def initialize
    super
    init_components
    pack
    set_visible(true)

    @state = SnakeState.generate_state(BOARD_SIZE)

    print_to_label SnakeState.state_to_string(@state)

    addKeyListener(java.awt.event.KeyListener.impl do |name, event|
      keyPressed(event) if name == :keyPressed
    end)

    return unless USE_TIMER

    timer = Timer.new(TIMEOUT, nil)
    timer.add_action_listener do |_e|
      @state = SnakeState.move_snake(@state)
      @state = SnakeState.eat_and_gen_food(@state)
      @state = SnakeState.maybe_end_game(@state)
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
      @state, can_move = SnakeState.change_direction(@state, "left")
    when KeyEvent::VK_RIGHT
      @state, can_move = SnakeState.change_direction(@state, "right")
    when KeyEvent::VK_UP
      @state, can_move = SnakeState.change_direction(@state, "up")
    when KeyEvent::VK_DOWN
      @state, can_move = SnakeState.change_direction(@state, "down")
    end

    if event.getKeyChar < 256 && %w[r R к К].include?(event.getKeyChar.chr)
      # Restart the game
      @state = SnakeState.generate_state(BOARD_SIZE)
      can_move = false
    end

    @state = SnakeState.move_snake(@state) if can_move

    @state = SnakeState.eat_and_gen_food(@state)

    @state = SnakeState.maybe_end_game(@state)

    print_to_label SnakeState.state_to_string(@state)
  end

  def print_to_label(str)
    @label.setText "<html><pre>#{str}</pre></html>"
  end
end

SwingUtilities.invoke_later do
  TopFrame.new
end
