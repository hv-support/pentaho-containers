--
-- These queries create logging datamart tables for a PostGreSQL database
--
\connect hibernate hibuser

CREATE SCHEMA pentaho_operations_mart;

--
-- SHARED between BA & DI Data Mart - pentaho_operations_mart.DIM_DATE
--

CREATE TABLE  pentaho_operations_mart.DIM_DATE (
  date_tk int,
  date_field TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  ymd varchar(10) DEFAULT NULL,
  ym varchar(7) DEFAULT NULL,
  year int DEFAULT NULL,
  quarter int DEFAULT NULL,
  quarter_code varchar(2) DEFAULT NULL,
  month int DEFAULT NULL,
  month_desc varchar(20) DEFAULT NULL,
  month_code varchar(15) DEFAULT NULL,
  day int DEFAULT NULL,
  day_of_year int DEFAULT NULL,
  day_of_week int DEFAULT NULL,
  day_of_week_desc varchar(20) DEFAULT NULL,
  day_of_week_code varchar(15) DEFAULT NULL,
  week int DEFAULT NULL,
  PRIMARY KEY (date_tk)
);
CREATE INDEX IDX_DIM_DATE_DATE_TK ON pentaho_operations_mart.DIM_DATE (date_tk);

--
-- SHARED between BA & DI Data Mart - pentaho_operations_mart.DIM_TIME
--

CREATE TABLE  pentaho_operations_mart.DIM_TIME (
  time_tk int,
  hms varchar(8) DEFAULT NULL,
  hm varchar(5) DEFAULT NULL,
  ampm varchar(8) DEFAULT NULL,
  hour int DEFAULT NULL,
  hour12 int DEFAULT NULL,
  minute int DEFAULT NULL,
  second int DEFAULT NULL,
  PRIMARY KEY (time_tk)
);
CREATE INDEX IDX_DIM_TIME_TIME_TK ON pentaho_operations_mart.DIM_TIME(time_tk);

--
-- DI Data Mart - pentaho_operations_mart.DIM_BATCH
--

CREATE TABLE  pentaho_operations_mart.DIM_BATCH (
  batch_tk bigint,
  batch_id bigint DEFAULT NULL,
  logchannel_id varchar(100) DEFAULT NULL,
  parent_logchannel_id varchar(100) DEFAULT NULL,
  PRIMARY KEY (batch_tk)
);
CREATE INDEX IDX_DIM_BATCH_BATCH_TK ON pentaho_operations_mart.DIM_BATCH (batch_tk);
CREATE INDEX IDX_DIM_BATCH_LOOKUP ON pentaho_operations_mart.DIM_BATCH (batch_id,logchannel_id,parent_logchannel_id);

--
-- DI Data Mart - pentaho_operations_mart.DIM_EXECUTION
--

CREATE TABLE  pentaho_operations_mart.DIM_EXECUTION (
  execution_tk bigint,
  execution_id varchar(100) DEFAULT NULL,
  server_host varchar(100) DEFAULT NULL,
  executing_user varchar(100) DEFAULT NULL,
  execution_status varchar(30) DEFAULT NULL,
  client varchar(255) DEFAULT NULL
);
CREATE INDEX IDX_DIM_EXECUTION_EXECUTION_TK ON pentaho_operations_mart.DIM_EXECUTION(execution_tk);
CREATE INDEX IDX_DIM_EXECUTION_LOOKUP ON pentaho_operations_mart.DIM_EXECUTION(execution_id,server_host,executing_user,client);

--
-- DI Data Mart - pentaho_operations_mart.DIM_EXECUTOR
--

CREATE TABLE  pentaho_operations_mart.DIM_EXECUTOR (
  executor_tk bigint,
  version int DEFAULT NULL,
  date_from TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  date_to TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  executor_id varchar(255) DEFAULT NULL,
  executor_source varchar(255) DEFAULT NULL,
  executor_environment varchar(255) DEFAULT NULL,
  executor_type varchar(255) DEFAULT NULL,
  executor_name varchar(255) DEFAULT NULL,
  executor_desc varchar(255) DEFAULT NULL,
  executor_revision varchar(255) DEFAULT NULL,
  executor_version_label varchar(255) DEFAULT NULL,
  exec_enabled_table_logging char(1) DEFAULT NULL,
  exec_enabled_detailed_logging char(1) DEFAULT NULL,
  exec_enabled_perf_logging char(1) DEFAULT NULL,
  exec_enabled_history_logging char(1) DEFAULT NULL,
  last_updated_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  last_updated_user varchar(255) DEFAULT NULL,
  PRIMARY KEY (executor_tk)
);
CREATE INDEX IDX_DIM_EXECUTOR_executor_tk ON pentaho_operations_mart.DIM_EXECUTOR(executor_tk);
CREATE INDEX IDX_DIM_EXECUTOR_LOOKUP ON pentaho_operations_mart.DIM_EXECUTOR(executor_id);

--
-- DI Data Mart - pentaho_operations_mart.DIM_LOG_TABLE
--

CREATE TABLE pentaho_operations_mart.DIM_LOG_TABLE
(
  log_table_tk bigint,
  object_type VARCHAR(30) DEFAULT NULL,
  table_connection_name VARCHAR(255) DEFAULT NULL,
  table_name VARCHAR(255) DEFAULT NULL,
  schema_name VARCHAR(255) DEFAULT NULL,
  step_entry_table_conn_name VARCHAR(255) DEFAULT NULL,
  step_entry_table_name VARCHAR(255) DEFAULT NULL,
  step_entry_schema_name VARCHAR(255) DEFAULT NULL,
  perf_table_conn_name varchar(255) DEFAULT NULL,
  perf_table_name varchar(255) DEFAULT NULL,
  perf_schema_name varchar(255) DEFAULT NULL,
  PRIMARY KEY (log_table_tk)
);
CREATE UNIQUE INDEX idx_DIM_LOG_TABLE_pk ON pentaho_operations_mart.DIM_LOG_TABLE(log_table_tk);
CREATE INDEX idx_DIM_LOG_TABLE_lookup  ON pentaho_operations_mart.DIM_LOG_TABLE(object_type, table_connection_name, table_name, schema_name);
CREATE INDEX idx_DIM_LOG_STEP_ENTRY_lookup  ON pentaho_operations_mart.DIM_LOG_TABLE(object_type, step_entry_table_conn_name, step_entry_table_name, step_entry_schema_name);
CREATE INDEX idx_DIM_LOG_PERF_ENTRY_lookup  ON pentaho_operations_mart.DIM_LOG_TABLE(object_type, perf_table_conn_name, perf_table_name, perf_schema_name);

--
-- DI Data Mart - pentaho_operations_mart.DIM_STEP
--

CREATE TABLE pentaho_operations_mart.DIM_STEP
(
  step_tk bigint,
  step_id varchar(255) DEFAULT NULL,
  original_step_name varchar(255) DEFAULT NULL,
  PRIMARY KEY (step_tk)
);
CREATE INDEX IDX_DIM_STEP_step_tk ON pentaho_operations_mart.DIM_STEP(step_tk);
CREATE INDEX IDX_DIM_STEP_LOOKUP ON pentaho_operations_mart.DIM_STEP(step_id);

--
-- DI Data Mart - pentaho_operations_mart.FACT_EXECUTION
--

CREATE TABLE  pentaho_operations_mart.FACT_EXECUTION (
  execution_date_tk int DEFAULT NULL,
  execution_time_tk int DEFAULT NULL,
  batch_tk bigint DEFAULT NULL,
  execution_tk bigint DEFAULT NULL,
  executor_tk bigint DEFAULT NULL,
  parent_executor_tk bigint DEFAULT NULL,
  root_executor_tk bigint DEFAULT NULL,
  execution_timestamp TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  duration double precision DEFAULT NULL,
  rows_input bigint DEFAULT NULL,
  rows_output bigint DEFAULT NULL,
  rows_read bigint DEFAULT NULL,
  rows_written bigint DEFAULT NULL,
  rows_rejected bigint DEFAULT NULL,
  errors bigint DEFAULT NULL,
  failed smallint DEFAULT NULL
);
CREATE INDEX IDX_FACT_EXECUTION_EXECUTION_DATE_TK ON pentaho_operations_mart.FACT_EXECUTION(execution_date_tk);
CREATE INDEX IDX_FACT_EXECUTION_EXECUTION_TIME_TK ON pentaho_operations_mart.FACT_EXECUTION(execution_time_tk);
CREATE INDEX IDX_FACT_EXECUTION_BATCH_TK ON pentaho_operations_mart.FACT_EXECUTION(batch_tk);
CREATE INDEX IDX_FACT_EXECUTION_EXECUTION_TK ON pentaho_operations_mart.FACT_EXECUTION(execution_tk);
CREATE INDEX IDX_FACT_EXECUTION_EXECUTOR_TK ON pentaho_operations_mart.FACT_EXECUTION(executor_tk);
CREATE INDEX IDX_FACT_EXECUTION_PARENT_EXECUTOR_TK ON pentaho_operations_mart.FACT_EXECUTION(parent_executor_tk);
CREATE INDEX IDX_FACT_EXECUTION_ROOT_EXECUTOR_TK ON pentaho_operations_mart.FACT_EXECUTION(root_executor_tk);

--
-- DI Data Mart - pentaho_operations_mart.FACT_STEP_EXECUTION
--

CREATE TABLE  pentaho_operations_mart.FACT_STEP_EXECUTION (
  execution_date_tk int DEFAULT NULL,
  execution_time_tk int DEFAULT NULL,
  batch_tk bigint DEFAULT NULL,
  executor_tk bigint DEFAULT NULL,
  parent_executor_tk bigint DEFAULT NULL,
  root_executor_tk bigint DEFAULT NULL,
  step_tk bigint DEFAULT NULL,
  step_copy int DEFAULT NULL,
  execution_timestamp TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  rows_input bigint DEFAULT NULL,
  rows_output bigint DEFAULT NULL,
  rows_read bigint DEFAULT NULL,
  rows_written bigint DEFAULT NULL,
  rows_rejected bigint DEFAULT NULL,
  errors bigint DEFAULT NULL
);
CREATE INDEX IDX_FACT_STEP_EXECUTION_EXECUTION_DATE_TK ON pentaho_operations_mart.FACT_STEP_EXECUTION(execution_date_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_EXECUTION_TIME_TK ON pentaho_operations_mart.FACT_STEP_EXECUTION(execution_time_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_BATCH_TK ON pentaho_operations_mart.FACT_STEP_EXECUTION(batch_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_EXECUTOR_TK ON pentaho_operations_mart.FACT_STEP_EXECUTION(executor_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_PARENT_EXECUTOR_TK ON pentaho_operations_mart.FACT_STEP_EXECUTION(parent_executor_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_ROOT_EXECUTOR_TK ON pentaho_operations_mart.FACT_STEP_EXECUTION(root_executor_tk);
CREATE INDEX IDX_FACT_STEP_EXECUTION_STEP_TK ON pentaho_operations_mart.FACT_STEP_EXECUTION(step_tk);

--
-- DI Data Mart - pentaho_operations_mart.FACT_JOBENTRY_EXECUTION
--

CREATE TABLE  pentaho_operations_mart.FACT_JOBENTRY_EXECUTION (
  execution_date_tk int DEFAULT NULL,
  execution_time_tk int DEFAULT NULL,
  batch_tk bigint DEFAULT NULL,
  executor_tk bigint DEFAULT NULL,
  parent_executor_tk bigint DEFAULT NULL,
  root_executor_tk bigint DEFAULT NULL,
  step_tk bigint DEFAULT NULL,
  execution_timestamp TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  rows_input bigint DEFAULT NULL,
  rows_output bigint DEFAULT NULL,
  rows_read bigint DEFAULT NULL,
  rows_written bigint DEFAULT NULL,
  rows_rejected bigint DEFAULT NULL,
  errors bigint DEFAULT NULL,
  result char(5) DEFAULT NULL,
  nr_result_rows bigint DEFAULT NULL,
  nr_result_files bigint DEFAULT NULL
);
CREATE INDEX IDX_FACT_JOBENTRY_EXECUTION_EXECUTION_DATE_TK ON pentaho_operations_mart.FACT_JOBENTRY_EXECUTION(execution_date_tk);
CREATE INDEX IDX_FACT_JOBENTRY_EXECUTION_EXECUTION_TIME_TK ON pentaho_operations_mart.FACT_JOBENTRY_EXECUTION(execution_time_tk);
CREATE INDEX IDX_FACT_JOBENTRY_EXECUTION_BATCH_TK ON pentaho_operations_mart.FACT_JOBENTRY_EXECUTION(batch_tk);
CREATE INDEX IDX_FACT_JOBENTRY_EXECUTION_EXECUTOR_TK ON pentaho_operations_mart.FACT_JOBENTRY_EXECUTION(executor_tk);
CREATE INDEX IDX_FACT_JOBENTRY_EXECUTION_PARENT_EXECUTOR_TK ON pentaho_operations_mart.FACT_JOBENTRY_EXECUTION(parent_executor_tk);
CREATE INDEX IDX_FACT_JOBENTRY_EXECUTION_ROOT_EXECUTOR_TK ON pentaho_operations_mart.FACT_JOBENTRY_EXECUTION(root_executor_tk);
CREATE INDEX IDX_FACT_JOBENTRY_EXECUTION_STEP_TK ON pentaho_operations_mart.FACT_JOBENTRY_EXECUTION(step_tk);

--
-- DI Data Mart - pentaho_operations_mart.FACT_PERF_EXECUTION
--

CREATE TABLE  pentaho_operations_mart.FACT_PERF_EXECUTION (
  execution_date_tk int DEFAULT NULL,
  execution_time_tk int DEFAULT NULL,
  batch_tk bigint DEFAULT NULL,
  executor_tk bigint DEFAULT NULL,
  parent_executor_tk bigint DEFAULT NULL,
  root_executor_tk bigint DEFAULT NULL,
  step_tk bigint DEFAULT NULL,
  seq_nr bigint DEFAULT NULL,
  step_copy bigint DEFAULT NULL,
  execution_timestamp TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  rows_input bigint DEFAULT NULL,
  rows_output bigint DEFAULT NULL,
  rows_read bigint DEFAULT NULL,
  rows_written bigint DEFAULT NULL,
  rows_rejected bigint DEFAULT NULL,
  errors bigint DEFAULT NULL,
  input_buffer_rows bigint DEFAULT NULL,
  output_buffer_rows bigint DEFAULT NULL
);
CREATE INDEX IDX_FACT_PERF_EXECUTION_EXECUTION_DATE_TK ON pentaho_operations_mart.FACT_PERF_EXECUTION(execution_date_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_EXECUTION_TIME_TK ON pentaho_operations_mart.FACT_PERF_EXECUTION(execution_time_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_BATCH_TK ON pentaho_operations_mart.FACT_PERF_EXECUTION(batch_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_EXECUTOR_TK ON pentaho_operations_mart.FACT_PERF_EXECUTION(executor_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_PARENT_EXECUTOR_TK ON pentaho_operations_mart.FACT_PERF_EXECUTION(parent_executor_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_ROOT_EXECUTOR_TK ON pentaho_operations_mart.FACT_PERF_EXECUTION(root_executor_tk);
CREATE INDEX IDX_FACT_PERF_EXECUTION_STEP_TK ON pentaho_operations_mart.FACT_PERF_EXECUTION(step_tk);


--
-- BA Data Mart - pentaho_operations_mart.DIM_STATE
--

CREATE TABLE  pentaho_operations_mart.DIM_STATE (
  state_tk bigint NOT NULL,
  state varchar(100) NOT NULL,
  PRIMARY KEY (state_tk)
);
CREATE INDEX IDX_DIM_STATE_STATE_TK ON pentaho_operations_mart.DIM_STATE (state_tk);

--
-- BA Data Mart - pentaho_operations_mart.DIM_SESSION
--

CREATE TABLE  pentaho_operations_mart.DIM_SESSION (
  session_tk bigint NOT NULL,
  session_id varchar(200) NOT NULL,
  session_type varchar(200) NOT NULL,
  username varchar(200) NOT NULL,
  PRIMARY KEY (session_tk)
);
CREATE INDEX IDX_DIM_SESSION_SESSION_TK ON pentaho_operations_mart.DIM_SESSION (session_tk);

--
-- BA Data Mart - pentaho_operations_mart.DIM_INSTANCE
--

CREATE TABLE  pentaho_operations_mart.DIM_INSTANCE (
  instance_tk bigint NOT NULL,
  instance_id varchar(200) NOT NULL,
  engine_id varchar(200) NOT NULL,
  service_id varchar(200) NOT NULL,
  content_id varchar(1024) NOT NULL,
  content_detail varchar(1024),
  PRIMARY KEY (instance_tk)
);
CREATE INDEX IDX_DIM_INSTANCE_INSTANCE_TK ON pentaho_operations_mart.DIM_INSTANCE (instance_tk);

--
-- BA Data Mart - pentaho_operations_mart.DIM_COMPONENT
--

CREATE TABLE  pentaho_operations_mart.DIM_COMPONENT (
  component_tk bigint NOT NULL,
  component_id varchar(200) NOT NULL,
  PRIMARY KEY (component_tk)
);
CREATE INDEX IDX_DIM_COMPONENT_COMPONENT_TK ON pentaho_operations_mart.DIM_COMPONENT (component_tk);

--
-- BA Data Mart - pentaho_operations_mart.STG_CONTENT_ITEM
--

CREATE TABLE pentaho_operations_mart.STG_CONTENT_ITEM (
  gid char(36) NOT NULL,
  parent_gid char(36) DEFAULT NULL,
  fileSize int NOT NULL,
  locale varchar(5) DEFAULT NULL,
  name varchar(200) NOT NULL,
  ownerType int NOT NULL,
  path varchar(1024) NOT NULL,
  title varchar(255) DEFAULT NULL,
  is_folder char(1) NOT NULL,
  is_hidden char(1) NOT NULL,
  is_locked char(1) NOT NULL,
  is_versioned char(1) NOT NULL,
  date_created timestamp DEFAULT NULL,
  date_last_modified timestamp DEFAULT NULL,
  is_processed char(1) DEFAULT NULL,
  PRIMARY KEY (gid)
);
CREATE INDEX IDX_STG_CONTENT_ITEM_GID ON pentaho_operations_mart.STG_CONTENT_ITEM (gid);

--
-- BA Data Mart - pentaho_operations_mart.DIM_CONTENT_ITEM
--

CREATE TABLE pentaho_operations_mart.DIM_CONTENT_ITEM (
  content_item_tk int NOT NULL,
  content_item_title VARCHAR(255) NOT NULL DEFAULT 'NA',
  content_item_locale VARCHAR(255) NOT NULL DEFAULT 'NA',
  content_item_size int NULL DEFAULT 0,
  content_item_path VARCHAR(1024) NULL DEFAULT 'NA',
  content_item_name VARCHAR(255) NOT NULL DEFAULT 'NA',
  content_item_fullname VARCHAR(1024) NOT NULL DEFAULT 'NA',
  content_item_type VARCHAR(32) NOT NULL DEFAULT 'NA',
  content_item_extension VARCHAR(32) NULL DEFAULT 'NA',
  content_item_guid CHAR(36) NOT NULL DEFAULT 'NA',
  parent_content_item_guid CHAR(36) NULL DEFAULT 'NA',
  parent_content_item_tk int NULL,
  content_item_modified timestamp NOT NULL DEFAULT '1900-01-01 00:00:00',
  content_item_valid_from timestamp NOT NULL DEFAULT '1900-01-01 00:00:00',
  content_item_valid_to timestamp NOT NULL DEFAULT '9999-12-31 23:59:59',
  content_item_state VARCHAR(16) NULL DEFAULT 'new',
  content_item_version int NOT NULL DEFAULT 0,
  PRIMARY KEY(content_item_tk)
);
CREATE INDEX IDX_DIM_CONTENT_ITEM_CONTENT_ITEM_TK ON pentaho_operations_mart.DIM_CONTENT_ITEM (content_item_tk);
CREATE INDEX IDX_DIM_CONTENT_ITEM_GUID_FROM ON pentaho_operations_mart.DIM_CONTENT_ITEM (content_item_guid, content_item_valid_from);


--
-- BA Data Mart - pentaho_operations_mart.FACT_SESSION
--


CREATE TABLE  pentaho_operations_mart.FACT_SESSION (
  start_date_tk int NOT NULL,
  start_time_tk int NOT NULL,
  end_date_tk int NOT NULL,
  end_time_tk int NOT NULL,
  session_tk bigint NOT NULL,
  state_tk bigint NOT NULL,
  duration numeric(19,3) NOT NULL
);
CREATE INDEX IDX_FACT_PERF_SESSION_START_DATE_TK ON pentaho_operations_mart.FACT_SESSION(start_date_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_START_TIME_TK ON pentaho_operations_mart.FACT_SESSION(start_time_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_END_DATE_TK ON pentaho_operations_mart.FACT_SESSION(end_date_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_END_TIME_TK ON pentaho_operations_mart.FACT_SESSION(end_time_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_SESSION_TK ON pentaho_operations_mart.FACT_SESSION(session_tk);
CREATE INDEX IDX_FACT_PERF_SESSION_STATE_TK ON pentaho_operations_mart.FACT_SESSION(state_tk);


--
-- BA Data Mart - pentaho_operations_mart.FACT_INSTANCE
--

CREATE TABLE  pentaho_operations_mart.FACT_INSTANCE (
  start_date_tk int NOT NULL,
  start_time_tk int NOT NULL,
  end_date_tk int NOT NULL,
  end_time_tk int NOT NULL,
  session_tk bigint NOT NULL,
  instance_tk bigint NOT NULL,
  state_tk bigint NOT NULL,
  duration numeric(19,3) NOT NULL
);
CREATE INDEX IDX_FACT_PERF_INSTANCE_START_DATE_TK ON pentaho_operations_mart.FACT_INSTANCE(start_date_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_START_TIME_TK ON pentaho_operations_mart.FACT_INSTANCE(start_time_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_END_DATE_TK ON pentaho_operations_mart.FACT_INSTANCE(end_date_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_END_TIME_TK ON pentaho_operations_mart.FACT_INSTANCE(end_time_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_SESSION_TK ON pentaho_operations_mart.FACT_INSTANCE(session_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_INSTANCE_TK ON pentaho_operations_mart.FACT_INSTANCE(instance_tk);
CREATE INDEX IDX_FACT_PERF_INSTANCE_STATE_TK ON pentaho_operations_mart.FACT_INSTANCE(state_tk);

--
-- BA Data Mart - pentaho_operations_mart.FACT_COMPONENT
--

CREATE TABLE  pentaho_operations_mart.FACT_COMPONENT (
  start_date_tk int NOT NULL,
  start_time_tk int NOT NULL,
  end_date_tk int NOT NULL,
  end_time_tk int NOT NULL,
  session_tk bigint NOT NULL,
  instance_tk bigint NOT NULL,
  state_tk bigint NOT NULL,
  component_tk bigint NOT NULL,
  duration numeric(19,3) NOT NULL
);
CREATE INDEX IDX_FACT_PERF_COMPONENT_START_DATE_TK ON pentaho_operations_mart.FACT_COMPONENT(start_date_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_START_TIME_TK ON pentaho_operations_mart.FACT_COMPONENT(start_time_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_END_DATE_TK ON pentaho_operations_mart.FACT_COMPONENT(end_date_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_END_TIME_TK ON pentaho_operations_mart.FACT_COMPONENT(end_time_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_SESSION_TK ON pentaho_operations_mart.FACT_COMPONENT(session_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_INSTANCE_TK ON pentaho_operations_mart.FACT_COMPONENT(instance_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_COMPONENT_TK ON pentaho_operations_mart.FACT_COMPONENT(component_tk);
CREATE INDEX IDX_FACT_PERF_COMPONENT_STATE_TK ON pentaho_operations_mart.FACT_COMPONENT(state_tk);

--
-- BA Data Mart - pentaho_operations_mart.PRO_AUDIT_STAGING
--

CREATE TABLE pentaho_operations_mart.PRO_AUDIT_STAGING (
   job_id varchar(200),
   inst_id varchar(200),
   obj_id varchar(1024),
   obj_type varchar(200),
   actor varchar(200),
   message_type varchar(200),
   message_name varchar(200),
   message_text_value varchar(1024),
   message_num_value numeric(19),
   duration numeric(19, 3),
   audit_time timestamp
);
CREATE INDEX IDX_PRO_AUDIT_STAGING_MESSAGE_TYPE ON pentaho_operations_mart.PRO_AUDIT_STAGING(message_type);

--
-- BA Data Mart - pentaho_operations_mart.PRO_AUDIT_TRACKER
--

CREATE TABLE pentaho_operations_mart.PRO_AUDIT_TRACKER (
   audit_time timestamp
);
CREATE INDEX IDX_PRO_AUDIT_TRACKER_AUDIT_TIME ON pentaho_operations_mart.PRO_AUDIT_STAGING(audit_time);
INSERT INTO pentaho_operations_mart.PRO_AUDIT_TRACKER values (timestamptz 'epoch');

