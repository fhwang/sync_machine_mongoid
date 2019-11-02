module TestSync2
  extend SyncMachine::Mongoid

  subject :order

  class ChangeListener < SyncMachine::ChangeListener
    listen_to_models :order
  end

  class FindSubjectsWorker < SyncMachine::FindSubjectsWorker
    subject_ids_from_order do |order|
      "O#{order.id}"
    end
  end

  class EnsurePublicationWorker < SyncMachine::EnsurePublicationWorker
    check_publishable do |subject|
      subject.publishable?
    end

    build do |subject|
      subject.next_payload
    end

    publish do |_subject, payload_body|
      PostService.post(payload_body)
    end
  end

  class PostService
    def self.post(_payload_body)
    end
  end
end
