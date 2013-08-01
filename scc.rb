require 'pry-nav'

class Graph
  attr_reader :graph

  class Node
    attr_accessor :visited, :has_arcs_to, :gets_arcs_from, :fval, :leader, :name

    def initialize(name)
      @name = name
      @visited = false
      @gets_arcs_from = []
      @has_arcs_to = []
      @fval = 0
    end
  end

  def initialize(filename)
    @size = 0
    longstring = File.read(filename)
    graph_array = longstring.split("\n")
    graph_array.each do |line|
      node_list = line.split(" ")
      start, finish = node_list.first, node_list.last
      start_node = instance_variable_get("@node#{start}") || Node.new(start)
      end_node = instance_variable_get("@node#{finish}") || Node.new(finish)
      start_node.has_arcs_to << finish
      end_node.gets_arcs_from << start
      instance_variable_set("@node#{start}",start_node)
      instance_variable_set("@node#{finish}",end_node)
      @size = start.to_i
    end
    @ordered_nodes = Hash.new
  end

  def dfs_loop(first_iter = true)
    @num_processed = 0
    @source_vertex = nil
    @stack = []
    @size.downto(1) do |n|
      #puts "looking at #{n}"
      first_iter ? current_node = instance_variable_get("@node#{n}") : current_node = @ordered_nodes[n]
      
      unless current_node.visited == first_iter
        @source_vertex = current_node.name
        @stack << current_node
        #binding.pry
        dfs(current_node,first_iter)
        #puts "done with dfs"
        #binding.pry
        top_node = @stack.pop
        if first_iter
          @num_processed +=1
          #puts "setting fval to #{@num_processed}"
          top_node.fval = @num_processed
          @ordered_nodes[@num_processed] = top_node
        else
          @gcc_groups[@source_vertex] +=1
        end
        until @stack.empty? do
          #binding.pry
          next_node = @stack.last
          dfs(next_node, first_iter)
          top_node = @stack.pop
          if first_iter
            @num_processed +=1
            top_node.fval = @num_processed
            @ordered_nodes[@num_processed] = top_node
          else
            @gcc_groups[@source_vertex] +=1
          end
        end
      end
    end
  end

  def dfs(start_node, reverse=true)
    start_node.visited = reverse
    reverse ? arcs = start_node.gets_arcs_from : arcs = start_node.has_arcs_to
    index = 0
    forward_path = false
    #binding.pry
    while index < arcs.size && !forward_path
      next_node = instance_variable_get("@node#{arcs[index]}")
      #puts "going to #{arcs[index]}"
      if next_node.visited == reverse
        index +=1 
      else
        @stack << next_node
        forward_path = true
      end
    end
    dfs(next_node, reverse) if forward_path
  end

  def find_gcc
    @gcc_groups = Hash.new(0)
    dfs_loop
    p @ordered_nodes
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



