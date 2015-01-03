require 'spec_helper'

RSpec.describe CassandraLock::Client do
  let(:contact_points) {["127.0.0.1"]}
  let(:keyspace) { "test_lock" }
  let(:resource_key) { "foo" }
  let(:ttl) { 1000 }

  it 'locks' do
    first_client = CassandraLock::Client.new(contact_points, keyspace)
    second_client = CassandraLock::Client.new(contact_points, keyspace)

    first_try_lock_info = first_client.lock(resource_key)
    second_try_lock_info = second_client.lock(resource_key)

    expect(first_try_lock_info).to be_truthy
    expect(second_try_lock_info).to be_falsy

    first_client.unlock(resource_key)
  end

  it 'unlocks' do
    first_client = CassandraLock::Client.new(contact_points, keyspace)
    second_client = CassandraLock::Client.new(contact_points, keyspace)

    first_try_lock_info = first_client.lock(resource_key)
    first_client.unlock(resource_key)

    second_try_lock_info = second_client.lock(resource_key)

    expect(second_try_lock_info).to be_truthy
  end

  it 'expires' do
    first_client = CassandraLock::Client.new(contact_points, keyspace)
    first_try_lock_info = first_client.lock(resource_key)

    sleep 6

    expect(first_try_lock_info).to be_falsy
  end

  it 'keeps alive' do
    first_client = CassandraLock::Client.new(contact_points, keyspace)
    first_try_lock_info = first_client.lock(resource_key)

    sleep 3

    first_client.keep_alive(resource_key)

    sleep 3

    expect(first_try_lock_info).to be_truthy
  end
end
