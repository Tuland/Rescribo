# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rescribo_session',
  :secret      => '47591b534ff68b5bd8d2ee70f0ecf895a1d6701cbcd839a38b57b45d62fedd8ce886076e0bd9898df14b8d00c43730a0d0d5f931afa29412e5916ac707f96adb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
