fog_credentials = YAML.load(File.read("#{Rails.root}/config/application.yml"))
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => fog_credentials['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key  => fog_credentials['AWS_SECRET_ACCESS_KEY']
  }

  if Rails.env.test?
    config.storage      = :file
    # config.root       = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end

  config.fog_directory  = fog_credentials['S3_BUCKET_NAME']
  config.fog_public     = false
  # config.cache_dir        = "#{Rails.root}/tmp/uploads" # To let CarrierWave work on Heroku


end
