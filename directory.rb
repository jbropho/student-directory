require 'date'

def input_students
  students = []
  month = get_month
  puts "Please enter a student name"
  puts "Hit enter twice to quit"
  name = gets.chomp
  
  while !name.empty? do
    puts "Now we have #{students.count + 1} students"
    month = get_month if change_month?
    students << { name: name, cohort: month }
    name = gets.chomp
  end
  students
end

def print_header
  puts "The students of Villains Academy".center(50)
  puts "-" * 50
end

def change_month? 
  puts "Change cohort month for next student? 'Y/N' (Enter to skip)"
  gets.chomp.downcase.include?('y')
end 

def get_month
    puts "Please enter cohort month"
    month = gets.chomp
    while !Date::MONTHNAMES.include?(month.capitalize)
      puts "Please enter a valid value:"
      puts Date::MONTHNAMES
      month = gets.chomp
    end
    month.capitalize.to_sym
end 

# prints all students, accepts an optional block to filter results
def print(students, condition = -> (student) { true } )
  students.each_with_index do |student, index|
    if condition.call(student)
      puts " #{index + 1} : #{student[:name]} (#{student[:cohort]} cohort)"
      .center(50)
    end 
  end
end

def print_month(sorted_by_month)
  sorted_by_month.each do |key, value|
    count = 1 
    puts "-" * 50
    puts "Cohort: #{key}".center(50)
    puts "-" * 50 

    value.each do |student|
        puts " #{count} : #{student[:name]} ".center(50)
        count += 1
    end 
  end
end

def sort_by_month(students)
  by_month = Hash.new
  students.each do |student|
    by_month[student[:cohort]] ||= Array.new
    by_month[student[:cohort]] << student
  end 
  by_month
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
puts "-" * 50 
sorted = sort_by_month(students)
print_month(sorted)