#http://www.bootstrapcdn.com/
require 'sequel'
require 'optparse'

def body()
  amazon_widget = <<EOS
  <script type="text/javascript"><!--
amazon_ad_tag = "voiceactor-akiba-22"; amazon_ad_width = "728"; amazon_ad_height = "90";//--></script>
<script type="text/javascript" src="http://ir-jp.amazon-adsystem.com/s/ads.js"></script>
EOS

  amazon_widget2= <<EOS
  <iframe src="http://rcm-fe.amazon-adsystem.com/e/cm?t=voiceactor-akiba-22&o=9&p=48&l=bn1&mode=dvd-jp&browse=562020&fc1=000000&lt1=_blank&lc1=3366FF&bg1=FFFFFF&f=ifr" marginwidth="0" marginheight="0" width="728" height="90" border="0" frameborder="0" style="border:none;" scrolling="no"></iframe>
EOS

  rakuten_widget = <<EOS
<!-- Rakuten Widget FROM HERE --><script type="text/javascript">rakuten_design="slide";rakuten_affiliateId="138ddf20.b83089f9.138ddf21.36568b5e";rakuten_items="ranking";rakuten_genreId="553575";rakuten_size="468x160";rakuten_target="_blank";rakuten_theme="gray";rakuten_border="off";rakuten_auto_mode="off";rakuten_genre_title="off";rakuten_recommend="off";</script><script type="text/javascript" src="http://xml.affiliate.rakuten.co.jp/widget/js/rakuten_widget.js"></script><!-- Rakuten Widget TO HERE -->
EOS

  table_start = <<EOS
<table class="table table-striped alt-table-responsive">
<thead>
<tr>
<th class="col-md-1">順位</th>
<th class="col-md-1">フォロワー数</th>
<th class="col-md-1">画像</th>
<th class="col-md-2">名前</th>
<th class="hidden-xs hidden-sm col-md-5">詳細</th>
<th class="hidden-xs hidden-sm col-md-2">アカウント名</th>
</tr>
</thead>
<tbody>
EOS

  table_end = '</tbody></table>'

  body_string = <<"EOS"
<h1>声優 Twitterフォロワーランキング</h1>
<div>
制作:
  <a href="#" onclick="javascript:window.open('http://akibalab.info/');">
    <img src="https://objectstore-r1nd1001.cnode.jp/v1/93a6500c0a1e4c68b976e5e46527145c/data/aisl_logo.png">
  </a>
</div>
#{amazon_widget2}
<p class="text-info lead">データ更新日時 #{Time.now.strftime("%Y-%m-%d %H時%M分%S秒")}</p>
#{table_start}
EOS

  @db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

  vatfs = @db[:voice_actor_twitter_follwer_status].reverse(:follower).select_all

  vatfs.each_with_index do |va, i|
    body_string += <<EOS
    <tr>
     <th class="col-md-1"><p class="lead">#{i + 1}</p></th>
     <td class="col-md-1"><p class="lead">#{va[:follower]}</p></td>
     <td class="col-md-1"><a href="#" onclick="javascript:window.open('https://twitter.com/#{va[:screen_name]}');"><img data-layzr="#{va[:profile_image_url].gsub(/normal/,'bigger')}"></a></td>
     <td class="col-md-2"><p class="lead">#{va[:name]}</p></td>
     <td class="col-md-5 hidden-xs hidden-sm">#{va[:description]}</td>
     <td class="col-md-2 hidden-xs hidden-sm">#{va[:screen_name]}</td>
    </tr>
EOS
    body_string += table_end + rakuten_widget + table_start if (i % 100) == 0 && (i % 200) != 0
    body_string += table_end + amazon_widget2 + table_start if (i % 200) == 0 && i != 0
  end

  body_string += table_end
  #og:title等 SEO http://qiita.com/taiyop/items/050c6749fb693dae8f82
  #TODO 上位をグラフ保存化
  #TODO ランキングコピー化
  #TODO 最新のコメントをマウスオーバー表示
  #TODO シェアボタン
  #TODO Google-GA
  #TODO DMM AA
  body_string
end

head = <<"EOS"
<html>
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no">

<meta content="声優 Twitterフォロワーランキング" name="title">
<meta content="声優 Twitterフォロワーランキングです。国内最大規模、700人以上の声優データを公開。毎日数回更新。制作：秋葉原IT戦略研究所" name="description">
<meta content='声優,フォロワー数ランキング,声優ランキング,Twitterランキング,アニメ' name='keywords'>

<meta property="og:type" content="website"/>
<meta property="og:title" content="声優 Twitterフォロワーランキング"/>
<meta property="og:description" content="声優 Twitterフォロワーランキングです。国内最大規模、700人以上の声優データを公開。毎日数回更新。制作：秋葉原IT戦略研究所" />
<meta property="og:image" content="http://data.akiba-net.com/va_og_image.png" />
<meta property="og:url" content="http://data.akiba-net.com/va.html" />
<meta property="og:site_name" content="声優 Twitterフォロワーランキング"/>

<meta name="twitter:card" content="summary" />
<meta name="twitter:site" content="@428dev" />
<meta name="twitter:title" content="声優 Twitterフォロワーランキング" />
<meta name="twitter:description" content="声優 Twitterフォロワーランキングです。国内最大規模、700人以上の声優データを公開。毎日数回更新。制作：秋葉原IT戦略研究所" />
<meta name="twitter:image" content="http://data.akiba-net.com/va_og_image.png" />

<head>
<title>声優 Twitterフォロワーランキング</title>
<link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet" integrity="sha256-7s5uDGW3AHqw6xtJmNNtr+OBRJUlgkNJEo78P4b0yRw= sha512-nNo+yCHEyn0smMxSswnf/OnX6/KwJuZTlNZBjauKhTK0c+zT+q5JOCx0UFhXQ6rJR9jg6Es8gPuD2uZcYDLqSw==" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-2.2.0.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha256-KXn5puMvxCw+dAYznun+drMdG1IFl3agK0p/pqT9KAo= sha512-2e8qq0ETcfWRI4HJBzQiA3UoyFk6tbNyG+qSaIBZLyW9Xf3sWZHN/lxe9fTh1U45DpPf07yj94KsUHHWe4Yk1A==" crossorigin="anonymous"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/layzr.js/1.4.3/layzr.min.js"></script>

  <script>
  $(document).ready(function(){
    var layzr = new Layzr({});
  });
  </script>
</head>
<body>
EOS

footer = <<"EOS"
<!-- mobile only  Mobile Popover-->
<script type="text/javascript">
  amzn_assoc_ad_type = "link_enhancement_widget";
  amzn_assoc_tracking_id = "voiceactor-akiba-22";
  amzn_assoc_placement = "";
  amzn_assoc_marketplace = "amazon";
  amzn_assoc_region = "JP";
</script>
<script src="//z-fe.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&Operation=GetScript&ID=OneJS&WS=1&MarketPlace=JP"></script>
</body>
</html>
EOS


output_filename = nil
opt = OptionParser.new
Version = '1.0.0'
opt.on('-o OUTPUT FILENAME', 'output filename') {|v| output_filename = v }
opt.parse!(ARGV)

if output_filename.nil?
  puts head
  puts body
  puts footer
else
  File.open(output_filename, 'w') do |file|
    file.puts head
    file.puts body
    file.puts footer
  end
end
