require './my_kmp'

needle = 'ABCDABD'
haystack = 'ABC ABCDAB ABCDABCDABDE'
kmp = MyKMP::KMP.new(needle: needle, haystack: haystack)

raise 'Table construction failed.' if kmp.table != [-1, 0, 0, 0, 0, 1, 2]

puts 'OK'

puts kmp.find
