# Add SSL certificate file to the path
ENV['SSL_CERT_FILE'] = "#{File.expand_path(File.dirname(__FILE__))}/cacert.pem"

Before do |scenario|
end

at_exit do
end