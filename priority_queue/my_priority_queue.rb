module MyPriorityQueue
  class Node
    attr_accessor :key, :value

    def initialize(key:, value:)
      @key = key
      @value = value
    end
  end

  class Tree
    attr_reader :order, :nodes

    def initialize(order: :asc)
      @order = %i[asc desc].include?(order.to_sym) ? order.to_sym : :asc
      @nodes = [nil] # nodes[0]は常にnilとしてルート判定に使う。
    end

    def list
      nodes.compact
    end

    def values
      list.map(&:value)
    end

    def pop
      return nil if nodes.length == 1       # 空のツリーに対するpop
      return nodes.pop if nodes.length == 2 # ルートノードのみのツリーに対するpop

      popped_node = nodes[1] # popされるノードをreturn用に退避
      node = nodes.pop       # ルートに昇格するノードを末尾から取ってくる
      nodes[1] = node        # 最終ノードをルートに昇格

      node_index = 1
      loop do
        children_indexes = children_indexes(node_index: node_index)
        children = children_indexes.map { |cidx| nodes[cidx] }.compact
        break if children.empty? # no children
        break if children.all? { |c| balanced?(parent: node, child: c) }

        if children.length == 1
          child_index = node_index * 2
        else
          child_index = ordered?(should_be_prior: children[0], should_be_posterior: children[1]) ? children_indexes[0] : children_indexes[1]
        end

        swap(node_index, child_index)
        node_index = child_index
      end

      popped_node
    end

    def push(node:)
      nodes << node
      node_index = nodes.length - 1
      loop do
        break if node_index == 1 # root node

        parent_index = parent_index(node_index: node_index)
        break if balanced?(parent: nodes[parent_index], child: node)

        swap(node_index, parent_index)
        node_index = parent_index
      end

      self
    end

    private

    def parent_index(node_index:)
      node_index / 2
    end

    def children_indexes(node_index:)
      [node_index * 2, node_index * 2 + 1]
    end

    def balanced?(parent:, child:)
      ordered?(should_be_prior: parent, should_be_posterior: child)
    end

    def swap(node1_index, node2_index)
      node1 = nodes[node1_index]
      node2 = nodes[node2_index]
      nodes[node1_index] = node2
      nodes[node2_index] = node1
    end

    def ordered?(should_be_prior:, should_be_posterior:)
      case order
      when :asc
        should_be_prior.key <= should_be_posterior.key
      when :desc
        should_be_prior.key >= should_be_posterior.key
      else
        should_be_prior.key <= should_be_posterior.key
      end
    end
  end
end