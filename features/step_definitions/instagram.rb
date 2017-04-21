include InstagramHelper
include DownloadsHelper

Then(/^get photos from instagram profile$/) do
    instagram_ids = (ig_id.size < 1) ? fail("Please provide at least one Instagram ID where to download photos from.") : ig_id
    instagram_ids.each do |id|
        eyecandy_url = "https://www.instagram.com/#{id}"
        begin
            count = 0
            directory = "downloads/#{id}/"
            user_info = InstagramHelper::get_userinfo(eyecandy_url)
            if user_info[0]["media"]["nodes"].count > 0
                count = InstagramHelper::download_ig_photos(eyecandy_url, directory, user_info[0]["media"]["nodes"])
                puts "Downloaded #{count} new image(s) from #{eyecandy_url}" if count > 0 && download_all == :false

                if download_all == :true
                    user_id = user_info[0]["id"]
                    no_photos = user_info[0]["media"]["count"].to_i
                    count = InstagramHelper::download_all_ig_photos(user_id, no_photos, user_info[0], user_info[1], eyecandy_url, directory, count)
                    puts "Downloaded #{count} new image(s) from #{eyecandy_url}" if count > 0
                end
            else
                fail "It seems that #{eyecandy_url} is a private profile. Sorry."
            end
        rescue NoMethodError
            puts "No photos found on #{eyecandy_url}"
        end
    end
end
