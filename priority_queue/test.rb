require './my_priority_queue'

values = Array.new(500) { rand(1..100) }

tree = MyPriorityQueue::Tree.new(order: :asc)
raise 'values of empty tree should be [].' if tree.values != []

puts 'OK'

values.each { |v| n = MyPriorityQueue::Node.new(key: v, value: v); tree.push(node: n) }
ordered_list = (1..500).map { tree.pop.value }
raise 'nodes are not ordered.' if ordered_list != values.sort

puts 'OK'

reverse_tree = MyPriorityQueue::Tree.new(order: :desc)
values.each { |v| n = MyPriorityQueue::Node.new(key: v, value: v); reverse_tree.push(node: n) }
reverse_ordered_list = (1..500).map { reverse_tree.pop.value }
raise 'nodes are not reverse ordered.' if reverse_ordered_list != values.sort.reverse

puts 'OK'
