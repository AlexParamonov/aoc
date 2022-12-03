module RubyApp
  class PriorityEvaluator
    def initialize(item)
      @item = item
    end

    def evaluate
      case item
      when ("a".."z") then item.ord - 96
      when ("A".."Z") then item.ord - 38
      else
        raise ArgumentError, "Invalid item: #{item}"
      end
    end

    private

    attr_reader :item
  end
end
