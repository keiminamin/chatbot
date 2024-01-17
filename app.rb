require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'
require 'line/bot'
get '/' do
  erb :index
end



 
post '/callback' do
    def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = "a9a7928fd25356ca14b0e0aa05b6568c"
      config.channel_token = "uOSv2yphg2AkqPJOKJd6et3jVEA+YTwlKUflGvCikdDW3T81UBiOtsnkfGfmZps4uoaL2HPn4yha2CnidLe8cTHv1xLINVqDAVlBWcUqIof98V/SFHG5ShXxTxrd2/lXhypHaUfMsm2AXeZTtDCWUAdB04t89/1O/w1cDnyilFU="
    }
　　end
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
        end
      end
      client.reply_message(event['replyToken'], message)
    end
    head :ok
end



# LINE Developers登録完了後に作成される環境変数の認証
 

