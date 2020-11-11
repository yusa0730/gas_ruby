class Slack
  # 「initialize」メソッドを使うことでオブジェクトを作成時に
  # 必ず実行したい処理をメソッドを呼び出すことなく実行することが出来ます。
  def initialize(join_url, daily_person)
    @join_url = join_url
    @daily_person = daily_person
  end

  def notify_slack
    uri = URI.parse(ENV['WEBHOOK_URL'])
    Net::HTTP.post_form(uri, { payload: payload })
  end

  def payload
    {
      user_name: "デイリーお知らせbot",
      icon_emoji: ":spiral_calender_pad",
      channel: "#会議担当者の通知",
      text: text
    }.to_json
  end

  def text
    <<-EOS
      <!here>会議が始まります。
      担当者:#{@daily_person}

      #{@join_url}
    EOS
  end
end