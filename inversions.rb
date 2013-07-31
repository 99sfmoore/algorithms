

def sort_and_count(array)
	return [array,0] if array.size <=1
	leftarray = array[0...array.size/2]
	rightarray = array[array.size/2..-1]
	left_result = sort_and_count(leftarray)
	right_result = sort_and_count(rightarray)
	result = []
	left = left_result.first
	left_min = left.shift
	right = right_result.first
	right_min = right.shift
	inversions = left_result.last + right_result.last
	until result.size == array.size
		#puts "merging #{left_min} and #{right_min}"
		if left_min <= right_min
			result << left_min
			#puts "adding left"
			if left.size > 0
				left_min = left.shift 
			else
				result << right_min
				result = result + right
			end
		else
			result << right_min
			#puts "adding right"
			inversions += left.size + 1 
			if right.size > 0
				right_min = right.shift 
			else
				result << left_min
				result = result + left
			end
			#puts "result is #{result} and inversions are #{inversions}"
			
			
		end
	end
	[result, inversions]
end

longstring = File.read("PS1_current.txt")
test_array = longstring.split("\r\n")
test_array.map!{|x| x.to_i}
p test_array


answer = sort_and_count(test_array)
puts "There are #{answer.last} inversions"
	  
	 

