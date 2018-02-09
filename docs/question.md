# 課題を作り上げる上での質問や疑問

## 2018. 1. 30

### 1. User入力validationで正しくない入力値が入った時に、どうやってフィードバックを返した方が良いのか？

解決：最近は、XHPで行うことが多いので、レスポンスを返してもらい、フロントエンド側で表示しよう。

### 2. そもそもvalidationはどうやってやった方が効率的なのか？どの層で行うのか？controller? model? ...

解決：単純に、入力に対するvalidationなら、controllerで確認すべき、しかし、唯一な情報にする（id)ことに対するvalidationは、modelで行う。

### 3. 現在のスキーマでは、Articleを作成したUserを確認するためには、Article -> Diary -> Userにしないと行けないが、Articleのfkとしてuser_idを追加することは妥当だろうか？

解決：そもそも、ダイアリーを所有することと、記事を書くことは別なので、著者という新しいテーブル（関係）を作ることで、解決できる。

上の場合の問題は、ランキング、最新記事を見せる際に、書く記事の著者を特定するためには、クエリを二回連続で投げないと行けなかったこと。もし、100件記事がある場合、2 x 100 x 10msの時間がかかる。

```perl
# Intern::Diary::Service::User のコード
sub get_user_by_article {
  my ($class, $db, $args) = @_;

  my $article = $args->{article} // croak 'article required';
  my $diary = Intern::Diary::Service::Diary->get_diary_by_article($db, +{
    article => $article,
  });
  my $user = $class->get_user_by_diary($db, +{
    diary => $diary,
  });

  return $user;
}
```

### 4. paginationロジックはかなり重複するイメージがあるが、切り出して一般化すべきなのか？

解決：一般化すると便利だが、offset, limitを利用した単純な構成では、必要ないかも。

## 2018. 1. 22

### 1. Hatena::Newbieでは、なんで、Controllerという名前のディレクトリの代わりにengineを使っているのか？

解決

### 2. 以下のようなコードはcontextにそのまま足したのが良いのかそれとも、middle wareにすべきなのか？どうすべきかのモジュールごとの基準はあるのか？

解決: 多くない場合は、一応書く。

```perl
sub check_signin_and_redirect {
  my ($self) = @_;

  unless ($self->user) {
    $self->throw_redirect('/signin');
  }
}
```

### 3. 次のような場合、JOINした方が良いのか、それとも、そのまま三つを実行した方が良いのか？

解決:三つを実行した方が良い。（せいぜい１クェリ増える）

```perl
  # QUESTION: JOIN vs individual query
  my $user = Intern::Diary::Service::User->get_user_by_name($c->dbh, +{
    name => $user_name,
  });

  my $diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($c->dbh, +{
    user => $user,
    title => $diary_title,
  });

  my $articles = Intern::Diary::Service::Article->get_articles_by_diary($c->dbh, +{
    diary => $diary,
  });
```

### 4. URLをどうしたら綺麗にまとめられるのか？

今は：`/:username/:diarytitle`

## ~~2018. 1. 16~~

### 1. WAF(Web Application Framework)とは正確に何を指しているものなのか。Ruby On RailsやExpressやPlay的なものなのか。 参考URL: https://github.com/hatena/Hatena-Textbook/blob/master/web-application-development.md#waf%E3%81%A8web%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E5%87%A6%E7%90%86%E3%82%92%E5%88%86%E9%9B%A2%E3%81%97%E3%81%9F%E5%9B%B3

解決

### 2. Business logicという言葉が登場するが、具体的にビジネスロジックってどういうことを指しているのか？どういうロジック？ 参考URL: https://github.com/hatena/Hatena-Textbook/blob/master/web-application-development.md#web%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AEmvc　　urlの少し下のModelにあります。

解決

### 3. はてなscalaサーバーはservice, model, repository, applicationの構成になることが多いとのことだが、これは、MVCという考え方の上での実装なのか？（つまり、MVCをさらにレイヤーを分ける）それとも、Modelだけの話なのか？  参考：上と同じURLの下のModelの方に書いてあります。

解決

### 4. hash reference literalの前にはいつも+にした方が良いのか？

解決

```perl
# e.g
my $diary = Intern::Diary::Service::Diary->create($dbh, +{
  user => $user,
  title => $title,
}) // croak 'diary does not exists';
```

### 5. テストを実行するときには、Intern_diary_test dbを使いたいが、どうすればようのか？

解決

私の考えでは、testコマンドを実行すると、環境変数が変るように設定する方法が良さそうですが、テストを以下のように実行すると：

```
carton exec -- prove -lrv t
```

こういう風にしかできなくて、環境変数を別度に設定することができないのではないかと思います。
