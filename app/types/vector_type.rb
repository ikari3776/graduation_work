class VectorType < ActiveRecord::Type::Value
    def cast(value)
      return value if value.is_a?(Array)
      JSON.parse(value) rescue nil
    end

    def serialize(value)
      value.to_json
    end

    def deserialize(value)
      JSON.parse(value) rescue nil
    end
end
