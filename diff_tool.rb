#
# 指定された日時のステータスから現在までのフォロワー数増加を調べる
#
# bundle exe ruby diff_tool.rb -t 2016-01-31|less
#
#

require 'sequel'
require 'pp'
require 'date'
require 'optparse'

target_day = nil

force_count = nil
target_column = :follower

opt = OptionParser.new
Version = "1.0.0"


opt.on('-t target_day', 'target_day'){|v| target_day = Date.strptime(v, "%Y-%m-%d")}
opt.on('-s'){target_column = :statuses_count}
opt.on('-f'){force_count = true}

opt.parse!(ARGV)

next_day = target_day + 1

@db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

status_rows = @db[:voice_actor_twitter_follwer_status].select_hash(:voice_actor_master_id, [:name, target_column])

hist_row = @db[:voice_actor_twitter_follwer_status_histories].where("get_date >= '#{target_day}' and get_date < '#{next_day}'").all

#p hist_row

diff_map = {}
hist_row_map = {}

hist_row.each do |row|
  vid = row[:voice_actor_master_id]
  hist_row_map[vid] = {}
  next unless status_rows.has_key?(vid)

  diff_map[vid] = status_rows[vid][1] - row[target_column] unless diff_map.has_key?(vid)

end

if force_count
  status_rows.each do |row|
    vid = row[0]
    diff_map[vid] = status_rows[vid][1] unless hist_row_map.has_key?(vid)
  end
end


diff_list = diff_map.sort_by {|k, v| v }

diff_list.reverse.each do |diff|

  vid = diff[0]

  next unless status_rows.has_key?(vid)

  puts "#{status_rows[vid][0]},#{diff[1]}"
end