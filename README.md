■ サービス概要  
Unsplashの画像検索機能を使ったゲームです。ランダムに出された画像がUnsplashの画像検索で一番最初に出てくるような検索ワードを考えていき、検索ワードの何番目に出てくるかで点数がついていきます。

■ このサービスへの思い・作りたい理由  
GeoGessrというGoogleマップ上のランダムな地点に落とされ、場所を推測するゲームを遊んだことがあり、Googleマップを本来の使い方ではない別の角度から使って遊ぶという発想に感動し、今回のように本来の目的ではない斬新な使い方をしたゲームを作りたいと思いました。
その中でもなぜ画像検索機能を使ったかというと、普段よく使用する機能の一つであり、検索ワードという「文字」と、検索結果である「画像」という二つが融合する画像検索機能に面白さを感じ、その機能をゲームに発展させたいと思ったためです。

■ ユーザー層について  
ユーザー層は画像検索が使える人全員。
ルールが簡単なのでちょっとした暇つぶしに使うこともできます。また、ゲームの攻略法を研究する上級者の方々も対象とし、初心者からガチ勢まで楽しめるゲームにしています。

■ サービスの利用イメージ  
この画像をヒットさせるにはどのような検索ワードがよいか考え、言語化することで頭の体操になったり、観察力が身につくと思います。

■ ユーザーの獲得について  
初心者層に対しては、ユーザー登録をしなくても手軽に遊べるようにします。
上級者層に対してはユーザー登録によって記録を残し、ユーザーの成績で順位を出すようにします。

■ サービスの差別化ポイント・推しポイント  
インターネット上の画像には基本著作権があるので自由に使用することができないため、非常に苦労しました。そこで、Unsplashという著作権フリーの画像のみを提供しているサイトを使ったゲームにすることで、今回のゲームを実現することができましたので、そこが押しポイントです。

■ 機能候補  
MVPリリース  
・ユーザー登録機能  
・画像検索ゲーム  
・順位  

本リリース  
・成績のSNS共有機能  
・英語、その他外国語対応  
・オンライン対戦機能  

■ 機能の実装方針予定  
事前にUnsplash APIを使ってランダムな画像を大量に取得する※1  
↓  
取得した画像の中からランダムに1枚表示  
↓  
ユーザーにその画像に合う検索ワードを入力させる  
↓  
Unsplash APIで実際にそのワードで検索  
↓  
ランダムな画像がユーザーの検索ワードによって何番目に出たか(または出ないか)でスコアを決定※2  

※1  
Unsplash APIのリクエスト制限は50回/1時間 なので、想定している10万枚を集めるには3日ほどかかる。
(1回のリクエストで30枚なので1時間に1500枚。100000÷1500÷24=2.777…)
アプリのDBに10万枚保存する(画像のリンクすなわち文字列のみなので容量の心配は無し)
もしアプリ実装時に画像の読み込みが遅いと感じた場合はCloudinaryなどの無料サーバーを経由する。

※2  
DBに保存された画像URLからIDを抽出し、検索結果の中からfind_indexメソッドを使って該当画像が何番目に表示されるかを特定する。
Unsplash APIは1ページ30件ずつ、最大5000件まで参照可能。どこまで追跡するかは、API制限も考慮し、実装しながら考えていく。

Figma: https://www.figma.com/design/MjKIqnr2Ew5b7Wxq3Ij4gh/%E5%8D%92%E6%A5%AD%E5%88%B6%E4%BD%9C?node-id=0-1&t=FgV82hne3m5tOgkA-1

ER図: https://gyazo.com/b8b6ac4c092f3f4922cb6d08ca33e4c4
