require 'pry-nav'

class Graph

  class Node
    def initialize(name)
      @name = name
      @edges = {}
    end

    def add_edge(end_node, cost)
      @edges[end_node] = cost
    end

    def has_edge?(end_node)
      !@edges[end_node].nil?
    end

    def has_cost_to(end_node)
      @edges[end_node]
    end
  end

  def initialize(filename)
    longstring = File.read(filename)
    graph_array = longstring.split("\n")
    @num_of_nodes = graph_array.delete_at(0).split.first.to_i
    @graph = Hash.new
    graph_array.each do |line|
      start_node, end_node, cost = line.split.map{|x| x.to_i}
      @graph[start_node] ||= Node.new(start_node)
      @graph[start_node].add_edge(end_node,cost)
    end
  end

  def clone_k(orig)
    cloned_array = Array.new
    orig.each_with_index do |row, i|
      cloned_array[i] = row.dup
    end
    cloned_array
  end

  def floyd_warshall
    n = @num_of_nodes
    curr_k = Array.new(n+1) { Array.new(n+1)}
    for i in (1..n) do
      for j in (1..n) do 
        if i == j
          curr_k[i][j] = 0
        elsif @graph[i] && @graph[i].has_edge?(j) 
          curr_k[i][j] = @graph[i].has_cost_to(j)
        else
          curr_k[i][j] = Float::INFINITY
        end
      end
    end
    last_k = clone_k(curr_k)
    for k in (1..n) do
      for i in (1..n) do
        for j in (1..n) do 
          curr_k[i][j] = [last_k[i][j], last_k[i][k] + last_k[k][j]].min
        end
      end
      last_k = clone_k(curr_k)
    end
    curr_k
  end

  def find_min_path
    result = floyd_warshall
    p result
    min_path = Float::INFINITY
    n = @num_of_nodes
    for i in (1..n) do
      for j in (1..n) do
        if i == j && result[i][j] < 0
          min_path = -Float::INFINITY
          puts "found a neg cycle"
        else
          min_path = [result[i][j], min_path].min
        end
      end
    end
    min_path
  end
end

graph1 = Graph.new("ps_II_4_graph1.txt")
graph2 = Graph.new("ps_II_4_graph2.txt")
graph3 = Graph.new("ps_II_4_graph3.txt")

m1 = graph1.find_min_path
m2 = graph2.find_min_path
m3 = graph3.find_min_path

puts "Min path of 1 is #{m1}"
puts "Min path of 2 is #{m2}"
puts "Min path of 3 is #{m3}"

