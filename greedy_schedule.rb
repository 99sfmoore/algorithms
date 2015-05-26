class Job
  attr_accessor :weight, :length

  def initialize(array)
    @weight = array.first.to_f
    @length = array.last.to_f
  end

  def wrong_function
    @weight - @length
  end

  def right_function
    @weight/@length
  end
end

def create_list(filename)
  longstring = File.read(filename)
  list_array = longstring.split("\n")
  list_array.delete_at(0)
  list_array.map! do |job|
      Job.new(job.split(" "))
  end
  list_array
end

def best_schedule(joblist, correct=true)
  if correct
    joblist.sort! {|x,y| y.right_function <=> x.right_function}
  else
    joblist.sort! do |x,y| 
      comp = y.wrong_function <=> x.wrong_function
      comp == 0 ? y.weight <=> x.weight : comp
    end
  end
  time = 0
  total_sum = 0
  joblist.each do |j|
    time += j.length
    total_sum += time * j.weight
  end
  total_sum
end


joblist = create_list("PS_II_1-1.txt") 
puts best_schedule(joblist,false) 
puts best_schedule(joblist)