# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "geocoder"                                                                    #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

courses_table = DB.from(:courses)
reviews_table = DB.from(:reviews)

get "/" do
  @courses = courses_table.all
  puts @courses.inspect
  view "courses"
end

get "/courses/:id" do
    @course = courses_table.where(:id => params["id"]).to_a[0]
    @reviews = reviews_table.where(:course_id => params["id"]).to_a
    puts @course.inspect
    puts @reviews.inspect
    view "course"
end

get "/courses/:id/reviews/new" do
    @course = courses_table.where(:id => params["id"]).to_a[0]
    puts @course.inspect
    view "new_review"
end

get "/courses/:id/reviews/create" do
    puts params.inspect
    reviews_table.insert(:course_id => params["id"],
                       :recommend => params["recommend"],
                       :name => params["name"],
                       :email => params["email"],
                       :comments => params["comments"])
    view "create_review"
end