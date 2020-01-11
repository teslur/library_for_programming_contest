module MyKMP
  class KMP
    attr_accessor :haystack, :needle, :haystack_index, :needle_index
    attr_reader :table

    def initialize(haystack:, needle:)
      @haystack = haystack
      @needle = needle
      @haystack_index = 0
      @needle_index = 0

      @table = construct_table
    end

    def find
      haystack_length = haystack.length
      needle_length = needle.length
      return nil if haystack_index >= haystack_length

      while haystack_index + needle_index < haystack_length
        if needle[needle_index] == haystack[haystack_index + needle_index]
          self.needle_index += 1
          return haystack_index if needle_index == needle_length
        else
          self.haystack_index = haystack_index + needle_index - table[needle_index]
          self.needle_index = table[needle_index] if needle_index > 0
        end
      end
      nil
    end

    def next
      self.haystack_index += 1
      find
    end

    def reset
      self.haystack_index = 0
      self.needle_index = 0
      reset_table
    end

    private

    def reset_table
      @table = construct_table
    end

    def construct_table
      needle_length = needle.length
      table = Array.new(needle_length)
      table[0] = -1
      table[1] = 0
      idx = 2
      sub_idx = 0
      while idx < needle_length
        if needle[idx - 1] == needle[sub_idx]
          table[idx] = sub_idx + 1
          idx += 1
          sub_idx += 1
        elsif sub_idx > 0
          sub_idx = table[sub_idx]
        else
          table[idx] = 0
          idx += 1
        end
      end
      table
    end
  end
end