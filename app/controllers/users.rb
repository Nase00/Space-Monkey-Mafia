get '/' do
  redirect '/index.html'
end

# get '/users/:email_address/email' do # Local test route
#   xml_string = File.open("public/local_xml.xml")
#   inbox = Hash.from_xml(xml_string)
#   xml_string.close
#   parse_into_objects(inbox["messages"])
#   inbox["messages"][0].keys.to_s
# end

get '/users/:email_address/email' do
  user = User.find_by(email_address: params[:email_address])

  user.get_emails
  #   end
  #   counter += 1
  #   break if counter > 30
  # end
end
