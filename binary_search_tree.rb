class Node
  include Comparable
  attr_accessor :data, :left_child, :right_child

  def <=>(ohter)
    data <=> ohter.data
  end

  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil
  end
end
