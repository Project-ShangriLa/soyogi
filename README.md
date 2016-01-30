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