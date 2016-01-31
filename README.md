#Soyogi - そよぎ -

old project name: voice_actor_data_tool

## 概要

声優のデータを収集するツールです

主にTwitterデータ関連を取り扱います

## 準備

sqlフォルダを参照

```
mysql anime_admin_development < voice_actor_masters.sql
mysql anime_admin_development < voice_actor_twitter_follwer_status.sql
mysql anime_admin_development < voice_actor_twitter_follwer_status_histories.sql
mysql anime_admin_development < voice_actor_masters_dml.sql
```


```
bundle install
```

## ツイッターのデータを収集

```
bundle exec ruby sana_batch_4va.rb
```

## ランキングサイト構築

```
bundle exec ruby gen_va_ranking.rb -o /usr/local/var/www/va/va.html
```

## cron起動

```
./setup.sh
```

```
vi ./config/schedule.rb
```

もしくはコピーして編集する

```
mkdir private
cp /config/schedule.rb private/schedule_hogehoge.rb
```

cronに登録
```
whenever -f private/schedule_hogehoge.rb
```

上記で出力された設定をcrontabにコピーする

crontabを全上書きしたい場合は以下

```
whenever -w -f private/schedule.rb 
```

## メモ: サイトを構築する際のOGP設定について

- [http://qiita.com/taiyop/items/050c6749fb693dae8f82](http://qiita.com/taiyop/items/050c6749fb693dae8f82)
- [https://developers.facebook.com/tools/debug/og/object/](https://developers.facebook.com/tools/debug/og/object/)
- [https://cards-dev.twitter.com/validator](https://cards-dev.twitter.com/validator)
