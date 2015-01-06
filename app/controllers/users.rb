get '/' do
  redirect '/users/:email_address/email'
end

# get '/users/:email_address/email' do # Local test route
#   xml_string = File.open("public/local_xml.xml")
#   inbox = Hash.from_xml(xml_string)
#   xml_string.close
#   parse_into_objects(inbox["messages"])
#   inbox["messages"][0].keys.to_s
# end

get '/users/:email_address/email' do
  user = User.find_or_create_by(email_address: params[:email_address]) do |user|
    user.id = 93
    user.name = "Super Monkey Mafia"
    user.password = "hunter2"
  end
  get_emails(user)
end
