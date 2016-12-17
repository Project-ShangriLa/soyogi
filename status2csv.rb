#
# ステータステーブルをCSV形式で出力
#
# bundle exe ruby status2csv.rb > /tmp/va_status.csv
#
#

require 'sequel'

@db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

status_rows = @db[:voice_actor_twitter_follwer_status].reverse(:follower).select_hash(:voice_actor_master_id, [:name, :follower])

status_rows.each do |k, v|
  puts "#{v[0]},#{v[1]}"
end