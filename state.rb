require 'yaml'
module SnakeState
  MATRIX_SIZE = 10

  # MATRIX_TYPE_TAIL = 't'
  MATRIX_TYPE_TAIL = '★'

  # MATRIX_TYPE_HEAD = 'h'
  MATRIX_TYPE_HEAD = '♥'


  # MATRIX_TYPE_FOOD = 'f'
  MATRIX_TYPE_FOOD = '@'

  MATRIX_TYPE_EMPTY = '█'



  # $state = {
  #   segments: [
  #     {x: 1, y: 1}
  #   ],
  #   food: {x: 5, y: 5}
  # }

  def self.state_find_empty_segments(state)
    matrix = state_to_matrix(state)
    empty_segments = []
    MATRIX_SIZE.times do |y|
      MATRIX_SIZE.times do |x|
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

  def self.generate_random_snake_position
    # empty = state_find_empty_segments(state)
    # return empty.sample
    return {x: rand(1..(MATRIX_SIZE-1)), y: rand(1..(MATRIX_SIZE-1))}
  end

  def self.try_to_eat(state)
    if SnakeState.state_is_eating(state)
      state[:food] = SnakeState.generate_random_food_position(state)
    end
  end

  def self.generate_state
    state = {
      segments: [
        # {x: 1, y: 1},
        self.generate_random_snake_position()
      ],
      food: nil
    }
    state[:food] = generate_random_food_position(state)
    return state
  end

  def self.generate_empty_matrix
    matrix = []
    MATRIX_SIZE.times do |y|
      matrix[y] = []
      MATRIX_SIZE.times do |x|
        # p ({x:, y:})
        matrix[y][x] = MATRIX_TYPE_EMPTY
      end
    end
    return matrix
  end

  def self.state_to_matrix(state)
    matrix = generate_empty_matrix()
    if !state.key?(:food) || !state[:food].nil?
      matrix[state[:food][:y]][state[:food][:x]] = MATRIX_TYPE_FOOD
    end
    state[:segments].each_with_index do |segment, i|
      matrix[segment[:y]][segment[:x]] = (i == 0) ? MATRIX_TYPE_HEAD : MATRIX_TYPE_TAIL
    end
    return matrix
  end

  def self.state_to_boad_string(state)
    matrix = state_to_matrix(state)
    return if matrix.length == 0
    out = ''
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

  def self.state_snake_up(state)
    if state[:segments][0][:y] > 0
      state[:segments][0][:y] -= 1
    else
      state[:segments][0][:y] = MATRIX_SIZE - 1
    end
  end

  def self.state_snake_down(state)
    if state[:segments][0][:y] < MATRIX_SIZE - 1
      state[:segments][0][:y] += 1
    else
      state[:segments][0][:y] = 0
    end
  end

  def self.state_snake_left(state)
    if state[:segments][0][:x] > 0
      state[:segments][0][:x] -= 1
    else
      state[:segments][0][:x] = MATRIX_SIZE - 1
    end
  end

  def self.state_snake_right(state)
    if state[:segments][0][:x] < MATRIX_SIZE - 1
      state[:segments][0][:x] += 1
    else
      state[:segments][0][:x] = 0
    end
  end

  def self.state_is_eating(state)
    return false if state[:food].nil?

    return state[:food] == state[:segments][0]
  end

  # print state_to_matrix($state).to_yaml
end


