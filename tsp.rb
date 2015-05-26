class Graph

  def initialize(filename)
    input_array = File.read(filename).split("\n")
    @num_of_nodes = input_array.delete_at(0).to_i
    @nodes = input_array.map do |line|
              line.split.map{|x| x.to_f}
            end
  end

  def distance(point1, point2)
    x1, y1 = point1
    x2, y2 = point2
    Math.sqrt((x1-x2)**2 + (y1-y2)**2)
  end
  # path is list of edges
  def insert(node,path)
    if path[:edge_list].empty?
      path[:edge_list] << [node,node]
    else
      deleted_edge = path[:edge_list].min_by{|edge| distance(edge.first,node) + distance(node,edge.last) - distance(edge.first,edge.last)}
      deleted_distance = distance(deleted_edge.first,deleted_edge.last)
      path[:edge_list].delete(deleted_edge)
      path[:edge_list] << [deleted_edge.first,node]
      path[:edge_list] << [node, deleted_edge.last]
      path[:length] += (distance(deleted_edge.first,node) + distance(node,deleted_edge.last) - distance(deleted_edge.first,deleted_edge.last))
    end
  end



  def randomized_traveling_salesman
    @nodes.shuffle!
    path = {edge_list: [], length: 0}
    @nodes.each do |node|
      insert(node,path)
    end
    puts "The min path is #{path[:length]}"
    path[:length]
  end

end

graph = Graph.new("ps_II_5.txt")
results = []
50.times do
  results << graph.randomized_traveling_salesman
end
puts "Final min #{results.min}"

# Order the nodes randomly and rename them as 1,2,...,n according to their ordering position
# 2. Initialize tour T by involving only node 1 (i.e., self-loop on node 1)
# 3. For each node i (i=2,3,...,n)
#        probe-and-insert node i to T by making smallest increment of T.length
# 4. Return T.length

# Randomization in step 1 is useful for evaluating sequence of nodes in different order. The heuristic is to expand the tour by inserting one node per time. The greedy criteria is that for each insertion of nodei, we first look for the edge (u,v)∈T such that the insertion will incur smallest increment to the length of the tour. We define this subroutine as follows:

# Probe-and-Insert-by-Smallest-Increment(node i, tour T)
#     probe every edge of T and find out (u,v) s.t. min{distance(u,i) + distance(i,v) - distance(u,v)}
#     delete edge (u,v) in T
#     add edges (u,i) and (i,v) to T





