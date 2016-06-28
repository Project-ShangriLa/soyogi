require 'sequel'
require 'optparse'


opt = OptionParser.new
Version = '1.0.0'

@account_list_file
opt.on('-f ACCOUNT LIST FILE', 'account list file') {|v| @account_list_file = v }
opt.parse!(ARGV)

account_list = []

open(@account_list_file) {|file|
  while l = file.gets
    account_list << l.chomp
  end
}

print "-,"
account_list.each do |account|
  print "#{account},"
end
puts ""

@db = Sequel.mysql2('anime_admin_development', :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

account_list.each do |account|

  friends = @db[:voice_actor_follow_exchange_status].where(:twitter_account => account).select_map(:friend_account)

  print "#{account},"
  account_list.each do |_account|
    next print "-," if _account == account
    if friends.include?(_account)
      print "◯,"
    else
      print "☓,"
    end
  end

  puts ""
end