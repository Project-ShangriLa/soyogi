#http://meyou.jp/ranking/follower_voice から 声優のTwitterのアカウントと声優名を取得
#声優名,アカウント のデータを作る


require 'nokogiri'
require 'open-uri'
require 'uri'
require 'sequel'

DB = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

filelist = Dir.glob("./html_cache/follower_voice*")
#p filelist
multi_data = []
account_list = []

filelist.each do |file|

  f = File.open(file)
  doc = Nokogiri::HTML(f, nil, 'UTF-8')
  f.close

  today = Date.today
  doc.xpath('//span[@class="author-username"]').each do |node|
    link_list = node.search('a')
    link_list.each do | nc |
      account = nc.text
      account.slice!(0)
      multi_data << ['', account, 0, today, today]
      account_list << account
    end
  end

end

#p multi_data
exist_account = DB[:voice_actor_masters].select_map(:twitter_account)

p exist_account.size
p account_list.size

diff1 = account_list - exist_account
diff2 = exist_account - account_list

puts diff1

puts diff1.size
puts diff2.size