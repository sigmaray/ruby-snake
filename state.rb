# frozen_string_literal: true

# Tried to move all the functions that create
# and modify state into separate module.
# I don't like OOP, so I'm using module instead of class.
module SnakeState
  # MATRIX_TYPE_TAIL = 't'
  # MATRIX_TYPE_TAIL = '★'
  MATRIX_TYPE_TAIL = "*"

  # MATRIX_TYPE_HEAD = 'h'
  # MATRIX_TYPE_HEAD = '★'
  MATRIX_TYPE_HEAD = "♥"  

  # MATRIX_TYPE_FOOD = 'f'
  # MATRIX_TYPE_FOOD = '@'
  MATRIX_TYPE_FOOD = "⬥"

  # MATRIX_TYPE_EMPTY = '█'
  MATRIX_TYPE_EMPTY = "_"

  def self.try_to_eat(old_state)    
    return old_state unless SnakeState.state_is_eating(old_state)

    state = deep_copy(old_state)
    state[:food] = SnakeState.generate_random_food_position(state)
    state
  end

  def self.generate_state(board_size)
    state = {
      board_size:,
      segments: [
        # {x: 1, y: 1},
        generate_random_snake_position(board_size)
      ],
      food: nil,
      direction: "right",
      is_over: false
    }
    state[:food] = generate_random_food_position(state)
    state
  end

  def self.state_to_matrix(state)
    matrix = generate_empty_matrix(state[:board_size])
    if state.key?(:food) && !state[:food].nil? # rubocop:disable Style/IfUnlessModifier
      matrix[state[:food][:y]][state[:food][:x]] = MATRIX_TYPE_FOOD
    end
    state[:segments].each do |segment|
      matrix[segment[:y]][segment[:x]] = MATRIX_TYPE_TAIL
    end
    matrix[state[:segments][0][:y]][state[:segments][0][:x]] = MATRIX_TYPE_HEAD
    matrix
  end

  def self.state_to_string(state)
    return "You won.\nPress R to restart the game." if state[:is_over]

    matrix = state_to_matrix(state)
    return if matrix.empty?

    out = ""
    matrix.each.with_index do |row, i|
      row.each do |segment|
        out += segment
      end
      out += "\n" if i != (matrix.length - 1)
    end
    out += "\n#{state.inspect}\n\n"

    out
  end

  def self.change_direction(old_state, new_direction)
    state = deep_copy(old_state)
    correct_switch = true
    case new_direction
    when "up"
      if state[:segments].length >= 2 && state[:direction] == "down"
        correct_switch = false
      else
        state[:direction] = new_direction
      end
    when "down"
      if state[:segments].length >= 2 && state[:direction] == "up"
        correct_switch = false
      else
        state[:direction] = new_direction
      end
    when "left"
      if state[:segments].length >= 2 && state[:direction] == "right"
        correct_switch = false
      else
        state[:direction] = new_direction
      end
    when "right"
      if state[:segments].length >= 2 && state[:direction] == "left"
        correct_switch = false
      else
        state[:direction] = new_direction
      end
    end
    
    return state, correct_switch
  end

  def self.move_snake(old_state)
    state = deep_copy(old_state)
    new_head = deep_copy(state[:segments][0]) # .clone
    case state[:direction]
    when "up"
      if new_head[:y] > 0
        new_head[:y] -= 1
      else
        new_head[:y] = state[:board_size] - 1
      end
    when "down"
      if new_head[:y] < state[:board_size] - 1
        new_head[:y] += 1
      else
        new_head[:y] = 0
      end
    when "left"
      if new_head[:x] > 0
        new_head[:x] -= 1
      else
        new_head[:x] = state[:board_size] - 1
      end
    when "right"
      if new_head[:x] < state[:board_size] - 1
        new_head[:x] += 1
      else
        new_head[:x] = 0
      end
    end
    state[:segments].unshift(new_head)
    state[:segments].pop unless state_is_eating(state)
    state
  end

  def self.state_is_game_over(old_state)
    state = deep_copy(old_state)
    res = state[:segments].length == state[:board_size] * state[:board_size]
    state[:is_over] = res
    state
  end

  private

  def self.deep_copy(item)
    Marshal.load(Marshal.dump(item))
  end

  def self.state_is_eating(state)
    return false if state[:food].nil?

    state[:food] == state[:segments][0]
  end

  def self.generate_random_food_position(state)
    empty = state_find_empty_segments(state)
    empty.sample
  end

  def self.generate_random_snake_position(board_size)
    { x: rand(0..(board_size - 1)), y: rand(0..(board_size - 1)) }
  end

  def self.state_find_empty_segments(state)
    matrix = state_to_matrix(state)
    empty_segments = []
    state[:board_size].times do |y|
      state[:board_size].times do |x|
        empty_segments << ({ y:, x: }) if matrix[y][x] == MATRIX_TYPE_EMPTY
      end
    end
    empty_segments
  end

  def self.generate_empty_matrix(board_size)
    matrix = []
    board_size.times do |y|
      matrix[y] = []
      board_size.times do |x|
        matrix[y][x] = MATRIX_TYPE_EMPTY
      end
    end
    matrix
  end
end
