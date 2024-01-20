# frozen_string_literal: true

def parse_env
  use_timer = %w[0 false off].include?(ENV["TIMER"]) ? false : true # rubocop:disable Style/IfWithBooleanLiteralBranches
  size = ENV["SIZE"].to_i > 1 ? ENV["SIZE"].to_i : 5
  timeout = ENV["TIMEOUT"].to_i > 1 ? ENV["TIMEOUT"].to_i : 300

  {
    use_timer:,
    size:,
    timeout:
  }
end
