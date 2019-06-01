require "mongoid"
require "sync_machine"
require "sync_machine/mongoid/adapter"
require "sync_machine/version"
require "wisper/mongoid"

# A mini-framework for intelligently publishing complex model changes to an
# external API.
module SyncMachine
  def self.orm_adapter
    Mongoid::Adapter
  end

  # Mongoid-specific functionality for SyncMachine.
  module Mongoid
    def self.extended(base)
      SyncMachine.extended(base)
      base.extend SyncMachine
    end
  end
end

Wisper::Mongoid.extend_all
