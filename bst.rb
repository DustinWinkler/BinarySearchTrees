class Node
  attr_accessor :left, :right, :value
  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return if array.empty?
    array = array.sort.uniq
    midpoint = array.length / 2
    node = Node.new(array[midpoint])

    return node if array.length == 1

    node.left = build_tree(array[0..midpoint - 1])
    node.right = build_tree(array[midpoint + 1..-1])

    node
  end

  # Return node with given value
  def find(value, search = 0)
    node = @root
    until node.value == value || (node.left.nil? && node.right.nil?)
      node.value > value ? node = node.left : node = node.right
      if node.nil?
        puts "This value does not exist"
        return
      end
    end
    node.value == value ? node : (search.zero? ? nil : node)
  end

  def insert(value)
    value > level_order.max ? node = find(level_order.max) : node = find(value, 1)
    puts "This value already exists" if node.value == value
    node.value > value ? node.left = Node.new(value) : node.right = Node.new(value)
  end

  def delete(value)
    node = find(value)
    children = 0
    children += 1 unless node.left.nil?
    children += 1 unless node.right.nil?
    parent = find_parent(value) unless node.value == root.value
    if node.value != value
      puts 'That value does not exist'
    elsif children.zero? # for leaf node
      parent.value > value ? parent.left = nil : parent.right = nil
    elsif children == 1
      if parent.left.value == value
        node.left.nil? ? parent.left = node.right : parent.left = node.left
      else
        node.left.nil? ? parent.right = node.right : parent.right = node.left
      end
    elsif children == 2
      cur_node = node.right
      p cur_node
      until cur_node.left.nil?
        cur_node = cur_node.left
      end
      val = cur_node.value
      delete(cur_node.value)
      node.value = val
    end 
  end

  def find_parent(value)
    node = root
    until node.left.value == (value || nil) || node.right.value == (value || nil)
      node.value > value ? node = node.left : node = node.right
    end
    node
  end

  def level_order(node = root)
    # Return array from breadth-first search
    result = []
    queue = []
    queue << node
    until queue.empty?
      node = queue.first
      result << node.value
      queue << node.left unless node.left.nil?
      queue << node.right unless node.right.nil?
      queue.shift
    end
    result
  end

  def inorder(node = root)
    result = []
    result << inorder(node.left) unless node.left.nil?
    result << node.value
    result << inorder(node.right) unless node.right.nil?
    result.flatten
  end

  def preorder(node = root)
    result = []
    result << node.value
    result << preorder(node.left) unless node.left.nil?
    result << preorder(node.right) unless node.right.nil?
    result.flatten
  end

  def postorder(node = root)
    result = []
    result << postorder(node.left) unless node.left.nil?
    result << postorder(node.right) unless node.right.nil?
    result << node.value
    result.flatten
  end

  def depth(value)
    return "This value does not exist" unless find(value)
    depth = 0
    node = root
    until node.value == value
      node.value > value ? node = node.left : node = node.right
      depth += 1
    end
    depth
  end

  def height(node = root)
    return 0 if node.nil? || node.value.nil?
    return 1 + [height(node.left), height(node.right)].max
  end

  def balanced?
    heights = [height(root.left), height(root.right)]
    max = heights.max
    min = heights.min
    return max - min > 1 ? false : true
  end

  def rebalance
    @root = build_tree(level_order)
  end
  # Courtesy of discord user
  def pretty_print(node = root, prefix="", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? "│ " : " "}", false) if node.right
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.value.to_s}"
    pretty_print(node.left, "#{prefix}#{is_left ? " " : "│ "}", true) if node.left
  end
end

tree = Tree.new(Array.new(15) { rand(1..100) })
p tree.balanced?
p tree.level_order
p tree.preorder
p tree.inorder
p tree.postorder
tree.pretty_print
tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.insert(1004)
tree.insert(3)
p tree.balanced?
tree.rebalance
p tree.balanced?
p tree.level_order
p tree.preorder
p tree.inorder
p tree.postorder
tree.pretty_print