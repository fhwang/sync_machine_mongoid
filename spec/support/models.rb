class Address
  include Mongoid::Document

  field :address1,  type: String
  field :address2,  type: String
  field :city,      type: String
  field :state,     type: String
  field :zip,       type: String
end

class Customer
  include Mongoid::Document

  field :name, type: String

  embeds_one  :address
  has_many    :orders
end

class Order
  include Mongoid::Document

  field :next_payload, type: Hash, default: {"foo" => "bar"}
  field :publishable, type: Boolean, default: true

  belongs_to :customer
end

module TestSync
  class Payload
    include ::Mongoid::Document

    field :body, type: Hash
    field :generated_at, type: Time
    field :subject_id, type: String

    validates :generated_at, presence: true
    validates :subject_id, presence: true, uniqueness: true
  end
end
