module Request
	module HeadersHelpers
		def api_header(version = 1)
			request.headers['Accept'] = "application/vnd.sale-sale-an.v#{version}"
		end

		def api_response_format(format = Mime::JSON)
			request.headers['Accept'] = "application/vnd.sale-sale-an.v1, #{format}"
			request.headers['Content-Type'] = Mime::JSON.to_s
		end

		def include_default_headers
			api_header
			api_response_format
		end

		def api_authorization_header(token)
			request.headers['Authorization'] = token
		end
	end

	module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end
end