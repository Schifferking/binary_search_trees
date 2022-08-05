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
p tree.find(30)
