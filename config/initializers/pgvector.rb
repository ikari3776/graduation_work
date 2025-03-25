require 'pgvector'
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include(PGVector::Rails::Adapter)
