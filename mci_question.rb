require 'sinatra'
require 'restforce'
require 'pry'
require 'logger'
require 'date'

before do
  @client = Restforce.new(username: 'jake@mentorcreation.com',
                           password: 'Byfaith77!',
                           security_token: 'r3wlzCxUDP0g6du05SWVnFij',
                           client_id: '3MVG9zlTNB8o8BA2RSMOnRMRK011Lmptu4P6oC2DvSUMvkLdN9zR.HPG6hGyWRaFH1oC_GcBNZJAPIK6rC.g.',
                           client_secret: '1781052040781951263',
                           api_version: '37.0')
end
enable :sessions

get '/mci/:account' do
  acc_id = params[:account]
  session[:acc_id] = acc_id
  send_file 'views/questionnaire.html'
end

post '/process_form' do
  data = Hash.new
  acc_id = session[:acc_id]
  data[:acc_id] = acc_id
  data[:describe] = params[:describe]
  data[:audience] = params[:audience]
  data[:goals] = params[:goals]
  data[:username] = params[:username]
  data[:pw] = params[:pw]
  data[:comments] = params[:comments]
  data[:filled_out] = true

  begin
    update = @client.update("Account", Id: "#{data[:acc_id]}",
                                     Brand_Description__c: "#{data[:describe]}",
                                     Audience__c: "#{data[:audience]}",
                                     Goals__c: "#{data[:goals]}",
                                     Instagram_Username__c: "#{data[:username]}",
                                     Instagram_Password__c: "#{data[:pw]}",
                                     Comments__c: "#{data[:comments]}",
                                     Filled_Out__c: "#{data[:filled_out]}")
    if update
      #update sfdc success
      puts "JAKE -- ACC_ID: #{acc_id} success, DATA: #{data}"
      send_file 'views/thank_you.html'
    else
      #update sfdc failure
      puts "JAKE -- ACC_ID:#{acc_id} failed in the ELSE, DATA: #{data}, update: #{update}"
      send_file 'views/update_error.html'
    end
  rescue Exception => each
    #issue updating, log exception
    puts "JAKE -- ACC_ID:#{acc_id} failed in the RESCUE, DATA: #{data}"
  end
end
