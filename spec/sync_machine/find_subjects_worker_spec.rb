require 'spec_helper'

RSpec.describe SyncMachine::FindSubjectsWorker do
  before do
    TestSync::EnsurePublicationWorker.clear
  end

  it "enqueues one EnsurePublicationWorker for each subject_id" do
    customer = create(:customer)
    order1 = create(:order, customer: customer)
    order2 = create(:order, customer: customer)
    enqueue_time_str = Time.now.iso8601
    TestSync::FindSubjectsWorker.new.perform(
      'Customer', customer.id.to_s, ['name'], enqueue_time_str
    )
    expect(TestSync::EnsurePublicationWorker.jobs.count).to eq(2)
    jobs = TestSync::EnsurePublicationWorker.jobs
    [order1, order2].each do |order|
      order_job = jobs.detect { |j|
        j['args'].first == order.id.to_s
      }
      expect(order_job).to be_present
      expect(order_job['args'].count).to eq(2)
      expect(order_job['args'].last).to eq(enqueue_time_str)
    end
  end

  it "handles the default case" do
    order = create(:order)
    enqueue_time_str = Time.now.iso8601
    TestSync::FindSubjectsWorker.new.perform(
      'Order', order.id.to_s, ['name'], enqueue_time_str
    )
    expect(TestSync::EnsurePublicationWorker.jobs.count).to eq(1)
    job = TestSync::EnsurePublicationWorker.jobs.first
    expect(job['args'].count).to eq(2)
    expect(job['args'].first).to eq(order.id.to_s)
    expect(job['args'].last).to eq(enqueue_time_str)
  end

  it "allows a manual override of the default case and wraps a single ID in an array" do
    order = create(:order)
    enqueue_time_str = Time.now.iso8601
    TestSync2::FindSubjectsWorker.new.perform(
      'Order', order.id.to_s, ['name'], enqueue_time_str
    )
    expect(TestSync2::EnsurePublicationWorker.jobs.count).to eq(1)
    job = TestSync2::EnsurePublicationWorker.jobs.first
    expect(job['args'].count).to eq(2)
    expect(job['args'].first).to eq("O#{order.id.to_s}")
    expect(job['args'].last).to eq(enqueue_time_str)
  end
end
