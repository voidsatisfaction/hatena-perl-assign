# 課題を作り上げる上での質問や疑問

## 2018. 1. 16

### 1. WAF(Web Application Framework)とは正確に何を指しているものなのか。Ruby On RailsやExpressやPlay的なものなのか。 参考URL: https://github.com/hatena/Hatena-Textbook/blob/master/web-application-development.md#waf%E3%81%A8web%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E5%87%A6%E7%90%86%E3%82%92%E5%88%86%E9%9B%A2%E3%81%97%E3%81%9F%E5%9B%B3

### 2. Business logicという言葉が登場するが、具体的にビジネスロジックってどういうことを指しているのか？どういうロジック？ 参考URL: https://github.com/hatena/Hatena-Textbook/blob/master/web-application-development.md#web%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AEmvc　　urlの少し下のModelにあります。

### 3. はてなscalaサーバーはservice, model, repository, applicationの構成になることが多いとのことだが、これは、MVCという考え方の上での実装なのか？（つまり、MVCをさらにレイヤーを分ける）それとも、Modelだけの話なのか？  参考：上と同じURLの下のModelの方に書いてあります。

### 4. hash reference literalの前にはいつも+にした方が良いのか？

```perl
# e.g
my $diary = Intern::Diary::Service::Diary->create($dbh, +{
  user => $user,
  title => $title,
}) // croak 'diary does not exists';
```

### 5. テストを実行するときには、Intern_diary_test dbを使いたいが、どうすればようのか？

私の考えでは、testコマンドを実行すると、環境変数が変るように設定する方法が良さそうですが、テストを以下のように実行すると：

```
carton exec -- prove -lrv t
```

こういう風にしかできなくて、環境変数を別度に設定することができないのではないかと思います。
