# reservation_meeting→payload→headers→generate_jwtの順
class Zoom
  class << self
    def reservation_meeting
      path = "https://api.zoom.us/v2/users/#{ENV['USER_ID']}/meetings"

      uri = URI.parse(path)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      req = Net::HTTP::Post.new(uri.path)
      req.body = payload

      req.initialize_http_header(headers)

      res = http.request(req)
      # レスポンスのBodyの中にある、join_urlを取り出してjoin_urlというローカル変数に代入しています。
      # レスポンスBodyはjsonの形をしているので、JSON.parseを使いHashの形に変換し、作成したZoomのURLを取り出します。
      return JSON.parse(res.body)['join_url']
    end

    def payload
      {
        topic: "デイリー",
        type: "1",
        duration: "40",
        timezone: "Asia/Tokyo",
        password: "",
        agenda: "進捗報告"
      }.to_json
    end

    def headers
      {
        # リソースのメディアタイプを示します。
        "Content-Type" => "application/json",
        # サーバーでユーザーエージェントを認証するための資格情報を持ちます。
        "Authorization" => "Bearer#{generate_jwt}"
      }
    end

    def generate_jwt
      payload_for_jwt = {
        iss: ENV['API_KEY'],
        exp: Time.now.to_i + 36000
      }
      
      JWT.encode(payload_for_jwt, ENV['API_SECRET'], 'HS256')
    end
  end
end