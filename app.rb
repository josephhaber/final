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
after { puts; }                                                                        #
#######################################################################################

courses_table = DB.from(:courses)
reviews_table = DB.from(:reviews)
users_table = DB.from(:users)

before do
    @current_user = users_table.where(:id => session[:user_id]).to_a[0]
    puts @current_user.inspect
end

get "/" do
  @courses = courses_table.all
  puts @courses.inspect
  view "courses"
end

get "/courses/:id" do
    @users_table = users_table
    @course = courses_table.where(:id => params["id"]).to_a[0]
    @reviews = reviews_table.where(:course_id => params["id"]).to_a
    @average = reviews_table.where(:course_id => params["id"]).avg(:rating).to_f
    @count = reviews_table.where(:course_id => params["id"]).count
    results = Geocoder.search(@course[:address])
    @lat_long = results.first.coordinates.join(",")
    puts @course.inspect
    puts @reviews.inspect
    puts results.inspect
    puts @count.inspect
    view "course"
end

get "/courses/:id/reviews/new" do
    @course = courses_table.where(:id => params["id"]).to_a[0]
    puts @course.inspect
    view "new_review"
end

post "/courses/:id/reviews/create" do
    reviews_table.insert(:course_id => params["id"],
                       :recommend => params["recommend"],
                       :user_id => @current_user[:id],
                       :comments => params["comments"],
                       :rating => params["rating"])
        @course = courses_table.where(:id => params["id"]).to_a[0]
    view "create_review"
end

get "/users/new" do
    view "new_user"
end

post "/users/create" do
    users_table.insert(:name => params["name"],
                       :email => params["email"],
                       :password => BCrypt::Password.create(params["password"]))
    view "create_user"
end

get "/logins/new" do
    view "new_login"
end

post "/logins/create" do
    puts params
    email_entered = params["email"]
    password_entered = params["password"]
    user = users_table.where(:email => email_entered).to_a[0]
    if user
        puts user.inspect
        if BCrypt::Password.new(user[:password]) == password_entered
            session[:user_id] = user[:id]
            view "create_login"
        else
            view "create_login_failed"
        end
    else 
        view "create_login_failed"
    end
end

# Logout
get "/logout" do
    session[:user_id] = nil
    view "logout"
end
