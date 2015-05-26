require 'pry-nav'

class Graph

  class Node
    attr_accessor :visited, :has_arcs_to, :gets_arcs_from, :leader

    def initialize
      @visited = false
      @gets_arcs_from = []
      @has_arcs_to = []
      @leader = nil
    end
  end

  def initialize(filename)
    @size = 0
    @max = 0
    @unordered_nodes = Hash.new
    @ordered_nodes = Hash.new
    longstring = File.read(filename)
    graph_array = longstring.split("\n")
    graph_array.delete_at(0)
    graph_array.each do |line|
      node_list = line.split(" ")
      x, y = node_list.map{|n| n.to_i}
      node_x = @unordered_nodes[x] || Node.new
      node_not_x = @unordered_nodes[-x] || Node.new
      node_y = @unordered_nodes[y] || Node.new
      node_not_y = @unordered_nodes[-y] || Node.new
      node_not_x.has_arcs_to << y
      node_y.gets_arcs_from << -x
      node_not_y.has_arcs_to << x
      node_x.gets_arcs_from << -y
      @unordered_nodes[x] = node_x
      @unordered_nodes[-x] = node_not_x
      @unordered_nodes[y] = node_y
      @unordered_nodes[-y] = node_not_y
      @max = [@max,x,y,-x,-y].max
    end
    # @unordered_nodes.each do |key,value|
    #   puts "Node #{key}"
    #   p value
    # end
    # continue = gets.chomp
  end

  def dfs_loop(first_iter = true)
    num_processed = 0
    @stack = []
    @max.downto(-@max) do |n|
      # puts "looking at #{n} in #{first_iter}"
      first_iter ? current_node = @unordered_nodes[n] : current_node = @ordered_nodes[n]
      unless !current_node || current_node.visited == first_iter 
        @stack << current_node
        until @stack.empty? do
          dfs(first_iter, n)
          top_node = @stack.pop
          if first_iter
            num_processed +=1
            @ordered_nodes[num_processed] = top_node
          else
            @gcc_groups[n] +=1
          end
        end 
      end
    end
    # p @ordered_nodes
    # continue = gets.chomp
  end

  def dfs(reverse=false,leader)
    start_node = @stack.last
    start_node.visited = reverse
    unless reverse
      # puts "setting leader to #{leader}"
      start_node.leader = leader
    end
    reverse ? arcs = start_node.gets_arcs_from : arcs = start_node.has_arcs_to
    arcs.each do |end_node|
      next_node = @unordered_nodes[end_node]
      # p next_node
      unless next_node.visited == reverse
        @stack << next_node
        dfs(reverse,leader)
        break
      end
    end
  end

  def satisfiable?
    @gcc_groups = Hash.new(0)
    dfs_loop
    dfs_loop(false)
    # puts "These are the unordered nodes:"
    # p @unordered_nodes
    @unordered_nodes.each do |name,node|
      # p node
      if !node.leader.nil? && node.leader == @unordered_nodes[-name].leader
        return false
      end
    end
    true
  end
end

for x in 1..6 do
  my_graph = Graph.new("PS_II_6_#{x}.txt")
  puts "number #{x} is #{my_graph.satisfiable?}"
end



