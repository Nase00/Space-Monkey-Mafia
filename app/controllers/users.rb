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

# altcode 4a4ad4e690121617b837a13e60e36736

get '/users/:email_address/email' do
  uri = URI('http://dbc-mail.herokuapp.com/api/' + params[:email_address] + '/messages?api_token=dd4cf85cd0ee9ffb448340bc66507619')
  response = Net::HTTP.get_response(uri)
  case response.code
  when '200'
    inbox = Hash.from_xml(response.body)
    parse_into_objects(inbox["messages"]).to_json
  when '404'
    "email address does not exist"
  when '429'
    "too many requests, please try again later"
  when '502'
    "planned failure"
  end
end
