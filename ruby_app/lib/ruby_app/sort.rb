module RubyApp
  class Sort
    def initialize(array)
      @array = array
    end

    def sort
      array.sort
    end

    private

    attr_reader :array
  end
end
