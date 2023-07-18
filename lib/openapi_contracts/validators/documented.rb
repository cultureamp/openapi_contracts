module OpenapiContracts::Validators
  class Documented < Base
    self.final = true

    private

    def validate
      return if spec

      status_desc = http_status_desc(response.status)
      @errors << "Undocumented request/response for #{response_desc.inspect} with #{status_desc}"
    end

    def response_desc
      "#{request.request_method} #{request.path}"
    end
  end
end
