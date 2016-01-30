require 'sequel'
require 'pp'
require "./twitter.rb"

@today = DateTime.now

@db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

@status_rows = []
@history_rows = []
#アカウントをキーとしたハッシュを作る 必要な値はID
@account_key_hash = {}

@twitter_result_account = []

@index = 1;

def connect_twitter(account_list)
  @tw.users(account_list).each do |user|
    @status_rows << [
        @index,
        user.followers_count,
        @today,
        @today,
        user.name,
        user.description.to_s,
        user.favorites_count,
        user.friends_count,
        user.listed_count,
        user.screen_name,
        user.profile_image_url.to_s,
        user.statuses_count
    ]

    @twitter_result_account << user.screen_name
    @index+=1
  end
end

def save_db()
  @db[:voice_actor_twitter_follwer_status2].truncate
  @db[:voice_actor_twitter_follwer_status2].import([
                                                      :voice_actor_master_id,
                                                      :follower,
                                                      :created_at,
                                                      :updated_at,
                                                      :name,
                                                      :description,
                                                      :favourites_count,
                                                      :friends_count,
                                                      :listed_count,
                                                      :screen_name,
                                                      :profile_image_url,
                                                      :statuses_count
                                                  ], @status_rows)
end

ONE_REQUEST_LIMIT_NUM = 100
ONE_REQUEST_SLEEP_SEC = 30

account_list = []

open(ARGV[0]) {|file|
  while l = file.gets
    account_list << l.chomp
  end
}

puts account_list.size
p account_list


account_list.each_slice(ONE_REQUEST_LIMIT_NUM).to_a.each do |account_slist|
  puts account_slist.size
  #配列を区切ってTwitterにリクエスト
  connect_twitter(account_slist)

  puts 'sleep'
  sleep ONE_REQUEST_SLEEP_SEC
end

save_db()

p account_list - @twitter_result_account

#処理を終了する ループはcrontabでやる
#６時間に１度ぐらいで
