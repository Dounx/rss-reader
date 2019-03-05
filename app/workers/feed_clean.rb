def clean
  Feed.all.each do |feed|
    if feed.subscriptions.count == 0
      puts "Clean a useless feed #{feed.link}"
      feed.destroy
    end
  end
end