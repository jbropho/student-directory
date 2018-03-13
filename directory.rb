require 'date'

@students = []

def input_students
  month = get_month
  name = get_name
  
  while !name.empty? do
    puts "Now we have #{@students.count + 1} students"
    month = get_month if change_month?
    @students << { name: name, cohort: month }
    name = get_name
  end
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load students from a .csv file"
  puts "9. Exit"
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
    file = get_file_name
    save_students(file)
  when "4"
    file = get_file_name
    load_students(file)
  when "9"
    exit
  else
    puts "I don't know what you meant, try again"
  end
end

def print_header
  puts "The students of Villains Academy".center(50)
  puts "-" * 50
end

def get_name 
  puts "Student name:"
  name = STDIN.gets.chomp 
end 

def change_month? 
  puts "Change cohort month for next student? 'Y/N' (Enter to skip)"
  STDIN.gets.chomp.downcase.include?('y')
end 

def get_month
    puts "Please enter cohort month"
    month = STDIN.gets.chomp
    while !Date::MONTHNAMES.include?(month.capitalize)
      puts "Please enter a valid value:"
      puts Date::MONTHNAMES
      month = STDIN.gets.chomp
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

def print_by_month(sorted_by_month)
  sorted_by_month.each do |key, value|
    count = 1 
    flash_message "Cohort: #{key}".center(50)

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

def save_students(filename = "students.csv")
  file = File.open( filename, "w") do |f|
    @students.each do |student|
      student_data = [student[:name], student[:cohort]]
      csv_line = student_data.join(",")
      f.puts csv_line
    end
  end 
  flash_message "Successfully saved students to #{filename}"
end

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else 
    flash_message "Sorry, #{filename} doesn't exist."
    exit
  end
end

def load_students(filename = "students.csv")
  File.open(filename, "r").readlines.each do |line|
    name, cohort = line.chomp.split(',')
    @students << {name: name, cohort: cohort.to_sym}
  end
  flash_message "Successfully loaded students from #{filename}"
end

def get_file_name
  flash_message "Please enter a file name"
  file = STDIN.gets.chomp
end 

def flash_message(message)
  puts "*" * 50
  puts message
  puts "*" * 50
end 

# example conditions
length = -> (student) { student[:name].size > 12 }
character = -> (student) { student[:name].start_with?('a') }
# pass condition as second argument to print
# print(students)

# sorted = sort_by_month(students)
# print_month(sorted)
try_load_students
interactive_menu