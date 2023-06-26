class DeleteExpiredEventNip40
  include Sidekiq::Worker
  sidekiq_options queue: "nostr"

  def perform(sha256)
    EventDigest.where(sha256: sha256).destroy_all
  end
end