require 'jwt'
require 'net/http'
require "json/add/core"
require 'byebug'
require './zoom.rb'
require './spread_sheet.rb'
require './slack.rb'

def lambda_handler(event:, context:)
  # レスポンスのBodyの中にある、join_urlを取り出してjoin_urlというローカル変数に代入しています。
  # レスポンスBodyはjsonの形をしているので、JSON.parseを使いHashの形に変換し、作成したZoomのURLを取り出します。
  # join_url = JSON.parse(res.body)['join_url']
  join_url = Zoom.reservation_meeting

  daily_person = SpreadSheet.fetch_daily_person

  slack = Slack.new(join_url, daily_person)
  slack.notify_slack
end

# puts lambda_handler
# pp fetch_daily_person(ENV['SPREAD_SHEET_URL'])