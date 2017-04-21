module DownloadsHelper

    def download_image(directory, filepath, image_url, eyecandy_url)
        begin
            unless Pathname.new(filepath).file?
                begin
                    FileUtils.mkdir_p directory unless File.directory?(directory)
                    File.open(filepath, 'wb') do |image_file| image_file.write open(image_url).read end
                    return true
                rescue
                end
            end
        rescue OpenURI::HTTPError
            puts "System had trouble downloading images from #{eyecandy_url}"
        end
    end

    def get(url, headers)
        begin
            tries ||= 10
            response = RestClient.get(url, headers)
            return response
        rescue SocketError || Errno::EHOSTUNREACH
            (tries -= 1).zero? ? fail("Internet connection failed. Re-run tests again later.") : retry
        rescue RestClient::ExceptionWithResponse => err
            if (tries -= 1).zero? 
                fail "Internet connection failed. Re-run tests again later." if err.response.nil?
                return err.response
            else
                retry
            end
        end
    end

    def post(url, payload, headers)
        begin
            response = RestClient.post(url, payload, headers)
            return response
        rescue RestClient::ExceptionWithResponse => err
            fail "Internet connection failed. Re-run tests again later." if err.response.nil?
            return err.response
        end
    end

end
