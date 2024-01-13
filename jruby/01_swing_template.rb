#01_swing_template.rb

require_relative 'java_imports'
require_relative "../state"

USE_TIMER = %w[0 false off].include?(ENV["TIMER"]) ? false : true # rubocop:disable Style/IfWithBooleanLiteralBranches
BOARD_SIZE = ENV["SIZE"].to_i > 1 ? ENV["SIZE"].to_i : 5
TIMEOUT = 500

# $state = generate_state()
# KeyEvent = java.awt.event.KeyEvent
java_import java.awt.event.KeyEvent

# state_to_string($state)

class TopFrame < JFrame
  # include java.awt.event.KeyListener


  def initialize
    super
    init_components()
    pack()
    set_visible(true)
    # keyPressed(nil)

    @state = SnakeState.generate_state(BOARD_SIZE)

    print_to_label SnakeState.state_to_string(@state)
  end
  
  def init_components()
    # self.addKeyListener(self)
    self.add_key_listener java.awt.event.KeyListener.impl { |name, event|
      # raise '12345'      
      keyPressed(event) if name == :keyPressed
    }
    set_default_close_operation(JFrame::EXIT_ON_CLOSE)
    set_preferred_size(Dimension.new(400, 300))

    self.setLayout(FlowLayout.new);    


    # @text_area = JTextArea.new(10, 20)
    # @text_area.editable = false
    # self.getContentPane().add(@text_area);

    # set_right_component(@text_area)
    # self.addKeyListener(self)

    @label = JLabel.new
    @label.setFont(Font.new("Monospaced", Font::PLAIN, 24));
    self.getContentPane().add(@label)
  end

  # def keyName(code)
  #   name = KeyEvent.constants.select{|c| c.index('VK_') == 0}.find{|vk| code == KeyEvent.const_get(vk)}
  #   return name[3..name.size] if name
  # end
  
  # def keyChar(char)
  #   if (char == 65535) then nil
  #   else char.chr.upcase
  #   end
  # end
  
  # def keyRepr(event)
  #   name = keyName(event.getKeyCode)
  #   char = keyChar(event.getKeyChar)
  #   if char and char > ' ' then char
  #   else name
  #   end
  # end
  

  def keyPressed(event)
    case event.keyCode
    when KeyEvent::VK_LEFT
      @label.setText 'left'
      @state, can_move = SnakeState.change_direction(@state, "left")
    when KeyEvent::VK_RIGHT
      @label.setText 'right'
      # state_snake_right($state)
      @state, can_move = SnakeState.change_direction(@state, "right")
    when KeyEvent::VK_UP
      @label.setText 'up'
      # state_snake_up($state)
      @state, can_move = SnakeState.change_direction(@state, "up")
    when KeyEvent::VK_DOWN
      @label.setText 'down'
      # state_snake_down($state)
      @state, can_move = SnakeState.change_direction(@state, "down")
    end

    if event.getKeyChar() < 256
      # @label.setText event.getKeyChar.to_s
      if ["r", "R", "к", "К"].include?(event.getKeyChar().chr)
        @label.setText event.getKeyChar().chr()
        @state = SnakeState.generate_state(BOARD_SIZE)
        can_move = false
      end
    end

    @state = SnakeState.move_snake(@state) if can_move

    @state = SnakeState.eat_and_gen_food(@state)

    @state = SnakeState.state_is_game_over(@state)

    # @label.setText(SnakeState.state_to_string(@state))
    print_to_label SnakeState.state_to_string(@state)

    # if is_eating?($state)
    #   $state[:food] = generate_random_food_position($state)
    # end
    # # t += "\n\n"
    # # t += 
    # # @label.setText t
    # pppp = state_to_string($state)
    # t = "<html><pre>#{pppp}</pre></html>"
    # @label.setText t    
  end

  def print_to_label(str)
    @label.setText "<html><pre>#{str}</pre></html>"
  end
  
end

SwingUtilities.invoke_later do
  TopFrame.new
end
