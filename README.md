[![Gem Version](https://badge.fury.io/rb/cassandra_lock.svg)](http://badge.fury.io/rb/cassandra_lock)

# cassandra\_lock

A ruby lib to achieve [consensus](http://en.wikipedia.org/wiki/Consensus_%28computer_science%29) with Cassandra, inspired by [consensus on cassandra](http://www.datastax.com/dev/blog/consensus-on-cassandra). It can be used as lock in distributed systems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cassandra_lock'
```

And then execute:

```$ bundle```

Or install it yourself as:

```$ gem install cassandra_lock```

## Usage

Create the keyspace, see the example bellow.

```SQL
CREATE KEYSPACE test_lock WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'datacenter1' : 1 };
```

Create the table, see the example bellow.

```SQL
CREATE TABLE test_lock.leases (
      name text PRIMARY KEY,
      owner text,
      value text
 ) with default_time_to_live = 5
```

And finally to use in your code:

```ruby
#to create
contact_points = ["127.0.0.1"]
keyspace = "test_lock"
client = CassandraLock::Client.new(contact_points, keyspace)

#to lock
if client.lock("my_resource")
  puts "I acquired the lock"
else
  puts "Someone took the lock"
end

#to unlock
client.unlock("my_resource")

#to keep_alive
client.keep_alive("my_resource")

```

## Contributing

1. Fork it ( https://github.com/leandromoreira/cassandra_lock/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
