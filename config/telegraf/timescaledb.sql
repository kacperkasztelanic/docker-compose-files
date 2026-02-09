CREATE TABLE iot_data (
   time        timestamp DEFAULT now() NOT NULL,
   device_id   TEXT,
   app         TEXT,
   fields      JSONB
);
SELECT create_hypertable('iot_data', 'time');

CREATE TABLE iot_logs (
   time        timestamp DEFAULT now() NOT NULL,
   device_id   TEXT,
   app         TEXT,
   level       TEXT,
   msg         TEXT
);
SELECT create_hypertable('iot_logs', 'time');

CREATE INDEX idx_data_dev ON iot_data (device_id, time DESC);
CREATE INDEX idx_logs_dev ON iot_logs (device_id, time DESC);
CREATE INDEX idx_data_fields ON iot_data USING GIN (fields);

