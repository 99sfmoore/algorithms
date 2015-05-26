require 'pry-nav'

class Graph

  class Edge
    attr_accessor :cost, :node1, :node2

    def initialize(node1, node2, cost)
      @node1 = node1
      @node2 = node2
      @cost = cost
    end
  end

  class Node
    attr_accessor :name, :leader, :cluster_size

    def initialize(name)
      @name = name
      @leader = @name
      @cluster_size = 1
    end
  end

  class UnionFind
    attr_reader :cluster_number

    def initialize(nodes)
      @list_hash = nodes
      @cluster_number = @list_hash.size
    end

    def insert(obj)
      unless @list_hash[obj.name]
        @list_hash[obj.name] = obj
        @cluster_number +=1
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
    @nodelist = longstring.split("\n")
    @nodelist.delete_at(0)
    @node_hash = Hash.new
    @nodelist.each do |node| 
      @node_hash[node.delete(" ")] = Node.new(node.delete(" "))
    end
    puts "Size is #{@node_hash.size}"
    @node_unionfind = UnionFind.new(@node_hash)
    @edge_list = find_edges(2)
    @edge_list = @edge_list.sort_by {|edge| edge.cost}
    puts "Done with edges - count is #{@edge_list.size}"
  end

  def find_edges(max_dist) #refactor to include max_dist
    edgelist = []
    @node_hash.each do |k,v|
      #puts "Comparing #{k} to:"
      k.size.times do |n|
        name = k.dup
        name[n] == "1" ? name[n] = "0" : name[n] = "1"
        #puts "1 diff: #{name}"
        edgelist << Edge.new(k,name,1) if @node_hash[name]
        (k.size-1).downto(n+1) do |m|
          unless n == m
            nextname = name.dup
            nextname[m] == "1" ? nextname[m] = "0" : nextname[m] = "1"
            #puts "2 diff: #{nextname}"
            edgelist << Edge.new(k,nextname,2) if @node_hash[nextname]
          end
        end
      end
    end
    edgelist
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

  def cluster_all
    # binding.pry
    @edge_list.each_with_index do |min_edge, index|
      puts "edge number #{index}"
      leader1 = @node_unionfind.find(min_edge.node1)
      leader2 = @node_unionfind.find(min_edge.node2)
      unless leader1 == leader2
        @node_unionfind.union(leader1, leader2)
      end
      puts "clusters are: #{@node_unionfind.cluster_number}"
    end 
    @node_unionfind.cluster_number
  end
end

start = Time.now
mygraph = Graph.new("ps_II_2-2.txt")
puts "The cluster number is #{mygraph.cluster_all}"
puts "#{Time.now - start}"







    