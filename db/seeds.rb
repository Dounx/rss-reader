# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# To reset sidekiq:
Sidekiq.redis { |conn| conn.flushdb }
Sidekiq::Stats.new.reset

User.create(
    :email                 => "imdounx@gmail.com",
    :password              => "123456",
    :password_confirmation => "123456",
    :admin                 => true
)

100.times do
  User.create(
      :email                 => "#{SecureRandom.urlsafe_base64}@gmail.com",
      :password              => "123456",
      :password_confirmation => "123456"
  )
end


links = ['rsshub.app/cctv/world',
         'baidu.com',
         'www.baidu.com',
         'http://baidu.com',
         'https://rsshub.app/zhihu/daily',
         'https://api.rubyonrails.org/',
         'http://www.ftchinese.com/rss/feed',
         'https://doyj.com/feed/',
         'https://coolshell.cn/feed',
         'http://feeds.bbci.co.uk/zhongwen/simp/rss.xml',
         'http://news2.mingpao.com/rss/pns/s00001.xml',
         'https://www.v2ex.com/index.xml',
         'http://cn.rfi.fr/general/podcast/',
         'http://www.bbc.com/zhongwen/simp/index.xml',
         'http://www.voachinese.com/api/',
         'https://theinitium.com/newsfeed/',
         'http://rss.dw.de/rdf/rss-chi-all',
         'http://bowenpress.com/feed',
         'https://www.ithome.com/rss/',
         'qaq',
         'microsoft.com',
         'aaaaa',
         'apple.com',
         'google.coms',
         'https://rsshub.app/sina/discovery/zx',
         'https://rsshub.app/xiaoheihe/user/7775687',
         'https://rsshub.app/qidian/forum/1010400217',
         'http://coolshell.cn/feed',
         'http://www.ruanyifeng.com/blog/atom.xml',
         'http://www.raychase.net/feed',
         'http://blog.codingnow.com/atom.xml',
         'http://www.nginx.cn/feed',
         'http://www.importnew.com/feed',
         'http://feeds.feedburner.com/StylingAndroid',
         'http://www.trinea.cn/feed/',
         'http://beyondvincent.com/atom.xml',
         'http://blog.csdn.net/luoshengyang/rss/list',
         'http://androidniceties.tumblr.com/rss',
         'http://www.fookwood.com/feeding',
         'http://www.wklken.me/feed.xml',
         'https://blog.inovex.de/feed/',
         'http://www.laruence.com/feed/',
         'http://hukai.me/atom.xml',
         'http://blog.csdn.net/lzyzsd/rss/list',
         'http://ticktick.blog.51cto.com/rss.php?uid=823160',
         'http://macshuo.com/?feed=rss2',
         'https://sspai.com/feed',
         'http://linux.cn/rss.xml',
         'https://androidweekly.io/rss/',
         'http://kaedea.com/atom.xml',
         'https://rsshub.app/chouti/hot',
         'https://rsshub.app/itjuzi/invest',
         'https://rsshub.app/ifanr/app',
         'https://rsshub.app/99percentinvisible/transcript'
]

links.each do |link|
  Feed.fetch(link)
end

Feed.all.each do |feed|
  User.all.each do |user|
    Subscription.create(feed_id: feed.id, user_id: user.id)
  end
end

Feed.all.each do |feed|
  PublishItemsWorker.perform_async(feed.id)
end
