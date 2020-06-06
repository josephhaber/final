# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :courses do
  primary_key :id
  String :name 
  String :description, text: true
  Integer :par
  Integer :yards
  Integer :slope 
  String :public
  String :location
  
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :course_id
  foreign_key :user_id
  Boolean :recommend
  String :name
  String :email
  String :comments, text: true
  Integer :rating
end

DB.create_table! :users do
  primary_key :id
  String :name
  String :email
  String :password
end

# Insert initial (seed) data
courses_table = DB.from(:courses)

courses_table.insert(name: "Canal Shores Golf Course", 
                    description: "Also known as Evanston/Wilmette Comunity Golf Course, Canal Shores is a short, fun par 60 course winding through Evanston with a great history.",
                    par: 60,
                    yards: 3612,
                    slope: 92,
                    public: "Public", 
                    location: "Evanston, IL")

courses_table.insert(name: "Chick Evans Golf Course", 
                    description: "Also known as Evanston/Wilmette Comunity Golf Course, Canal Shores is a short, fun par 60 course winding through Evanston with a great history.",
                    par: 70,
                    yards: 5626,
                    slope: 122,
                    public: "Public", 
                    location: "Morton Grove, IL")

courses_table.insert(name: "Evanston Golf Club", 
                    description: "A challenging Donald Ross track boasting exquisite greens, with six sets of tees to suit golfers of all levels.",
                    par: 70,
                    yards: 6793,
                    slope: 135,
                    public: "Private", 
                    location: "Skokie, IL")

courses_table.insert(name: "Indian Hill Golf Club", 
                    description: "A relatively straightforward Donald Ross course, Indian Hill is one of the older private courses in the area, requiring caddies.",
                    par: 71,
                    yards: 6600,
                    slope: 123,
                    public: "Private", 
                    location: "Winnetka, IL")

courses_table.insert(name: "Wilmette Golf Course", 
                    description: "A beautiful suburban course with narrow fairways and quick doglegs, requiring target golf of the highest order.",
                    par: 70,
                    yards: 6363,
                    slope: 128,
                    public: "Public", 
                    location: "Wilmette, IL")
