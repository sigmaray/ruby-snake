require 'yaml'
module SnakeState
  # MATRIX_SIZE = 10
  # MATRIX_SIZE = 2
  # MATRIX_SIZE = 5
  # MATRIX_SIZE = 2
  # MATRIX_SIZE = 3

  # MATRIX_TYPE_TAIL = 't'
  # MATRIX_TYPE_TAIL = '★'
  MATRIX_TYPE_TAIL = '*'

  # MATRIX_TYPE_HEAD = 'h'
  # MATRIX_TYPE_HEAD = '♥'
  MATRIX_TYPE_HEAD = '★'


  # MATRIX_TYPE_FOOD = 'f'
  # MATRIX_TYPE_FOOD = '@'
  MATRIX_TYPE_FOOD = '⬥'

  # MATRIX_TYPE_EMPTY = '█'
  MATRIX_TYPE_EMPTY = '_'

  # $state = {
  #   segments: [
  #     {x: 1, y: 1}
  #   ],
  #   food: {x: 5, y: 5}
  # }

  def self.state_find_empty_segments(state)
    matrix = state_to_matrix(state)
    empty_segments = []
    state[:board_size].times do |y|
      state[:board_size].times do |x|
        # p ({x:, y:})
        # matrix[y][x] = '_'
        if matrix[y][x] == MATRIX_TYPE_EMPTY
          empty_segments << {y:, x:}
        end
      end
    end
    return empty_segments
  end

  def self.generate_random_food_position(state)
    empty = state_find_empty_segments(state)
    return empty.sample
  end

  def self.generate_random_snake_position(board_size)
    # empty = state_find_empty_segments(state)
    # return empty.sample
    return {x: rand(0..(board_size-1)), y: rand(0..(board_size-1))}
  end

  def self.try_to_eat(state)
    if SnakeState.state_is_eating(state)
      state[:food] = SnakeState.generate_random_food_position(state)
    end
  end

  def self.generate_state(board_size)
    state = {
      board_size:,
      segments: [
        # {x: 1, y: 1},
        self.generate_random_snake_position(board_size)
      ],
      food: nil,
      direction: 'right',
      is_over: false
    }
    state[:food] = generate_random_food_position(state)
    return state
  end

  def self.generate_empty_matrix(board_size)
    matrix = []
    board_size.times do |y|
      matrix[y] = []
      board_size.times do |x|
        # p ({x:, y:})
        matrix[y][x] = MATRIX_TYPE_EMPTY
      end
    end
    return matrix
  end

  def self.state_to_matrix(state)
    matrix = generate_empty_matrix(state[:board_size])
    if !state.key?(:food) || !state[:food].nil?
      matrix[state[:food][:y]][state[:food][:x]] = MATRIX_TYPE_FOOD
    end
    state[:segments].each_with_index do |segment, i|
      # matrix[segment[:y]][segment[:x]] = (i == 0) ? MATRIX_TYPE_HEAD : MATRIX_TYPE_TAIL
      matrix[segment[:y]][segment[:x]] = MATRIX_TYPE_TAIL
    end
    matrix[state[:segments][0][:y]][state[:segments][0][:x]] = MATRIX_TYPE_HEAD
    return matrix
  end

  def self.state_to_boad_string(state)
    if state[:is_over]
      return "you won.\ngame is over"
    end

    matrix = state_to_matrix(state)
    return if matrix.length == 0
    out = ''
    out += state.inspect + "\n\n"
    matrix.each.with_index do |row, i|
      # out += "["
      row.each.with_index do |segment, j|
        out += segment
        # out += ' ' if j != (row.length - 1)
      end
      # out += "]\n"
      out += "\n" if i != (matrix.length - 1)
    end

    out
  end

  def self.change_direction(state, new_direction)
    correct_switch = true
    # n = state[:direction]
    case new_direction
    when 'up'
      # if true #if state[:direction] != 'down'
      if !(state[:segments].length > 0 && state[:direction] == 'down')
        state[:direction] = new_direction
        # self.move_snake(state)
      else
        correct_switch = false
      end
    when 'down'
      # n = new_direction if state[:direction] != 'up'
      # if true #if state[:direction] != 'up'
      if !(state[:segments].length > 0 && state[:direction] == 'up')
        state[:direction] = new_direction
        # self.move_snake(state)
      else
        correct_switch = false
      end
    when 'left'
      # n = new_direction if state[:direction] != 'right'
      if !(state[:segments].length > 0 && state[:direction] == 'right')
        state[:direction] = new_direction
        # self.move_snake(state)
      else
        correct_switch = false
      end
    when 'right'
      # n = new_direction if state[:direction] != 'left'
      # if true #if state[:direction] != 'left'
      if !(state[:segments].length > 0 && state[:direction] == 'left')
        state[:direction] = new_direction
        # self.move_snake(state)
      else
        correct_switch = false
      end
    end    
  end
  def self.deep_copy(o)
    Marshal.load(Marshal.dump(o))
  end

  def self.move_snake(state)
    new_head = self.deep_copy(state[:segments][0])#.clone
    case state[:direction]
    when 'up'
      if new_head[:y] > 0
        new_head[:y] -= 1
      else
        new_head[:y] = state[:board_size] - 1
      end
    when 'down'
      if new_head[:y] < state[:board_size] - 1
        new_head[:y] += 1
      else
        new_head[:y] = 0
      end
    when 'left'
      if new_head[:x] > 0
        new_head[:x] -= 1
      else
        new_head[:x] = state[:board_size] - 1
      end
    when 'right'
      if new_head[:x] < state[:board_size] - 1
        new_head[:x] += 1
      else
        new_head[:x] = 0
      end
    end
    state[:segments].unshift(new_head)
    state[:segments].pop if !self.state_is_eating(state)    
  end

  def self.state_is_eating(state)
    return false if state[:food].nil?

    return state[:food] == state[:segments][0]
  end

  def self.state_is_game_over(state)
    res = state[:segments].length == state[:board_size] * state[:board_size]    
    state[:is_over] = res
    return res
  end

  # print state_to_matrix($state).to_yaml
end


