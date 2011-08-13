module Mongo
  class OperationFailure
    def duplicate?
      !(message =~ /duplicate key/).nil?
    end
    def duplicate_on?(field)
      message.include? field.is_a?(Symbol) ? field.to_s : field
    end
  end
end