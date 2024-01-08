MATRIX_SIZE = 10

state = {
  segments: [
    {x: 1, y: 1}
  ],
  food: {x: 5, y: 5}
}

def state_to_matrix(state)
  MATRIX_SIZE.times do |y|
    MATRIX_SIZE.times do |x|
      p ({x:, y:})
    end
  end
end

state_to_matrix(state)