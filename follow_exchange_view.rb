require 'sequel'
require 'optparse'
require './lib/character_image.rb'
#bundle exe ruby follow_exchange_view.rb -f etc/Aqours.txt -m html  > /tmp/test.html
#bundle exe ruby follow_exchange_view.rb -f etc/muse.txt -m html > /tmp/muse.html

opt = OptionParser.new
Version = '1.0.0'

@mode = 'csv'
@output_filename = nil

@account_list_file
opt.on('-f ACCOUNT LIST FILE', 'account list file') {|v| @account_list_file = v }
opt.on('-m MODE', 'mode') {|v| @mode = v }
opt.on('-o OUTPUT FILENAME', 'output filename') {|v| @output_filename = v }
opt.parse!(ARGV)

account_list = []
@db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

open(@account_list_file) {|file|
  while l = file.gets
    account_list << l.chomp
  end
}

def stdout_for_csv(account_list)
  print "-,"
  account_list.each do |account|
    print "#{account},"
  end
  puts ""

  account_list.each do |account|

    friends = @db[:voice_actor_follow_exchange_status].where(:twitter_account => account).select_map(:friend_account)

    print "#{account},"
    account_list.each do |_account|
      next print "-," if _account == account
      if friends.include?(_account)
        print "◯,"
      else
        print "☓,"
      end
    end

    puts ""
  end
end

def body(account_list)
  name_hash = @db[:voice_actor_masters].where(:twitter_account => account_list).select_hash(:twitter_account , :name )
  image_hash = @db[:voice_actor_twitter_follwer_status].where(:screen_name => account_list).select_hash(:screen_name , :profile_image_url )

  account_th = ""

  account_list.each do |account|
    account_th += "<th class=\"col-xs-2 col-md-1\">#{name_hash[account]} <img src=\"#{image_hash[account]}\"> <img src=\"#{@chara_image[account]}\" width=\"48\"></p></th>"
  end

  table_start = <<EOS
<table class="table table-striped alt-table-responsive">
<thead>
<tr>
<th class="col-xs-2 col-md-1">Twitteアカウント/フォローワー対象</th>
 #{account_th}
</tr>
</thead>
<tbody>
EOS

  table_end = '</tbody></table>'

  body_string = <<"EOS"
<h1>声優 Twitter 声優相互フォロワー表</h1>
<p class="text-info lead">データ更新日時 #{Time.now.strftime("%Y-%m-%d %H時%M分%S秒")}</p>
#{table_start}
EOS
  friend_th = ""

  account_list.each do |account|

    friends = @db[:voice_actor_follow_exchange_status].where(:twitter_account => account).select_map(:friend_account)

    friend_th+='<tr>'
    #TODO写真
    friend_th+= "<th class=\"col-xs-2 col-md-1\"><p class=\"lead\">#{name_hash[account]} <img src=\"#{image_hash[account]}\"> <img src=\"#{@chara_image[account]}\" width=\"48\"></p></th>"
    account_list.each do |_account|

      if _account == account
        friend_th+= '<th class="col-xs-2 col-md-1"><p class="lead">-</p></th>'
        next
      end

      if friends.include?(_account)
        friend_th+= '<th class="col-xs-2 col-md-1"><p class="lead">◯</p></th>'
        next
      else
        friend_th+= '<th class="col-xs-2 col-md-1"><p class="lead">☓</p></th>'
        next
      end

    end
    friend_th+='</tr>'
  end

  body_string += <<EOS
      <tr>
       #{friend_th}
      </tr>
EOS

  body_string += table_end
  body_string
end


def output_html(account_list)
  head = <<"EOS"
<html>
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no">

<meta content="声優 Twitterフォロワーランキング" name="title">
<meta content="声優 Twitterフォロワーランキングです。国内最大規模、700人以上の声優データを公開。毎日数回更新。制作：秋葉原IT戦略研究所" name="description">
<meta content='声優,フォロワー数ランキング,声優ランキング,Twitterランキング,アニメ' name='keywords'>

<meta property="og:type" content="article"/>
<meta property="og:title" content="声優 Twitterフォロワーランキング ラブライブver"/>
<meta property="og:description" content="声優 Twitterフォロワーランキングです。国内最大規模、700人以上の声優データを公開。毎日数回更新。制作：秋葉原IT戦略研究所" />
<meta property="og:image" content="http://data.akiba-net.com/va_og_image.png" />
<meta property="og:url" content="http://data.akiba-net.com/va.html" />
<meta property="og:site_name" content="声優 Twitterフォロワーランキング"/>

<meta name="twitter:card" content="summary" />
<meta name="twitter:site" content="@428dev" />
<meta name="twitter:title" content="声優 Twitterフォロワーランキング ラブライブ版" />
<meta name="twitter:description" content="声優 Twitterフォロワーランキングです。国内最大規模、700人以上の声優データを公開。毎日数回更新。制作：秋葉原IT戦略研究所" />
<meta name="twitter:image" content="http://data.akiba-net.com/va_og_image.png" />

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

  if @output_filename.nil?
    puts head
    puts body(account_list)
    puts footer
  else
    File.open(@output_filename, 'w') do |file|
      file.puts head
      file.puts body(account_list)
      file.puts footer
    end
  end
end


if @mode == 'csv'

  stdout_for_csv(account_list)

elsif @mode == 'html'
  output_html(account_list)
end



