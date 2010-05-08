require 'rubygems'
require 'time'
require 'base64'

# This non-blocking script is used to report goals to your press9 test.
# It require a server with 'curl' installed and the 'json' gem.
begin
    require 'json'
rescue LoadError
    $stderr.puts 'press9 requires json gem\ninstall with "gem install json"'
end

class Abingo::Press9

    @@API_BASE =  "http://press9formoreoptions.com/"

    def self.score_conversion(test_token, treatment_token, group_token, visitor_id, properties={})
        params = {"group_token" => @group_token, "test_token" => test_token, "treatment_token" => treatment_token, "visitor_id" => visitor_id, "p9_type" => "goal", "collected" => Time.now.to_f * 1000, "properties" => properties}
        json =  JSON.generate(params)
        data = [json].pack('m').chop
        data.gsub!(/\n+/, "") 
        request = "#{@@API_BASE}track/#{data}"
        `curl -s '#{request}' &`
    end

    def self.score_participation(test_token, treatment_id, visitor_id="")
        date = Time.now.to_f * 1000
        params = "treat?testtoken=#{test_token}&dec=#{treatment_id}&date=#{date}&visitor_id=#{visitor_id}"
        request = "#{@@API_BASE}track/#{params}"
        `curl -s '#{request}' &`
    end
end
