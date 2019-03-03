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

Feed.create(
    title: "IT之家",
    link: "https://www.ithome.com/rss/",
    description: "IT之家 - 软媒旗下网站",
    language: "zh-cn",
    modified_at: DateTime.now
)

User.create(
    :email                 => "imdounx@gmail.com",
    :password              => "123456",
    :password_confirmation => "123456"
)

Subscription.create(
    :user_id => User.first.id,
    :feed_id => Feed.first.id
)

links = %w(https://www.ithome.com/rss/
           https://rsshub.app/pediy/topic/android/digest
           https://rsshub.app/v2ex/topics/latest
           https://rsshub.app/leetcode/articles
           https://rsshub.app/bbc/chinese
           https://rsshub.app/geekpark/breakingnews
           https://rsshub.app/securit/pulses
           https://rsshub.app/donews
           https://rsshub.app/one
           https://rsshub.app/gcores/category/1)

RefreshFeedsWorker.perform_async(links)




