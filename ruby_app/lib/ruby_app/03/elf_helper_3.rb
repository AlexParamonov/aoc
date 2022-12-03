require_relative "backpack"
require_relative "priority_evaluator"

module RubyApp
  class ElfHelper3
    def initialize(input)
      @input = input
    end

    def find_duplicate_priorities_sum
      item_lists.map do |item_list|
        duplicates = Backpack.new(content: item_list).find_duplicates

        evaluate_priorities(duplicates)
      end.flatten.sum
    end

    def find_group_item_priorities_sum
      groups.map do |group_items|
        compartments = group_items.map(&:chars)
        group_backpack = Backpack.new(compartments:)
        duplicates = group_backpack.find_duplicates

        evaluate_priorities(duplicates)
      end.flatten.sum
    end

    private

    def evaluate_priorities(duplicates)
      duplicates.uniq.map do |duplicate|
        PriorityEvaluator.new(duplicate).evaluate
      end
    end

    def item_lists
      @item_lists ||= @input.strip.split("\n")
    end

    def groups
      @groups ||= item_lists.each_slice(3).to_a
    end
  end
end
