#http://vatwitter.damebito.com/ から 声優のTwitterのアカウントと声優名を取得
#声優名,アカウント,性別 のデータを作る


require 'nokogiri'
require 'open-uri'
require 'uri'
require 'sequel'

DB = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')


target = ARGV[0]

doc = nil

#puts target

if /^http.*/ =~ target
  html  = Net::HTTP.get_response(URI.parse(target)).body
  doc = Nokogiri::HTML.parse(html, nil, 'UTF-8')
else
  f = File.open(target)
  doc = Nokogiri::HTML(f, nil, 'UTF-8')
  f.close
end


index = 1;
gender = 1;
multi_data = []
today = Date.today
doc.xpath('//table[@class="list"]').each do |node|
    link_list = node.search('a')
    link_list.each do | nc |
      account = nc.values[0].gsub(/https:\/\/twitter.com\//, '')
      account = account.gsub(/http:\/\/twitter.com\//, '')
      account = account.gsub(/#!\//, '')
      gender = 0 if index >= 288
      multi_data << [nc.text, account, gender, today, today]
      index+=1
    end
end

#puts vc_list.size # 420
#DB[:twitter_statuses].
DB[:voice_actor_masters].import([:name, :twitter_account, :gender, :created_at, :updated_at], multi_data)