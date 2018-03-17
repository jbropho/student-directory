require 'directory'
require 'csv'
require 'yaml'

describe "Print students" do
  before :all do
      students = [
        { name: "Dr. Hannibal Lecter", cohort: :november},
        { name: "Darth Vader", cohort: :january},
        { name: "Alex DeLarge",cohort:  :march},
        { name: "The Wicked Witch of the West",cohort:  :november},
      ]
      File.open "students.yml", "w" do |f|
          f.write YAML::dump students
      end
  end

  before :each do
    @students =  YAML::load(File.read("students.yml"))
  end

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