module OpenapiContracts::Parser::Transformers
  class Pointer < Base
    def call(object)
      return unless object['$ref'].present?

      object['$ref'] = transform_pointer(object['$ref'])
    end

    private

    def transform_pointer(target)
      if %r{^#/(?<pointer>.*)} =~ target
        # A JSON Pointer
        generate_absolute_pointer(pointer)
      elsif %r{^(?<relpath>[^#]+)(?:#/(?<pointer>.*))?} =~ target
        ptr = @parser.filenesting[@cwd.join(relpath)]
        tgt = ptr.to_json_pointer
        tgt += "/#{pointer}" if pointer
        tgt
      else
        target
      end
    end

    # A JSON pointer to the currently parsed file as seen from the root openapi file
    def generate_absolute_pointer(json_pointer)
      if @pointer.empty?
        "#/#{json_pointer}"
      else
        "#{@pointer.to_json_pointer}/#{json_pointer}"
      end
    end
  end
end
