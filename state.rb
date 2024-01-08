require 'yaml'

MATRIX_SIZE = 10

MATRIX_TYPE_TAIL = 't'
MATRIX_TYPE_HEAD = 'h'
MATRIX_TYPE_FOOD = 'f'

$state = {
  segments: [
    {x: 1, y: 1}
  ],
  food: {x: 5, y: 5}
}

def state_to_matrix(state)
  matrix = []
  MATRIX_SIZE.times do |y|
    matrix[y] = []
    MATRIX_SIZE.times do |x|
      # p ({x:, y:})
      matrix[y][x] = '_'
    end
  end
  if !state[:food].nil?
    matrix[state[:food][:y]][state[:food][:x]] = MATRIX_TYPE_FOOD
  end
  state[:segments].each_with_index do |segment, i|
    matrix[segment[:y]][segment[:x]] = (i == 0) ? MATRIX_TYPE_HEAD : MATRIX_TYPE_TAIL
  end
  return matrix
end

def state_to_boad_string(state)
  matrix = state_to_matrix(state)
  return if matrix.length == 0
  out = ''  
  matrix.each do |row|
    out += "["
    row.each do |segment|
      out += segment + ' '
    end
    out += "]\n"
  end
  
  out
end

def state_snake_up(state) 
  if state[:segments][0][:y] > 0
    state[:segments][0][:y] -= 1    
  else
    state[:segments][0][:y] = MATRIX_SIZE - 1    
  end
end

def state_snake_down(state) 
  if state[:segments][0][:y] < MATRIX_SIZE - 1
    state[:segments][0][:y] += 1    
  else
    state[:segments][0][:y] = 0
  end
end

def state_snake_left(state) 
  if state[:segments][0][:x] > 0
    state[:segments][0][:x] -= 1    
  else
    state[:segments][0][:x] = MATRIX_SIZE - 1    
  end
end

def state_snake_right(state) 
  if state[:segments][0][:x] < MATRIX_SIZE - 1
    state[:segments][0][:x] += 1    
  else
    state[:segments][0][:x] = 0
  end
end

print state_to_matrix($state).to_yaml
