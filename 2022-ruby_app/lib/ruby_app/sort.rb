require "forwardable"

module RubyApp
  class Sort
    extend Forwardable
    def_delegator :array, :sort

    def initialize(array)
      @array = array
    end

    private

    attr_reader :array
  end
end
