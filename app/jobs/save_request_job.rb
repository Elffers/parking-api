class SaveRequestJob
  @queue = :save_request
  def self.perform(request_params)
    request = Request.new(request_params)
    request.get_overlay
    request.save
    # delete file unlink
  end
end