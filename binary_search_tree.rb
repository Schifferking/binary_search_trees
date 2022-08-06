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
      block.yield(current) if block_given?
      tree_elements_ << current.left unless current.left.nil?
      tree_elements_ << current.right unless current.right.nil?

      unless block_given?
        tree_elements << current.left.data unless current.left.nil?
        tree_elements << current.right.data unless current.right.nil?
      end

    end

    tree_elements unless block_given?
  end

  def inorder(node = root, tree_elements = [])
    return nil if node.nil?

    inorder(node.left, tree_elements)
    tree_elements << node.data
    inorder(node.right, tree_elements)
    tree_elements
  end

  def preorder(node = root, tree_elements = [])
    return nil if node.nil?

    tree_elements << node.data
    preorder(node.left, tree_elements)
    preorder(node.right, tree_elements)
    tree_elements
  end

  def postorder(node = root, tree_elements = [])
    return nil if node.nil?

    postorder(node.left, tree_elements)
    postorder(node.right, tree_elements)
    tree_elements << node.data
    tree_elements
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
p tree.postorder
