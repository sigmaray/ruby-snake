#01_swing_template.rb

require './java_imports.rb'
require "../state.rb"

$state = generate_state()

# KeyEvent = java.awt.event.KeyEvent
java_import java.awt.event.KeyEvent

state_to_boad_string($state)

class TopFrame < JFrame
  # include java.awt.event.KeyListener


  def initialize
    super
    init_components()
    pack()
    set_visible(true)
    # keyPressed(nil)
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

    @label = JLabel.new("123")
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
    # raise 'l31'
    # raise "l32"
    # if event.getKeyCode == 10
    #   # print "]\n["
    # else
      # print "'#{keyRepr(event)}', "
      # @label.setText event.getKeyChar()
      # @label.setText keyRepr(event)
      # if (keyCode == KeyEvent.VK_LEFT || keyCode == KeyEvent.VK_RIGHT) {
      #   handleArrowKey(keyCode == KeyEvent.VK_RIGHT);
      # }
      # t = event.keyCode.to_s
      case event.keyCode
      when KeyEvent::VK_LEFT
        # @label.setText 'left'
        state_snake_left($state)
      when KeyEvent::VK_RIGHT
        # @label.setText 'left'
        state_snake_right($state)
      when KeyEvent::VK_UP
        # @label.setText 'up'
        state_snake_up($state)
      when KeyEvent::VK_DOWN
        # @label.setText 'down'
        state_snake_down($state)
      end

      if state_is_eating($state)
        $state[:food] = generate_random_food_position($state)
      end
      # t += "\n\n"
      # t += 
      # @label.setText t
      pppp = state_to_boad_string($state)
      t = "<html><pre>#{pppp}</pre></html>"
      @label.setText t
    # end
    
  end
  
end

SwingUtilities.invoke_later do
  TopFrame.new
end
