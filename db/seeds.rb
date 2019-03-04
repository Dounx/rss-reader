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
    :password_confirmation => "123456"
)

100.times do
  User.create(
      :email                 => "#{SecureRandom.urlsafe_base64}@gmail.com",
      :password              => "123456",
      :password_confirmation => "123456"
  )
end


links = %w(https://www.ithome.com/rss/
           https://rsshub.app/pediy/topic/android/digest
           https://rsshub.app/v2ex/topics/latest
           https://rsshub.app/leetcode/articles
           https://rsshub.app/bbc/chinese
           https://rsshub.app/geekpark/breakingnews
           https://rsshub.app/securit/pulses
           https://rsshub.app/donews
           https://rsshub.app/one
           https://rsshub.app/gcores/category/1
           https://rsshub.app/douban/movie/playing
           https://rsshub.app/oschina/news
           https://rsshub.app/sina/discovery/zx
           https://rsshub.app/3dm/news
           )

links.each do |link|
  Feed.create(link: link)
end

Feed.all.each do |feed|
  User.all.each do |user|
    Subscription.create(
        :user_id => user.id,
        :feed_id => feed.id
    )
  end
end

RefreshFeedsWorker.new.perform()