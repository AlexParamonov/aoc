module RubyApp
  class ElfStash
    def initialize(raw_stash, group_size:)
      @raw_stash = raw_stash
      @group_size = group_size
    end

    def top_carrier_calories
      stash[top_carrier].sum
    end

    def top_group_calories
      stash.slice(*top_group_carriers).values.flatten.sum
    end

    def top_carrier
      stash.max_by { |_index, calories| calories.sum }.first
    end

    def top_group_carriers
      stash.sort_by { |_index, calories| calories.sum }.last(group_size).reverse.map(&:first)
    end

    private

    attr_reader :group_size

    def stash
      @stash ||= load_stash
    end

    def load_stash
      @raw_stash.split("\n\n").map.with_index do |stash, index|
        [index + 1, stash.split("\n").map(&:to_i)]
      end.to_h
    end

    def count_calories
      stash.map(&:to_i).sum
    end
  end
end
