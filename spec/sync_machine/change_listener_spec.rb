require 'spec_helper'

RSpec.describe SyncMachine::ChangeListener do
  before do
    TestSync::FindSubjectsWorker.clear
  end

  it "enqueues a FindSubjectsWorker when a model is created" do
    test_sync_subject = Customer.create!
    expect(TestSync::FindSubjectsWorker.jobs.count).to eq(1)
    args = TestSync::FindSubjectsWorker.jobs.first['args']
    expect(args.size).to eq(4)
    expect(args[0]).to eq('Customer')
    expect(args[1]).to eq(test_sync_subject.id.to_s)
    expect(args[2]).to eq(['_id'])
    expect(Time.parse(args[3])).to be_within(1).of(Time.now)
  end

  it "enqueues a FindSubjectsWorker when values within an embed are changed" do
    customer = Customer.create!(
      address: Address.new(address1: '123 Main Street')
    )
    TestSync::FindSubjectsWorker.clear
    customer.address.address2 = 'Apt 45'
    customer.save!
    expect(TestSync::FindSubjectsWorker.jobs.count).to eq(1)
    args = TestSync::FindSubjectsWorker.jobs.first['args']
    expect(args.size).to eq(4)
    expect(args[0]).to eq('Customer')
    expect(args[1]).to eq(customer.id.to_s)
    expect(args[2]).to eq([])
    expect(Time.parse(args[3])).to be_within(1).of(Time.now)
  end
end
