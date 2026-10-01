-- Initialize CodeMesh database schema
-- This script runs automatically when the PostgreSQL container starts

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Health check table
CREATE TABLE IF NOT EXISTS health_checks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  service_name VARCHAR(255) NOT NULL,
  status VARCHAR(50) NOT NULL,
  message TEXT,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_health_checks_service ON health_checks(service_name);
CREATE INDEX IF NOT EXISTS idx_health_checks_timestamp ON health_checks(timestamp);

-- Insert initial health check
INSERT INTO health_checks (service_name, status, message)
VALUES ('database', 'healthy', 'PostgreSQL initialized successfully')
ON CONFLICT DO NOTHING;

-- Grant permissions
GRANT CONNECT ON DATABASE codemesh_dev TO codemesh;
GRANT USAGE ON SCHEMA public TO codemesh;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO codemesh;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO codemesh;
