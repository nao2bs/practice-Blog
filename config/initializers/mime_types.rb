Mime::Type.register 'application/manifest+json', :webmanifest unless Mime::Type.lookup_by_extension(:webmanifest)

Rack::Mime::MIME_TYPES['.webmanifest'] = 'application/manifest+json'
