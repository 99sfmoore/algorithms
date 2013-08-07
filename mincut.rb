

class Graph

  def initialize(filename)
    longstring = File.read(filename)
    graph_array = longstring.split("\r\n")
    @graph = Hash.new
    graph_array.each do |node|
      node_list = node.split("\t")
      node_list.map!{|x| x.to_i}
      @graph[node_list[0]] = node_list[1...node_list.size]
    end
  end

  def mincut
    until @graph.size == 2
      rand_node1 = @graph.keys[rand(@graph.keys.size)]
      rand_node2 = @graph[rand_node1][rand(@graph[rand_node1].size)]
      remove_edge(rand_node1,rand_node2)
    end
    min_cut = @graph.values.first.size
  end

  def remove_edge(node1,node2)
    @graph[node1].concat(@graph[node2])
    @graph[node1].delete_if{|x| x == node1 || x == node2}
    @graph.each do |node, edge_list|
      edge_list.map! {|edge| edge == node2 ? node1 : edge }
    end
    @graph.delete_if {|k,v| k == node2}
  end
end

minimum_cut = Float::INFINITY
100.times do
  g = Graph.new("PS3_current.txt")
  minimum_cut = [g.mincut, minimum_cut].min
end
puts "the minimum cut is #{minimum_cut}"



