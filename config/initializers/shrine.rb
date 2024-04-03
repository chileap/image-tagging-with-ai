require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"

if Rails.env.production?
  s3_options = {
    bucket: ENV.fetch("S3_BUCKET_NAME"),
    region: ENV.fetch("S3_REGION"),
    access_key_id: ENV.fetch("S3_ACCESS_KEY_ID"),
    secret_access_key: ENV.fetch("S3_SECRET_ACCESS_KEY"),
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options), # temporary
    store: Shrine::Storage::S3.new(**s3_options),                  # permanent
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store")
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :determine_mime_type # always set mime type
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :validation_helpers
Shrine.plugin :derivatives
Shrine.plugin :presign_endpoint, presign_options: -> (request) {
  filename = request.params["filename"]
  type = request.params["type"]
  {
    content_disposition: ContentDisposition.inline(filename),
    content_type: type
  }
}
Shrine.plugin :rack_file
Shrine.plugin :upload_endpoint
