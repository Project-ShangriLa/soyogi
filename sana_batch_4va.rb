#Sana Batch For Voice Actor
#http://www.rubydoc.info/gems/twitter/Twitter/User#location-instance_method
require 'sequel'
require "./twitter.rb"

<<AAA
#connections ⇒ Array readonly
#description ⇒ String readonly
#favourites_count ⇒ Integer (also: #favorites_count) readonly
#followers_count ⇒ Integer readonly
#friends_count ⇒ Integer readonly
#lang ⇒ String readonly
#listed_count ⇒ Integer readonly
#location ⇒ String readonly
#name ⇒ String readonly
#profile_background_color ⇒ String readonly
#profile_link_color ⇒ String readonly
#profile_sidebar_border_color ⇒ String readonly
#profile_sidebar_fill_color ⇒ String readonly
#profile_text_color ⇒ String readonly
#statuses_count ⇒ Integer (also: #tweets_count) readonly
#time_zone ⇒ String readonly
#utc_offset ⇒ Integer readonly

#screen_name

MAX_USERS_PER_REQUEST = 100

https://dev.twitter.com/rest/public/rate-limiting
AAA

<<BBB
@tw.users(account_list).each do |user|
  puts user.name
  puts user.screen_name
  puts user.followers_count
end
BBB

@today = Date.today

@db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

@status_rows = []
@history_rows = []
#アカウントをキーとしたハッシュを作る 必要な値はID
@account_key_hash = {}


def connect_twitter(account_list)
  @tw.users(account_list).each do |user|
    @status_rows << [
        @account_key_hash[user.name],
        user.followers_count,
        @today,
        @today,
        user.name,
        user.description,
        user.favorites_count,
        user.friends_count,
        user.listed_count,
        user.screen_name
    ]

    @history_rows << [
        @account_key_hash[user.name],
        user.followers_count,
        @today,
        @today,
        @today,
        user.name,
        user.description,
        user.favorites_count,
        user.friends_count,
        user.listed_count,
        user.screen_name
    ]
  end
end

<<T
  `voice_actor_master_id` int(11) NOT NULL,
  `follower` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `favourites_count` int(11) DEFAULT NULL,
  `friends_count` int(11) DEFAULT NULL,
  `listed_count` int(11) DEFAULT NULL,
  `screen_name` varchar(255) DEFAULT NULL,
T

def save_db()
  #結果をstatusに格納(truncate -> insert)
  @db[:voice_actor_twitter_follwer_status].truncate
  @db[:voice_actor_twitter_follwer_status].import([
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
                                                  ], @status_rows)

  #結果をhistoryに格納(insertのみ)
  @db[:voice_actor_twitter_follwer_status_histories].import([
                                                                :voice_actor_master_id,
                                                                :follower,
                                                                :get_date,
                                                                :created_at,
                                                                :updated_at,
                                                                :name,
                                                                :description,
                                                                :favourites_count,
                                                                :friends_count,
                                                                :listed_count,
                                                                :screen_name,
                                                            ], @history_rows)
end

ONE_REQUEST_LIMIT_NUM = 100
ONE_REQUEST_SLEEP_SEC = 60



rows = @db[:voice_actor_masters].all

account_list = []

rows.each do |row|
  @account_key_hash[row[:twitter_account]] = row[:id]
  account_list << row[:twitter_account]
end

account_list.each_slice(ONE_REQUEST_LIMIT_NUM).to_a.each do |account_slist|
  puts account_slist.size
  #配列を区切ってTwitterにリクエスト
  connect_twitter(account_slist)
  puts 'sleep'
  sleep ONE_REQUEST_SLEEP_SEC
end

save_db()

#処理を終了する ループはcrontabでやる
#６時間に１度ぐらいで
