module Request_
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end	
  end

  module HeaderHelpers
  	def accept_header(version = 1)
  	  request.headers["Accept"] = "application/vnd.spring_ghana.v#{version}"	
  	end

  	def api_response_format(format = Mime::JSON)
  	  request.headers["Content-Type"] = format.to_json
  	  request.headers["Accept"] = "#{request.headers["Accept"]}, #{format}"	
  	end

  	def include_default_headers
  		accept_header
  		api_response_format
  	end
  end
end