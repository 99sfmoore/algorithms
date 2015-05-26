require 'pry-nav'


class HashHash

  def initialize
    @hash = Array.new(10_000_000){[]}
  end

  def hash_function(orig)
    orig.abs/10000
  end

  def insert(item)
    key = hash_function(item)
    #puts "item #{item} and key #{key}"
    @hash[key]<<item
  end

  def lookup(item)
    key = hash_function(item)
    possibilities = @hash[key]
    possibilities.each do |poss|
      return if poss == item
    end
    nil
  end

  def possible_addends(item)
    key = hash_function(item)
    return @hash[key-1] + @hash[key] + @hash[key+1]
  end
end

my_hash = HashHash.new
longstring = File.read("ps6.txt")
num_array = longstring.split("\n")
num_array.map! {|x| x.to_i}
#num_array=[-10001,1,2,-10001]
num_array.each {|x| my_hash.insert(x)}

#p my_hash

sum_hash = Hash.new
num_array.each do |x|
  my_hash.possible_addends(x).each do |poss|
    sum = x + poss
    if sum >= -10000 && sum <= 10000
      sum_hash[x+poss] = 1 unless x == poss
    end
  end
end

p sum_hash.keys

p sum_hash.size








   