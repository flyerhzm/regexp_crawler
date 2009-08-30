module Net
  class HTTP
    def HTTP.get_response_with_headers(uri, headers)
      response = start(uri.host, uri.port) do |http|
        http.get(uri.request_uri, headers)
      end
    end
  end
end
