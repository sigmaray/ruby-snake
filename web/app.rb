# frozen_string_literal: true

require "sinatra"
require "slim"
require "yaml"

require_relative "../lib/state"
require_relative "../lib/options"

options = parse_env
size = options[:size]
state = SnakeState.generate_state(size, false)

get "/" do
  key = params[:key].to_s.strip.downcase
  state = SnakeState.on_key_press(state, key) if %w[up down left right r].include? key
  @state = state
  slim :index
end
