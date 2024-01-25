require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'
require 'line/bot'
require 'openai'
require 'dotenv'
Dotenv.load
get '/' do
  erb :index
end


def client
        @client ||= Line::Bot::Client.new { |config|
          config.channel_secret = "a9a7928fd25356ca14b0e0aa05b6568c"
          config.channel_token = "uOSv2yphg2AkqPJOKJd6et3jVEA+YTwlKUflGvCikdDW3T81UBiOtsnkfGfmZps4uoaL2HPn4yha2CnidLe8cTHv1xLINVqDAVlBWcUqIof98V/SFHG5ShXxTxrd2/lXhypHaUfMsm2AXeZTtDCWUAdB04t89/1O/w1cDnyilFU="
        }
end
 
post '/callback' do
    p "ok"
    body = request.body.read
    p "ok"
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    p "ok"
    unless client.validate_signature(body, signature)
      p "error"
      error 400 do 'Bad Request' end
    end
    p "ok"
    events = client.parse_events_from(body)
    events.each do |event|
    p "hello"
   client2 = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          response2 = client2.chat(
            parameters: {
              model: "gpt-3.5-turbo",
              messages: [{ role: "user", content: event.message['text'] + "という単語を英語にしてください" }],
            }
          )
          p response2.dig("choices", 0, "message", "content")
          message = {
            type: 'text',
            text: response2.dig("choices", 0, "message", "content")
          }
        end
      end
    client.reply_message(event['replyToken'], message)
  end
    
end


# LINE Developers登録完了後に作成される環境変数の認証
 

