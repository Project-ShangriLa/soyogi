require 'json'
require 'twitter'
require 'pp'
#ref https://github.com/sferik/twitter/blob/master/examples/Configuration.md
#ref http://qiita.com/innocent_zero/items/8c5f4c95881dd6b416f8
#ref http://rdoc.info/gems/twitter/frames
File.open './conf/conf.json' do |file|
   conf = JSON.load(file.read)
   twitter_conf = conf["Twitter"]
   
  @tw = Twitter::REST::Client.new(
    :consumer_key => twitter_conf["consumer_key"],
    :consumer_secret => twitter_conf["consumer_secret"],
    :oauth_token => twitter_conf["access_token"],
    :oauth_token_secret => twitter_conf["access_token_secret"]
  )
end
