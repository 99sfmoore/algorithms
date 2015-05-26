require 'pry-nav'

def readfile(filename)
  longstring = File.read(filename)
  lines = longstring.split("\n")
  @knapsack_size = lines.delete_at(0).split(" ").first.to_i
  @items = [nil]
  lines.each do |l|
    @items << l.split(" ").map{|x| x.to_i}
  end
end

def knapsack
  @possibilities = Array.new(@items.size){Array.new(@knapsack_size+1) {0}}
  # binding.pry
  for item in 1...@items.size
    for curr_size in 0..@knapsack_size
      current_item_value, current_item_size = @items[item]
      # "looking at item #{item} with value #{current_item_value} and size #{current_item_size}"
      exclude_solution = @possibilities[item-1][curr_size]
      prior_size = curr_size - current_item_size
      if prior_size >=0
        include_solution = @possibilities[item-1][prior_size]+current_item_value
        # puts "item #{item} fits and include solution is #{include_solution}"
      else
        include_solution = 0
      end
      # puts "exclude_solution is #{exclude_solution}"
      value = [exclude_solution, include_solution].max
      @possibilities[item][curr_size] = value
      # puts "value is #{value}"
    end
  end
  p @possibilities
  return @possibilities.last.last
end

def big_knapsack
  @curr_possibilities = Array.new(@knapsack_size+1) {0}
  # binding.pry
  for item in 1...@items.size
    @prior_possibilities = @curr_possibilities.dup
    current_item_value, current_item_size = @items[item]
    puts "looking at item #{item} with value #{current_item_value} and size #{current_item_size}"
    for curr_size in 0..@knapsack_size
      exclude_solution = @prior_possibilities[curr_size]
      prior_size = curr_size - current_item_size
      if prior_size >=0
        include_solution = @prior_possibilities[prior_size]+current_item_value
        # puts "item #{item} fits and include solution is #{include_solution}"
      else
        include_solution = 0
      end
      # puts "exclude_solution is #{exclude_solution}"
      value = [exclude_solution, include_solution].max
      @curr_possibilities[curr_size] = value
      # puts "value is #{value}"
    end
  end
  p @curr_possibilities
  return @curr_possibilities.last
end


readfile("ps_II_3_1.txt")
puts "The answer to quest 1 is:"
p knapsack
readfile("ps_II_3_2.txt")
puts "The answer to quest 2 is:"
p big_knapsack


