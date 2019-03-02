# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

feeds = %w(https://www.ithome.com/rss/
         https://rsshub.app/pediy/topic/android/digest
         https://rsshub.app/v2ex/topics/latest
         https://rsshub.app/leetcode/articles
         https://rsshub.app/bbc/chinese)

FeedWorker.perform_async(feeds)