require 'pry-nav'

class Graph

  class Edge
    attr_accessor :cost, :node1, :node2

    def initialize(edge_string)
      edge_array = edge_string.split(" ").map{ |x| x.to_i}
      @node1, @node2, @cost = edge_array
    end
  end

  class Node
    attr_accessor :name, :leader, :cluster_size

    def initialize(name)
      @name = name
      @leader = @name
    end
  end

  class UnionFind
    attr_reader :cluster_number

    def initialize
      @list_hash = Hash.new
      @cluster_number = 0
    end

    def insert(obj)
      unless @list_hash[obj.name]
        @list_hash[obj.name] = obj
        @cluster_number +=1
        obj.cluster_size = 1
      end
    end

    def find(objname)
      @list_hash[objname].leader
    end

    def union(cluster1, cluster2)
      if @list_hash[cluster1].cluster_size < @list_hash[cluster2].cluster_size
        temp = cluster1
        cluster1 = cluster2
        cluster2 = temp
      end # the larger cluster is cluster1
      @list_hash.each_value do |node|
        if node.leader == cluster2
          node.leader = cluster1
          node.cluster_size = 0
          @list_hash[cluster1].cluster_size +=1
        end
      end
      @cluster_number -=1
    end

    def display
      display_hash = @list_hash.values.group_by{|x| x.leader}
      display_hash.each do |k,v|
        puts "cluster leader #{k}:"
        v.each {|e| puts "#{e.name}"}
      end
      puts "Number of clusters is #{@cluster_number}"
    end

  end


  def initialize(filename)
    longstring = File.read(filename)
    graph_array = longstring.split("\n")
    graph_array.delete_at(0)
    @edge_list = Array.new
    @node_unionfind = UnionFind.new
    graph_array.each do |e|
      new_edge = Edge.new(e)
      @edge_list << new_edge
      @node_unionfind.insert(Node.new(new_edge.node1))
      @node_unionfind.insert(Node.new(new_edge.node2))
    end
    @edge_list = @edge_list.sort_by {|edge| edge.cost}
  end

  def max_cluster(k)
    # binding.pry
    edge_index = 0
    until @node_unionfind.cluster_number == k do
      min_edge = @edge_list[edge_index]
      leader1 = @node_unionfind.find(min_edge.node1)
      leader2 = @node_unionfind.find(min_edge.node2)
      unless leader1 == leader2
        @node_unionfind.union(leader1, leader2)
      end
      edge_index += 1
    end 
    begin #REFACTOR!
      min_edge = @edge_list[edge_index]
      leader1 = @node_unionfind.find(min_edge.node1)
      leader2 = @node_unionfind.find(min_edge.node2)
      edge_index +=1
    end until leader1 != leader2
    min_edge.cost
  end
end

mygraph = Graph.new("ps_II_2.txt")
n = mygraph.max_cluster(4)
puts "Cluster dist is #{n}"






    