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
  String :address
  String :link
  
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
                    description: "Also known as Evanston/Wilmette Community Golf Course, Canal Shores is a short, fun par 60 course winding through Evanston with a great history.",
                    par: 60,
                    yards: 3612,
                    slope: 92,
                    public: "Public", 
                    location: "Evanston, IL",
                    address: "1030 Central St, Evanston, IL 60201",
                    link: "https://www.canalshores.org/")

courses_table.insert(name: "Chick Evans Golf Course", 
                    description: "A scenic, well-bunkered 18-hole public course on the Chicago River, offers good risk/reward opportunities for long hitters but narrow fairways and postage-stamp sized greens. ",
                    par: 70,
                    yards: 5626,
                    slope: 122,
                    public: "Public", 
                    location: "Morton Grove, IL",
                    address: "6145 Golf Rd, Morton Grove, IL 60053",
                    link: "https://chickevans.forestpreservegolf.com/")

courses_table.insert(name: "Evanston Golf Club", 
                    description: "A challenging Donald Ross track boasting exquisite greens, with six sets of tees to suit golfers of all levels.",
                    par: 70,
                    yards: 6793,
                    slope: 135,
                    public: "Private", 
                    location: "Skokie, IL",
                    address: "4401 Dempster Street, Skokie, IL 60076",
                    link: "https://www.evanstongolfclub.org/")

courses_table.insert(name: "Indian Hill Golf Club", 
                    description: "A relatively straightforward Donald Ross course, Indian Hill is one of the older private courses in the area, requiring caddies.",
                    par: 71,
                    yards: 6600,
                    slope: 123,
                    public: "Private", 
                    location: "Winnetka, IL",
                    address: "1 North Indian Hill Rd, Winnetka, IL 60093",
                    link: "http://www.indianhillclub.org/")

courses_table.insert(name: "Wilmette Golf Course", 
                    description: "A beautiful suburban course with narrow fairways and quick doglegs, requiring target golf of the highest order.",
                    par: 70,
                    yards: 6363,
                    slope: 128,
                    public: "Public", 
                    location: "Wilmette, IL",
                    address: "3900 Fairway Dr, Wilmette, IL 60091",
                    link: "http://www.golfwilmette.com/")
