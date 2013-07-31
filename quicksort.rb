$comparisons = 0

def quicksort(array,pivot_choice)
	$comparisons += array.size-1
	partition(pivot_choice,array, 0, array.size-1)
	array
end



def choose_pivot(pivot_choice,array,left,right)
	case pivot_choice

	when 1 #choose first element
		pivot = array[left]

	when 2 #choose last element
		pivot = array[right]
		array[right] = array[left]
		array[left] = pivot

	when 3 #choose median of 3
		array_of_3 = [array[left], array[right], array[(right-left)/2 + left]]
		if array_of_3.uniq.size < 3
			median = array_of_3.min
		else
			max = array_of_3.max
			min = array_of_3.min
			median = array_of_3.select {|x| x != max && x != min}.first
		end

		if median == array[left]
			pivot = array[left]
		elsif median == array[right]
			pivot = array[right]
			array[right] = array[left]
			array[left] = pivot
		elsif median == array[(right-left)/2 +left]
			pivot = array[(right-left)/2 + left]
			array[(right-left)/2 + left] = array[left]
			array[left] = pivot
		end
	end
	pivot
end


def partition(pivot_choice,array,left,right)
	if left == right
		return
	end
	pivot = choose_pivot(pivot_choice,array,left,right)
	#puts "pivot is #{pivot}"
	i = left+1
	(i..right).each do |j|
		#puts "comparing #{array[j]} to pivot"
		#$comparisons +=1
		if array[j] < pivot
			if i != j
				#puts "swapping #{array[j]} and #{array[i]}"
				array[j] = array[j] + array[i]
				array[i] = array[j] - array[i]
				array[j] = array[j] - array[i]
			end
			i +=1
		end
	end
	array[left] = array[i-1]
	array[i-1] = pivot
	#puts "now array is #{array} and i is #{i}"
	#puts "first call is from #{left} to #{i-2}"
	#puts "second call is from #{i} to #{right}"
	$comparisons += [[left,i-2].max - left,0].max
	partition(pivot_choice,array,left,[left,i-2].max)
	#puts "now, actually doing second call from #{i} to #{right}"
	$comparisons += [[i,right].max - i,0].max
	partition(pivot_choice,array,i,[i,right].max)
	puts "comparisons = #{$comparisons}"
	array
end

my_array = [20, 30, 40, 21, 11, 9, 56, 82, 32, 101, 2, 4, 67]
my_array2 = [50, 60, 40, 30, 70, 20, 80, 10]

longstring = File.read("PS2_current.txt")
test_array = longstring.split("\r\n")
test_array.map!{|x| x.to_i}
#p test_array

puts ("Choose pivot: (1)First, (2)Last, (3)Median of Three")
choice = gets.chomp.to_i
#p my_array

quicksort(test_array, choice)