require 'pry-nav'

class Heap

  def initialize
    @heap = []
  end

  def parent(index)
    @heap[index/2-1]
  end

  def min_child_key(index)
    tryvalues = []
    tryvalues << @heap[2*index+1].first if @heap[2*index+1]
    tryvalues << @heap[2*index+2].first if @heap[2*index+2]
    tryvalues << Float::INFINITY
    tryvalues.min
  end

  def min_child_index(index)
    @heap[2*index+1].first == min_child_key(index) ? 2*index+1 : 2*index+2
  end

  def swap(index1, index2)
    temp = @heap[index1].dup
    @heap[index1] = @heap[index2].dup
    @heap[index2] = temp
  end

  def insert(key,item)
    my_item = [key,item]
    @heap<<my_item
    index = @heap.size-1
    while parent(index).first > my_item.first
      swap(index/2,index)
      index = index/2
    end
  end

  def extract_min
    min_value = @heap.shift
    unless @heap.empty?
      @heap.unshift(@heap.pop)
      index = 0
      until @heap[index].first <= min_child_key(index)
        next_index = min_child_index(index)
        swap(index,next_index)
        index = next_index
      end
    end
    min_value
  end

  def delete(item)
    binding.pry
    index = @heap.index(item)
    prev_dist = @heap.delete_at(index).first
    until @heap[index].first <= min_child_key(index)
      next_index = min_child_index(index)
      swap(index,next_index)
      index = next_index
    end
    prev_dist
  end


  def print
    puts "latest heap"
    @heap.each do |arr|
      p arr
      puts ""
    end
  end
end

class Graph

  class Node
    attr_accessor :name, :visited, :edges, :min_dist
    def initialize(name) #only need name for heaped version
      @name = name
      @visited = false
      @edges = []
      @min_dist = Float::INFINITY
    end
  end

  def initialize(filename)
    longstring = File.read(filename)
    graph_array = longstring.split("\r\n")
    @graph = Hash.new
    #binding.pry
    graph_array.each do |node|
      node_list = node.split(" ")
      new_node = node_list.shift.to_i
      @graph[new_node] = Node.new(new_node)
      node_list.each do |pair|
        @graph[new_node].edges << pair.split(",").map{|x| x.to_i}
      end
    end
    p @graph
  end

  def shortest_paths(start)
    @shortest_paths = []
    @shortest_paths[start] = 0
    #binding.pry
    current_node = @graph[start]
    current_node.visited = true
    visited_list = [start]

    until visited_list.size == @graph.size
      min_dist = Float::INFINITY
      new_node = nil
      visited_list.each do |node|
        current_node = @graph[node]
        current_node.edges.each do |next_node|
          unless @graph[next_node.first].visited 
            node_dist = @shortest_paths[node] + next_node.last
            if node_dist < min_dist
              min_dist = node_dist
              new_node = next_node.first
            end
          end
        end
      end
      current_node = @graph[new_node]
      current_node.visited = true
      visited_list << new_node
      @shortest_paths[new_node] = min_dist
    end
  @shortest_paths
  end

  def heaped_shortest_paths(start)
    @shortest_paths = []
    @shortest_paths[start] = 0
    #binding.pry
    current_node = @graph[start]
    current_node.visited = true
    visited_list = [start]
    unvisited = Heap.new
    @graph.keys.delete_if{|x| x == start}.each do |node_name|
      current_node = @graph[node_name]
      min_dist = Float::INFINITY
      current_node.edges.each do |edge|
        if edge.first == start && edge.last < min_dist
          min_dist = edge.last
        end
      end
      unvisited.insert(min_dist,current_node)
    end
    p unvisited
    until visited_list.size == @graph.size
      dist, node = unvisited.extract_min
      @graph[node.name].visited = true
      visited_list << node.name
      @shortest_paths[node.name] = dist
      node.edges.each do |edge|
        unless @graph[edge.first].visited
          prev_dist = unvisited.delete(@graph[edge.first]) #need to implement this
          new_dist = [prev_dist, dist+edge.last].min
          unvisited.insert(new_dist,edge.first)
        end
      end
    end
    @shortest_paths
  end

  def reset
    @graph.each_value {|v| v.visited=false}
  end
end


=begin  
CORRECT ANSWER
2599
2610
2947
2052
2367
2399
2029
2442
2505
3068
=end



my_graph = Graph.new("ps_5_test.txt")
paths = my_graph.heaped_shortest_paths(1)
p paths

#[7,37,59,82,99,115,133,165,188,197].each do |num|
#  puts paths[num]
#end







      



       