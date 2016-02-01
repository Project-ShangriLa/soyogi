# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "/var/log/cron.log"
every 4.hour do
  command "source .bashrc;cd $VOICE_ACTOR_TOOL;bundle exec ruby sana_batch_4va.rb;bundle exec ruby gen_va_ranking.rb -o /usr/share/nginx/html/va.html"
end

every :day, :at => '02:10am' do
  command "source .bashrc;cd $VOICE_ACTOR_TOOL;bundle exec ruby gen_va_ranking_lovelive.rb -o /usr/share/nginx/html/va_lovelive.html"
end

every :day, :at => '02:11am' do
  command "source .bashrc;cd $VOICE_ACTOR_TOOL;bundle exec ruby gen_va_ranking_lovelive.rb -o /usr/share/nginx/html/va_muse.html -m"
end

every :day, :at => '02:12am' do
  command "source .bashrc;cd $VOICE_ACTOR_TOOL;bundle exec ruby gen_va_ranking_lovelive.rb -o /usr/share/nginx/html/va_aq.html -a"
end
