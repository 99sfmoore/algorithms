def merge_sort(array)
	return array if array.size <=1
	leftarray = array[0...array.size/2]
	p leftarray
	rightarray = array[array.size/2..-1]
	p rightarray
	left = merge_sort(leftarray)
	right = merge_sort(rightarray)
	result = []
	left_min = left.shift
	right_min = right.shift
	until result.size == array.size
		puts "merging #{left_min} and #{right_min}"
		if left_min <= right_min
			result << left_min
			puts "adding left"
			if left.size > 0
				left_min = left.shift 
			else
				result << right_min
				result = result + right
			end
		else
			result << right_min
			puts "adding right"
			if right.size > 0
				right_min = right.shift 
			else
				result << left_min
				result = result + left
			end
			puts "result is #{result}"
			
			
		end
	end
	result
end

test_array = "qwertyuiopasdfghjklzxcvbnm".split("")
p test_array

puts merge_sort(test_array)
	  
	 

