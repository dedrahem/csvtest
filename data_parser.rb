# reads from the template file
require "csv"
require "erb"
require 'pp'
require 'faker'
fakerdata = []

#  reads the existing HTML and assigns it to value_html
html = File.read("report.html")
#  reads the existing HTML and assigns it to value_html
puts ""
puts "REMINDER - COMMAND K - will clear all prior console clutter"
puts ""


CSV.open("faker.csv", "wb") do |csv|
  csv << ['user_name', 'email','password_digest','created_at','updated_at']
  i=0
  until i == 4
    fakerimport = [Faker::Name.name, Faker::Internet.email,Faker::Internet.password(8, 10),Faker::Time.between(DateTime.now - 7, DateTime.now - 5),Faker::Time.between(DateTime.now - 4, DateTime.now)]
    createtime = fakerimport[3].strftime("%A, %d %b %Y %l:%M %p")
    fakerimport[3] = createtime
    updatetime = fakerimport[4].strftime("%A, %d %b %Y %l:%M %p")
    fakerimport[4] = updatetime
    csv << fakerimport
    i=i+1
  end # end of i-times iteration for user creation
end # end of the csv do loop -
# at this point there is a CSV file in memory and written as a file !!!!
# the CSV looks good - has headers and rows.


CSV.foreach("faker.csv", headers: true) do |row|
  fakerdata << row.to_hash
end # end do, CREATE an array of faker data called fakerdata
puts ""
# resultant changes in the erb are integrated into the html
# _ from above and a new html file is update created
new_html = ERB.new(html).result(binding)

File.open("report.html","wb") do |file|
  file.write(new_html)
  file.close
end
# the new viewable HTML is opened for write access, written to
# _ using the new html and the html file is closed for browser access
puts " SUCCESS - PROGRAM LAST LINE - Go View the .CSV file"
