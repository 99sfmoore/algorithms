require 'pry-nav'

class Heap

  def initialize(min)
    @heap = []
    @min = min
  end

  private

  def parent_key(index)
    @heap[(index+1)/2-1]
  end

  def parent_index(index)
    (index+1)/2-1
  end

  def child_key(index)
    tryvalues = []
    tryvalues << @heap[2*index+1] if @heap[2*index+1]
    tryvalues << @heap[2*index+2] if @heap[2*index+2]
    if @min
      tryvalues << Float::INFINITY
      return tryvalues.min
    else
      tryvalues << -Float::INFINITY
      return tryvalues.max  
    end
  end

  def child_index(index)
    @heap[2*index+1] == child_key(index) ? 2*index+1 : 2*index+2
  end

  def key(index)
    @heap[index]
  end

  def swap(index1, index2)
    temp = @heap[index1]
    @heap[index1] = @heap[index2]
    @heap[index2] = temp
  end

  def bubble_up(index)
    if @min
      until parent_key(index) <= key(index) || index == 0
        next_index = parent_index(index)
        swap(next_index,index)
        index = next_index
      end
    else
      until parent_key(index) >= key(index) || index == 0
        next_index = parent_index(index)
        swap(next_index,index)
        index = next_index
      end
    end
  end

  def bubble_down(index)
    if @min
      until key(index) <= child_key(index)
        next_index = child_index(index)
        swap(index,next_index)
        index = next_index
      end
    else
      until key(index)>= child_key(index)
        next_index = child_index(index)
        swap(index,next_index)
        index = next_index
      end
    end
  end

  def find_index(item)
    @heap.each_with_index do |comp_item, i|
      return i if comp_item.last == item
    end
  end


  public

  def insert(item)
    @heap<<item
    bubble_up(@heap.size-1)
  end

  def peek
    @heap.first || 0
  end

  def extract
    value = @heap.first
    if @heap.size == 1
      @heap.pop
    else
      @heap[0] = @heap.pop
      bubble_down(0)
    end
    value
  end

  def empty?
    @heap.empty?
  end

  def size
    @heap.size
  end
end


longstring = File.read("ps6_q2.txt")
stream = longstring.split("\n")
stream.map! {|x| x.to_i}

# p stream

#stream = [4,5,6,7,8,9,10,1,2,3]
#stream = [3,7,4,1,2,6,5]
#stream = [10,1,9,2,8,3,7,4,6,5]
#puts stream.inject(:+)



def median_maintenance(stream)
  heap_low = Heap.new(false)
  heap_high = Heap.new(true)
  even = true
  median_sum = 0
  stream.each do |x|
    even = !even
    x <= heap_low.peek ? heap_low.insert(x) : heap_high.insert(x)
    if heap_high.size > heap_low.size
      heap_low.insert(heap_high.extract)
    elsif heap_low.size > heap_high.size && even
      heap_high.insert(heap_low.extract)
    end
    p heap_low
    p heap_high
    p heap_low.peek
    
    median = heap_low.peek
    median_sum += median
  end
  puts median_sum
  puts median_sum % 10000
end

median_maintenance(stream)


