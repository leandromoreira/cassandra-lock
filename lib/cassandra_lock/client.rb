require 'cassandra'
require 'securerandom'

module CassandraLock
  class Client
    attr_reader :id

    def initialize(contact_points, keyspace, id=nil)
      cluster = Cassandra.cluster hosts: contact_points
      @cassandra = cluster.connect keyspace
      @id = id || SecureRandom.uuid
      @LOCK = @cassandra.prepare "INSERT INTO leases (name, owner) VALUES (?,?) IF NOT EXISTS"
      @KEEPALIVE = @cassandra.prepare "UPDATE leases set owner = ? where name = ? IF owner = ?"
      @UNLOCK = @cassandra.prepare "DELETE FROM leases where name = ? IF owner = ?"
    end

    def lock(resource)
      result = @cassandra.execute(@LOCK, resource, @id)
      result.first["[applied]"]
    end

    def keep_alive(resource)
      @cassandra.execute(@KEEPALIVE, @id, resource, @id)
    end

    def unlock(resource)
      @cassandra.execute(@UNLOCK, resource, @id)
    end
  end
end
