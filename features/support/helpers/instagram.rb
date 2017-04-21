module InstagramHelper

    def get_userinfo(eyecandy_url)
        response = get(eyecandy_url + "/", nil)
        userinfo = Nokogiri::HTML(response.body)
        info = userinfo.at('//script[contains(.,"window._sharedData")]').content.strip.gsub('window._sharedData = ','').gsub(';','')
        cookies = response.cookies
        session = {
            'X-Instagram-AJAX' => 1,
            'X-Requested-With' => 'XMLHttpRequest',
            'Referer' => eyecandy_url + "/",
            'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0) Gecko/20100101 Firefox/52.0',
            'X-CSRFToken' => cookies["csrftoken"],
            'Cookie' => "ig_pr=1; ig_vw=1440; rur=ASH; s_network=""; csrftoken=#{cookies["csrftoken"]}; mid=#{cookies["mid"]}" }
        return JSON.parse(info)["entry_data"]["ProfilePage"][0]["user"], session
    end

    def download_ig_photos(eyecandy_url, directory, photos)
        count ||= 0
        photos.uniq.each do |photo|
            photo_url = photo["display_src"].split('?ig_cache_key')[0].gsub('s640x640/sh0.08/','').gsub('s750x750/sh0.08/','')
            filepath = directory + File.basename(URI.parse(photo_url).path)
            count += 1 if download_image(directory, filepath, photo_url, eyecandy_url)
        end
        return count
    end

    def download_all_ig_photos(user_id, no_photos, user_info, session, eyecandy_url, directory, count)
        while no_photos > 0
            payload = "q=ig_user(#{user_id})+{+media.after(#{user_info["media"]["page_info"]["end_cursor"]},+500)+{++count,++nodes+{++++display_src},++page_info}+}"
            payload += "&ref=users::show"
            begin
                tries ||= 5
                user_info = JSON.parse(post('https://www.instagram.com/query/', payload, session))
            rescue JSON::ParserError
                retry unless (tries -= 1).zero?
            end
            count += download_ig_photos(eyecandy_url, directory, user_info["media"]["nodes"])
            no_photos -= 500
        end
        return count
    end

end
