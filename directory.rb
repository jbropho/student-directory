def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  # create an empty array
  students = []
  # get the first name
  name = gets.chomp
  # while the name is not empty, repeat this code
  while !name.empty? do
    # add the student hash to the array
    students << {name: name, cohort: :november}
    puts "Now we have #{students.count} students"
    # get another name from the user
    name = gets.chomp
  end
  # return the array of students
  students
end

def print_header
  puts "The students of Villains Academy".center(50)
  puts "-" * 50
end

def print(students, condition = -> (student) { true } )
  students.each_with_index do |student, index|
    if condition.call(student)
      puts " #{index + 1} : #{student[:name]} (#{student[:cohort]} cohort)"
      .center(50)
    end 
  end
end

def print_footer(students)
  puts "Overall, we have #{students.count} great students".center(50)
end

students = input_students
print_header

# example conditions
length = -> (student) { student[:name].size > 12 }
character = -> (student) { student[:name].start_with?('a') }
# pass condition as second argument to print
print(students)
puts "-" * 50
print_footer(students)