class Graph

  class Node
    attr_accessor :visited, :has_arcs_to, :gets_arcs_from

    def initialize
      @visited = false
      @gets_arcs_from = []
      @has_arcs_to = []
    end
  end

  def initialize(filename)
    @size = 0
    @unordered_nodes = Hash.new
    @ordered_nodes = Hash.new
    longstring = File.read(filename)
    graph_array = longstring.split("\n")
    graph_array.each do |line|
      node_list = line.split(" ")
      start, finish = node_list.map{|x| x.to_i}
      start_node = @unordered_nodes[start] || Node.new
      end_node = @unordered_nodes[finish] || Node.new
      start_node.has_arcs_to << finish
      end_node.gets_arcs_from << start
      @unordered_nodes[start] = start_node
      @unordered_nodes[finish] = end_node
    end
  end

  def dfs_loop(first_iter = true)
    num_processed = 0
    @stack = []
    @unordered_nodes.size.downto(1) do |n|
      first_iter ? current_node = @unordered_nodes[n] : current_node = @ordered_nodes[n]
      unless current_node.visited == first_iter
        @stack << current_node
        dfs(current_node,first_iter)
        top_node = @stack.pop
        if first_iter
          num_processed +=1
          @ordered_nodes[num_processed] = top_node
        else
          @gcc_groups[n] +=1
        end
        until @stack.empty? do
          next_node = @stack.last
          dfs(next_node, first_iter)
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
  end

  def dfs(start_node, reverse=true)
    start_node.visited = reverse
    reverse ? arcs = start_node.gets_arcs_from : arcs = start_node.has_arcs_to
    arcs.each do |end_node|
      next_node = @unordered_nodes[end_node]
      unless next_node.visited == reverse
        @stack << next_node
        dfs(next_node, reverse)
        break
      end
    end
  end

  def find_gcc
    @gcc_groups = Hash.new(0)
    dfs_loop
    dfs_loop(false)
    top_5 = Array.new(5){0}
    @gcc_groups.each do |key, value|
      top_5.sort!
      top_5[0] = [value,top_5[0]].max
    end
    p top_5.sort.reverse
  end
end

my_graph = Graph.new("ps4_current.txt")
my_graph.find_gcc



