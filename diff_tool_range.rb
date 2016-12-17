#
# 指定された日時のステータスから現在までのフォロワー数増加を調べる
#
# bundle exe ruby diff_tool_range.rb 2016-01-01 2016-01-31|less
#
#

require 'sequel'
require 'pp'
require 'date'

start_day = Date.strptime(ARGV[0], "%Y-%m-%d")
start_day_next = start_day + 1
target_day = Date.strptime(ARGV[1], "%Y-%m-%d")
next_day = target_day + 1

@db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

status_rows = @db[:voice_actor_twitter_follwer_status_histories].where("get_date >= '#{start_day}' and get_date < '#{start_day_next}'")
                  .select_hash(:voice_actor_master_id, [:name, :follower])

hist_row = @db[:voice_actor_twitter_follwer_status_histories].where("get_date >= '#{target_day}' and get_date < '#{next_day}'").all

#p hist_row

diff_map = {}
hist_row_map = {}

hist_row.each do |row|
  vid = row[:voice_actor_master_id]
  hist_row_map[vid] = {}
  next unless status_rows.has_key?(vid)

  diff_map[vid] =  row[:follower] - status_rows[vid][1]  unless diff_map.has_key?(vid)

end


diff_list = diff_map.sort_by {|k, v| v }

diff_list.reverse.each do |diff|

  vid = diff[0]

  next unless status_rows.has_key?(vid)

  puts "#{status_rows[vid][0]},#{diff[1]}"
end