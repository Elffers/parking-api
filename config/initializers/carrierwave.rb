CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Figaro.env.aws_access_key_id,
    :aws_secret_access_key  => Figaro.env.aws_secret_access_key
  }
  config.fog_directory  = Figaro.env.s3_bucket_name
  config.fog_public     = false
  # config.cache_dir = "#{Rails.root}/tmp/uploads"
end