require 'directory'
require 'csv'
require 'yaml'

def load_students
  @students =  YAML::load(File.read("students.yml"))
end 

describe "Print students" do
  before :each { load_students }

  it 'prints all students' do 
    expect(print_student_list).to eq(
      [{:name=>"Dr. Hannibal Lecter", :cohort=>:november},
       {:name=>"Darth Vader", :cohort=>:january},
       {:name=>"Alex DeLarge", :cohort=>:march},
       {:name=>"The Wicked Witch of the West", :cohort=>:november}])
  end 

  it 'prints by month' do 
    sorted = sort_by_month
    expect(print_by_month(sorted)).to eq(
       :january => [{:name=>"Darth Vader", :cohort=>:january}],
       :march => [{:name=>"Alex DeLarge", :cohort=>:march}],
       :november => [{:name=>"Dr. Hannibal Lecter", :cohort=>:november},
       {:name=>"The Wicked Witch of the West", :cohort=>:november}]  
    )
  end 
end 

describe 'filter_by_student' do 
  before :each { load_students }

  it 'filters by lambda' do 
    filter = -> (student) { student[:name].start_with?('A') }
    expect(filter_by_student(filter)).to eq(
      [{:name=>"Alex DeLarge", :cohort=>:march}]
      )
  end   
end