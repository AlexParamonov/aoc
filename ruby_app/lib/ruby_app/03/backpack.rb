module RubyApp
  class Backpack
    def initialize(content: nil, compartments: nil)
      @content = content
      @compartments = compartments
    end

    def find_duplicates
      compartments.reduce(&:intersection)
    end

    private

    attr_reader :content

    def compartments
      @compartments ||= content.chars.each_slice(content.length / 2)
    end
  end
end
