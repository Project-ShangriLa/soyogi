#http://www.rubydoc.info/gems/twitter/Twitter/User#location-instance_method
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

MAX_USERS_PER_REQUEST = 100

https://dev.twitter.com/rest/public/rate-limiting
AAA

@tw.users(account_list).each do |user|
  puts user.name
  puts user.screen_name
  puts user.followers_count
end