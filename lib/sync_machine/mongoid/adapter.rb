module SyncMachine
  module Mongoid
    # Adapt generic SyncMachine functionality to Mongoid.
    module Adapter
      def self.change_listener_changed_keys(record)
        record.changes.keys
      end

      def self.record_id_for_job(record_id)
        record_id.to_s
      end

      def self.sufficient_changes_to_find_subjects?(_record)
        true
      end
    end
  end
end
