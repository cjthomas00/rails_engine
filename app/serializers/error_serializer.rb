class ErrorSerializer
  include JSONAPI::Serializer
  def initialize(error, status = 404 )
    @error = error
    @status = status
  end

  def not_found
    { 
      errors: [
        {
          status: @status.to_s,
          title: @error.message 
        }
       ]
      }
  end

  def invalid_entry
    { 
      errors: [
        {
          status: @status.to_s,
          title: @error 
        }
       ]
      }
  end
end