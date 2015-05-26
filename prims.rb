require 'pry-nav'

class Heap

  def initialize
    @heap = []
  end

  private

  def parent_key(index)
    index == 0 ? -1 : @heap[(index+1)/2-1].first
  end

  def parent_index(index)
    (index+1)/2-1
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

  def key(index)
    @heap[index].first
  end

  def swap(index1, index2)
    temp = @heap[index1]
    @heap[index1] = @heap[index2]
    @heap[index2] = temp
  end

  def bubble_up(index)
    until parent_key(index) <= key(index)
      next_index = parent_index(index)
      swap(next_index,index)
      index = next_index
    end
  end

  def bubble_down(index)
    until key(index) <= min_child_key(index)
      next_index = min_child_index(index)
      swap(index,next_index)
      index = next_index
    end
  end

  def find_index(item)
    @heap.each_with_index do |comp_item, i|
      return i if comp_item.last == item
    end
  end


  public

  def insert(key,item)
    my_item = [key,item]
    @heap<<my_item
    bubble_up(@heap.size-1)
  end

  def extract_min
    min_value = @heap.first
    if @heap.size == 1
      @heap.pop
    else
      @heap[0] = @heap.pop
      bubble_down(0)
    end
    min_value
  end

  def rekey(new_key, item)
    index = find_index(item)
    @heap[index] = [new_key, item]
    bubble_up(index) unless index == 0
  end

  def empty?
    @heap.empty?
  end
end

class Graph

  class Node
    attr_accessor :visited, :edges, :min_dist
    def initialize 
      @visited = false
      @edges = []
      @min_dist = Float::INFINITY
    end
  end

  def initialize(filename)
    longstring = File.read(filename)
    graph_array = longstring.split("\n")
    graph_array.delete_at(0)
    @graph = Hash.new
    graph_array.each do |node|
      node_list = node.split(" ")
      new_node = node_list.shift.to_i
      @graph[new_node] ||= Node.new
      @graph[new_node].edges << node_list.map{|x| x.to_i}
      @graph[new_node].edges.each do |edge|
        next_node = edge.first
        @graph[next_node] ||= Node.new
        @graph[next_node].edges << [new_node, edge.last]
      end
    end
  end

# for naive implementation O(mn)

  def find_min_crossing
    min_dist = Float::INFINITY
    new_node = nil
    @visited_list.each do |visited_node|
      current_node = @graph[visited_node]
      current_node.edges.each do |edge|
        next_node, dist = edge
        binding.pry if @graph[next_node].nil?
        unless @graph[next_node].visited
          node_dist = dist
          if node_dist < min_dist
            min_dist = node_dist
            new_node = next_node
          end
        end
      end
    end
    return [min_dist, new_node]
  end

  def naive_mst(start = 1)
    sum = 0
    p @graph[start]
    @graph[start].visited = true
    @visited_list = [start]
    until @visited_list.size == @graph.size
      min_dist, new_node = find_min_crossing
      @graph[new_node].visited = true
      @visited_list << new_node
      sum += min_dist
    end
  sum
  end

#heaped implementation - O(m log n)
  def build_heap(start)
    init_heap = Heap.new
    heapified = [start]
    @graph[start].edges.each do |edge|
      node, dist = edge
      @graph[node].min_dist = dist
      init_heap.insert(dist, node)
      heapified << node
    end
    @graph.keys.each do |node|
      init_heap.insert(Float::INFINITY, node) unless heapified.include?(node)
    end
    init_heap
  end

  def recalc_crossing_edges(node, dist)
    @graph[node].edges.each do |edge|
      next_node, next_dist = edge
      current_node = @graph[next_node]
      new_dist = dist + next_dist
      unless current_node.visited || current_node.min_dist < new_dist
        current_node.min_dist = new_dist
        @unvisited.rekey(new_dist,next_node)
      end
    end
  end

  def heaped_shortest_paths(start)
    @unvisited = build_heap(start)
    @shortest_paths = []
    @shortest_paths[start] = 0
    @graph[start].visited = true
    until @unvisited.empty? 
      dist, node = @unvisited.extract_min
      @graph[node].visited = true
      @shortest_paths[node] = dist
      recalc_crossing_edges(node, dist)
    end
    @shortest_paths
  end

  def reset
    @graph.each_value {|v| v.visited=false}
  end
end



my_graph = Graph.new("PS_II_1-3.txt")
p my_graph
methods = [:naive_mst] #, :heaped_version]
methods.each do |m|
  my_graph.reset
  meth = my_graph.method m.to_sym
  start = Time.now
  total_cost = meth.call
  time_elapsed = Time.now - start
  puts "The cost is #{total_cost}"
  puts "Time for #{m} is #{time_elapsed}"
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
