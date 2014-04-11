class SaveRequestJob
  @queue = :save_request
  def self.perform(request_params)
    Request.create!(request_params)
  end
end