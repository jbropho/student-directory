require 'date'

@students = []

def input_students
  month = get_month
  puts "Please enter a student name"
  puts "Hit enter twice to quit"
  name = gets.chomp
  
  while !name.empty? do
    puts "Now we have #{@students.count + 1} students"
    month = get_month if change_month?
    @students << { name: name, cohort: month }
    name = gets.chomp
  end
end

def interactive_menu
  loop do
    print_menu
    process(gets.chomp)
  end
end

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "9. Exit" # 9 because we'll be adding more items
end

def show_students
  print_header
  print_student_list
  print_footer
end

def process(selection)
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    save_students
  when "4"
    load_students
  when "9"
    exit # this will cause the program to terminate
  else
    puts "I don't know what you meant, try again"
  end
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

# prints all students, accepts an optional lambda to filter results
def print_student_list(condition = -> (student) { true })
  @students.each_with_index do |student, index|
    if condition.call(student)
      puts " #{index + 1} : #{student[:name]} (#{student[:cohort]} cohort)"
      .center(50)
    end 
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students".center(50)
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

def sort_by_month
  by_month = Hash.new
  @students.each do |student|
    by_month[student[:cohort]] ||= Array.new
    by_month[student[:cohort]] << student
  end 
  by_month
end 

def save_students
  file = File.open("students.csv", "w")
  
  @students.each do |student|
    student_data = [student[:name], student[:cohort]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
end

def load_students
  file = File.open("students.csv", "r")
  file.readlines.each do |line|
  name, cohort = line.chomp.split(',')
    @students << {name: name, cohort: cohort.to_sym}
  end
  file.close
end

# example conditions
length = -> (student) { student[:name].size > 12 }
character = -> (student) { student[:name].start_with?('a') }
# pass condition as second argument to print
# print(students)

# sorted = sort_by_month(students)
# print_month(sorted)
interactive_menu