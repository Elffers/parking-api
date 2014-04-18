CarrierWave::Backgrounder.configure do |c|
  c.backend :resque, queue: :carrierwave
end
