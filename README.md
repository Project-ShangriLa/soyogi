#声優のデータを収集するツール

## 準備

sqlフォルダを参照

```
bundle install
```

## ツイッターのデータを収集

```
bundle exec ruby sana_batch_4va.rb
```

## ランキングサイト構築

```
ruby gen_va_ranking.rb > /usr/local/var/www/va/va.html
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