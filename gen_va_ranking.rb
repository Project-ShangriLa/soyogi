#http://www.bootstrapcdn.com/
require 'sequel'

def body()
  body_string = <<"EOS"
<h1>声優 Twitterフォロワーランキング</h1>
<table class="table table-striped">
<thead>
<tr>
<th>順位</th><th>名前</th><th>フォロワー数</th><th>詳細</th><th>アカウント名</th>
</tr>
</thead>
<tbody>
EOS

  @db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

  vatfs = @db[:voice_actor_twitter_follwer_status].reverse(:follower).select_all

  vatfs.each_with_index do |va, i|
    body_string += "<tr><th>#{i}</th><td>#{va[:name]}</td><td>#{va[:follower]}</td><td>#{va[:description]}</td><td>#{va[:screen_name]}</td></tr>"
  end

  body_string += '</tbody></table>'
  #更新日時
  #4時間毎に更新
  #TODO 上位をグラフ保存化
  #TODO シェアボタン
  #TODO Amazon-AA
  #TODO Google-GA
  #TODO Rakuten AA
  #TODO DMM AA
  body_string
end

head = <<"EOS"
<html>
<meta charset="utf-8">
<head>
<title>声優 Twitterフォロワーランキング</title>
<link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet" integrity="sha256-7s5uDGW3AHqw6xtJmNNtr+OBRJUlgkNJEo78P4b0yRw= sha512-nNo+yCHEyn0smMxSswnf/OnX6/KwJuZTlNZBjauKhTK0c+zT+q5JOCx0UFhXQ6rJR9jg6Es8gPuD2uZcYDLqSw==" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-2.2.0.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha256-KXn5puMvxCw+dAYznun+drMdG1IFl3agK0p/pqT9KAo= sha512-2e8qq0ETcfWRI4HJBzQiA3UoyFk6tbNyG+qSaIBZLyW9Xf3sWZHN/lxe9fTh1U45DpPf07yj94KsUHHWe4Yk1A==" crossorigin="anonymous"></script>
</head>
<body>
EOS

footer = <<"EOS"
</body>
</html>
EOS


puts head
puts body
puts footer