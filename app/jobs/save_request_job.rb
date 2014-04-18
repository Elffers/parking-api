class SaveRequestJob
  @queue = :save_request
  def self.perform(request_params)
    request = Request.create!(request_params)
    # request.reset_url
    # request.save
    # return request
  end
end