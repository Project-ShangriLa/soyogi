require 'sequel'
require 'optparse'
require "./twitter.rb"

# 相互フォローワーを割り出すためにfriendリストをテーブルに保存する

opt = OptionParser.new
Version = '1.0.0'

@account_list_file
@note = ''
opt.on('-f ACCOUNT LIST FILE', 'account list file') {|v| @account_list_file = v }
opt.on('-n Note', 'note') {|v| @note = v }
opt.parse!(ARGV)

@today = DateTime.now

# 15分15回、フレンドが200を超えるとカーソルが必要なので注意
def connect_twitter(account_list)
  status_records = []
  history_records = []

  account_list.each do |account|
    @tw.friends(account, {:count => 200}).each do |friend|
      status_records << [
          account,
          friend.screen_name,
          @note,
          @today,
          @today
      ]

      history_records << [
          account,
          friend.screen_name,
          @note,
          @today,
          @today,
          @today
      ]

    end
  end

  [status_records, history_records]
end

def save_db(stasus_records, history_records)
  @db[:voice_actor_follow_exchange_status].truncate
  @db[:voice_actor_follow_exchange_status].import([
                                                      :twitter_account,
                                                      :friend_account,
                                                      :note,
                                                      :created_at,
                                                      :updated_at
                                                  ], stasus_records)

  #結果をhistoryに格納(insertのみ)
  @db[:voice_actor_follow_exchange_hisories].import([
                                                        :twitter_account,
                                                        :friend_account,
                                                        :note,
                                                        :created_at,
                                                        :updated_at,
                                                        :get_date
                                                    ], history_records)
end


account_list = []

open(@account_list_file) {|file|
  while l = file.gets
    account_list << l.chomp
  end
}

p account_list

@db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

status_records, history_records = connect_twitter(account_list)
save_db(status_records, history_records)