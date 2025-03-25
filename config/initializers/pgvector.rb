require 'pgvector'
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include(Pgvector::Rails::Adapter)
