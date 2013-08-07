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
    until @heap[index].first <= min_child_key(index)
      next_index = min_child_index(index)
      swap(index,next_index)
      index = next_index
    end
  end

  public

  def insert(key,item)
    my_item = [key,item]
    @heap<<my_item
    bubble_up(@heap.size-1)
  end

  def extract_min
    min_value = @heap.shift
    unless @heap.empty?
      @heap.unshift(@heap.pop)
      bubble_down(0)
    end
    min_value
  end

  def delete(item)
    index = nil
    @heap.each_with_index do |comp_item, i|
      if comp_item.last == item
        index = i
        break
      end
    end 
    prev_dist = @heap.delete_at(index).first
    bubble_down(index) unless index == @heap.size
    return prev_dist
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
      @min_dist = Float::INFINITY #do I need this???
    end
  end

  def initialize(filename)
    longstring = File.read(filename)
    graph_array = longstring.split("\r\n")
    @graph = Hash.new
    graph_array.each do |node|
      node_list = node.split(" ")
      new_node = node_list.shift.to_i
      @graph[new_node] = Node.new
      node_list.each do |pair|
        @graph[new_node].edges << pair.split(",").map{|x| x.to_i}
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
        unless @graph[next_node].visited
          node_dist = @shortest_paths[visited_node] + dist
          if node_dist < min_dist
            min_dist = node_dist
            new_node = next_node
          end
        end
      end
    end
    return [min_dist, new_node]
  end

  def shortest_paths(start)
    @shortest_paths = []
    @shortest_paths[start] = 0
    @graph[start].visited = true
    @visited_list = [start]
    until @visited_list.size == @graph.size
      min_dist, new_node = find_min_crossing
      @graph[new_node].visited = true
      @visited_list << new_node
      @shortest_paths[new_node] = min_dist
    end
  @shortest_paths
  end

#heaped implementation - O(m log n)
  def build_heap(start)
    init_heap = Heap.new
    heapified = [start]
    @graph[start].edges.each do |edge|
      node, dist = edge
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
      unless @graph[next_node].visited
        prev_dist = @unvisited.delete(next_node)
        new_dist = [prev_dist, dist+next_dist].min
        @unvisited.insert(new_dist,next_node)
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


my_graph = Graph.new("ps_5.txt")
methods = [:shortest_paths, :heaped_shortest_paths]
methods.each do |m|
  my_graph.reset
  meth = my_graph.method m.to_sym
  start = Time.now
  paths = meth.call(1)
  [7,37,59,82,99,115,133,165,188,197].each do |num|
   puts paths[num]
  end
  time_elapsed = Time.now - start
  puts "Time for #{m} is #{time_elapsed}"
end







      



       