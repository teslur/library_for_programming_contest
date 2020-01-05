module MyPriorityQueue
  class Node
    attr_accessor :key, :value, :parent, :children

    def initialize(key:, value:)
      @key = key
      @value = value
      @parent = nil
      @children = []
    end

    def root?
      parent.nil?
    end

    def leaf?
      children.empty?
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

      popped_node = nodes[1]                                  # popされるノードを退避
      last_node_parent_index = (nodes.length - 1) / 2         # 最終ノードの親ノードのindexを退避
      node = nodes.pop                                        # ルートに昇格するノードを末尾から取ってくる
      reset_node_relation(node_index: last_node_parent_index) # 最終ノードを取っ払ったのでその親の親子関係リセット
      nodes[1] = node                                         # 最終ノードをルートに昇格
      reset_node_relation(node_index: 1)                      # ルートノードを入れ替えたのでそのノードの親子関係整理

      node_index = 1
      loop do
        break if node.leaf?
        break if node.children.all? { |c| balanced?(parent: node, child: c) }

        if node.children.length == 1
          child_index = node_index * 2
        else
          child_index = ordered?(should_be_prior: node.children[0], should_be_posterior: node.children[1]) ? (node_index * 2) : (node_index * 2 + 1)
        end

        swap(node_index, child_index)
        node_index = child_index
      end

      popped_node
    end

    def push(node:)
      nodes << node
      node_index = nodes.length - 1
      reset_node_relation(node_index: node_index)
      loop do
        break if node.root?
        break if balanced?(parent: node.parent, child: node)

        parent_index = node_index / 2
        swap(node_index, parent_index)
        node_index = parent_index
      end

      self
    end

    private

    def balanced?(parent:, child:)
      return true if parent.nil? || child.nil?
      ordered?(should_be_prior: parent, should_be_posterior: child)
    end

    def swap(node1_index, node2_index)
      return false if node1_index.to_i <= 0 || node2_index.to_i <= 0

      node1 = nodes[node1_index]
      node2 = nodes[node2_index]
      nodes[node1_index] = node2
      nodes[node2_index] = node1
      reset_node_relation(node_index: node1_index)
      reset_node_relation(node_index: node2_index)
    end

    def reset_node_relation(node_index:)
      node = nodes[node_index]
      return unless node

      parent_index = node_index / 2
      node.parent = nodes[parent_index]
      node.children = [nodes[node_index * 2], nodes[node_index * 2 + 1]].compact
      node.parent.children = [nodes[parent_index * 2], nodes[parent_index + 1]].compact if node.parent
      node.children.each { |c| c.parent = node }
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
