#http://seesaawiki.jp/w/wikkkiiii/d/%C0%BC%CD%A5から 声優のTwitterのアカウントと声優名を取得
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
  doc = Nokogiri::HTML.parse(html, nil, 'EUC-JP')
else
  f = File.open(target)
  doc = Nokogiri::HTML(f, nil, 'EUC-JP')
  f.close
end


index = 1;
gender = 1;
multi_data = []
today = Date.today
doc.xpath('//div[@class="wiki-section-1"]').each do |node|
  gender = 0 if index >= 322
  link_list = node.search('li')
  link_list.each do | li |
   name =   li.search('b').text
   account = li.search('a').text.gsub(/https:\/\/twitter.com\//, '')
   account = account.gsub(/http:\/\/twitter.com\//, '')
   account = account.gsub(/#!\//, '')

   result_name = DB[:voice_actor_masters].where(:name => name).first
   result_account = DB[:voice_actor_masters].where(:twitter_account => account).first

   if result_name == nil && result_account == nil
     p [name, account, gender, today, today]
    multi_data << [name, account, gender, today, today]
   end
   index+=1
  end
end

puts multi_data.size



DB[:voice_actor_masters].import([:name, :twitter_account, :gender, :created_at, :updated_at], multi_data)