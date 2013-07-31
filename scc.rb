class Graph
  attr_reader :graph

  class Node
    attr_accessor :visited, :has_arcs_to, :gets_arcs_from, :fval, :leader

    def initialize
      @visited = false
      @gets_arcs_from = []
      @has_arcs_to = []
    end
  end

  def initialize(filename)
    longstring = File.read(filename)
    graph_array = longstring.split("\n")
    @graph = Hash.new(nil)
    graph_array.each do |node|
      node_list = node.split(" ")
      node_list.map!{|x| x.to_i}
      start_node, end_node = node_list.first, node_list.last
      @graph[start_node] = @graph[start_node] || Node.new
      @graph[start_node].has_arcs_to << end_node
      @graph[end_node] = @graph[end_node] || Node.new
      @graph[end_node].gets_arcs_from << start_node
    end
  end

  def reverse_dfs_loop
    @num_processed = 0
    @graph.each do |node_name,node| 
      unless node.visited
        reverse_dfs(node)
      end
    end
  end

  def reverse_dfs(start_node)
    start_node.visited = true
    start_node.gets_arcs_from.each do |n|
      puts "Looking at #{n}"
      current_node = @graph[n]
      unless current_node.visited
        reverse_dfs(current_node)
      end
      puts "path ends at #{n}"
    end
    @num_processed +=1
    puts "setting fval to #{@num_processed}"
    start_node.fval = @num_processed
  end

  def dfs_loop
    current_source_vertex = nil
    @graph.each
  end

end


my_graph = Graph.new("test_graph.txt")
puts "before reverse"
my_graph.reverse_dfs_loop
puts "after reverse"
my_graph.graph.each do |k,v|
  puts "Node#{k}:   #{v.inspect}"
end
