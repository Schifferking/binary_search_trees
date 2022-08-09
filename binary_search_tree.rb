class Node
  include Comparable
  attr_accessor :data, :left, :right

  def <=>(other)
    data <=> other.data
  end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(numbers)
    @root = build_tree(numbers)
  end

  def build_tree(data)
    return nil if data.empty?

    data.uniq! unless data == data.uniq

    data.sort! unless data == data.sort

    middle = data.size / 2
    root = Node.new data[middle]

    root.left = build_tree(data[0, middle])

    root.right = build_tree(data[middle + 1..-1])

    root
  end

  def insert(value, root = self.root)
    return Node.new value if root.nil?
    return root if root.data == value

    root.right = insert(value, root.right) if root.data < value
    root.left = insert(value, root.left) if root.data > value
    root
  end

  def delete(value, node = self.root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
      return node
    elsif value > node.data
      node.right = delete(value, node.right)
      return node
    end

    # leaf node
    return nil if node.left.nil? && node.right.nil?

    # One empty child
    if node.left.nil?
      tmp = node.right
      node = nil
      return tmp
    elsif node.right.nil?
      tmp = node.left
      node = nil
      return tmp
    end
  end

  def find(value, root = self.root)
    return nil if root.nil?
    return root if value == root.data

    if value < root.data
      find(value, root.left)
    elsif value > root.data
      find(value, root.right)
    end
  end

  def level_order(&block)
    tree_elements_ = []
    tree_elements_ << root

    unless block_given?
      tree_elements = []
      tree_elements << root.data
    end

    until tree_elements_.empty?
      current = tree_elements_.shift
      block.call(current) if block_given?
      tree_elements_ << current.left unless current.left.nil?
      tree_elements_ << current.right unless current.right.nil?

      unless block_given?
        tree_elements << current.left.data unless current.left.nil?
        tree_elements << current.right.data unless current.right.nil?
      end

    end

    tree_elements unless block_given?
  end

  def inorder(node = root, tree_elements = [], &block)
    return nil if node.nil?

    inorder(node.left, tree_elements, &block)
    tree_elements << node.data unless block_given?
    block.call(node) if block_given?
    inorder(node.right, tree_elements, &block)
    tree_elements unless block_given?
  end

  def preorder(node = root, tree_elements = [], &block)
    return nil if node.nil?

    tree_elements << node.data unless block_given?
    block.call(node) if block_given?
    preorder(node.left, tree_elements, &block)
    preorder(node.right, tree_elements, &block)
    tree_elements unless block_given?
  end

  def postorder(node = root, tree_elements = [], &block)
    return nil if node.nil?

    postorder(node.left, tree_elements, &block)
    postorder(node.right, tree_elements, &block)
    tree_elements << node.data unless block_given?
    block.call(node) if block_given?
    tree_elements unless block_given?
  end

  def height(node, current_height = 0)
    return current_height if node.nil? || node.left.nil? && node.right.nil?

    left_subtree_height = height(node.left, current_height + 1)
    right_subtree_height = height(node.right, current_height + 1)
    return left_subtree_height if left_subtree_height > right_subtree_height
    return right_subtree_height if left_subtree_height < right_subtree_height

    left_subtree_height
  end

  def depth(node)
    return nil if node.nil?

    current = root
    edges_count = 0

    until current.nil?
      return edges_count if node == current.data

      if node < current.data
        current = current.left
      else
        current = current.right
      end

      edges_count += 1
    end
    edges_count
  end

  def balanced?(node = root)
    return if node.nil?

    left_subtree_height = height(node.left)

    right_subtree_height = height(node.right)
    difference = (left_subtree_height - right_subtree_height).abs
    return false if difference >= 2

    balanced?(node.left)

    balanced?(node.right)

    true
  end

  def rebalance
    new_array = inorder
    self.root = build_tree(new_array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new [50]
tree.insert 30
tree.insert 20
tree.insert 40
tree.insert 70
tree.insert 60
tree.insert 80
