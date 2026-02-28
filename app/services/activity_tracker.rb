class ActivityTracker
  def self.track(trackable, action:, user: Current.user, metadata: {})
    ActivityEvent.create!(
      clinic: Current.clinic,
      user: user,
      trackable: trackable,
      action: action,
      metadata: metadata
    )
  end
end
