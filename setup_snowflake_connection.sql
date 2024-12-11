USE ROLE ACCOUNTADMIN;

DROP ROLE IF EXISTS LOADER_PROD;
DROP ROLE IF EXISTS TRANSFORMER_PROD;
DROP ROLE IF EXISTS REPORTER_PROD;

DROP ROLE IF EXISTS LOADER_DEV;
DROP ROLE IF EXISTS TRANSFORMER_DEV;
DROP ROLE IF EXISTS REPORTER_DEV;

DROP ROLE IF EXISTS LOADER_PREPROD;
DROP ROLE IF EXISTS TRANSFORMER_PREPROD;
DROP ROLE IF EXISTS REPORTER_PREPROD;

DROP DATABASE IF EXISTS RAW_PROD CASCADE;
DROP DATABASE IF EXISTS ANALYTICS_PROD CASCADE;

DROP DATABASE IF EXISTS RAW_DEV CASCADE;
DROP DATABASE IF EXISTS ANALYTICS_DEV CASCADE;

DROP DATABASE IF EXISTS RAW_PREPROD CASCADE;
DROP DATABASE IF EXISTS ANALYTICS_PREPROD CASCADE;

DROP WAREHOUSE IF EXISTS LOADING_PROD;
DROP WAREHOUSE IF EXISTS TRANSFORMING_PROD;
DROP WAREHOUSE IF EXISTS REPORTING_PROD;

DROP WAREHOUSE IF EXISTS LOADING_DEV;
DROP WAREHOUSE IF EXISTS TRANSFORMING_DEV;
DROP WAREHOUSE IF EXISTS REPORTING_DEV;

DROP WAREHOUSE IF EXISTS LOADING_PREPROD;
DROP WAREHOUSE IF EXISTS TRANSFORMING_PREPROD;
DROP WAREHOUSE IF EXISTS REPORTING_PREPROD;

-- Creating databases
CREATE DATABASE RAW_PROD COMMENT = 'Production landing zone for raw data';
CREATE DATABASE ANALYTICS_PROD COMMENT = 'Production data layer for analytics';

CREATE DATABASE RAW_DEV CLONE RAW_PROD COMMENT = 'Development landing zone for raw data';
CREATE DATABASE ANALYTICS_DEV CLONE ANALYTICS_PROD COMMENT = 'Development data layer for analytics';

CREATE DATABASE RAW_PREPROD CLONE RAW_PROD COMMENT = 'QA landing zone for raw data';
CREATE DATABASE ANALYTICS_PREPROD CLONE ANALYTICS_PROD COMMENT = 'QA data layer for analytics';

-- Creating warehouses
CREATE WAREHOUSE LOADING_PROD WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE COMMENT = 'Production warehouse for data loading';
CREATE WAREHOUSE TRANSFORMING_PROD WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE COMMENT = 'Production warehouse for data transformation';
CREATE WAREHOUSE REPORTING_PROD WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE COMMENT = 'Production warehouse for BI and reporting';

CREATE WAREHOUSE LOADING_DEV WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE COMMENT = 'Development warehouse for data loading';
CREATE WAREHOUSE TRANSFORMING_DEV WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE COMMENT = 'Development warehouse for data transformation';
CREATE WAREHOUSE REPORTING_DEV WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE COMMENT = 'Development warehouse for BI and reporting';

CREATE WAREHOUSE LOADING_PREPROD WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE COMMENT = 'QA warehouse for data loading';
CREATE WAREHOUSE TRANSFORMING_PREPROD WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE COMMENT = 'QA warehouse for data transformation';
CREATE WAREHOUSE REPORTING_PREPROD WITH WAREHOUSE_SIZE = 'XSMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE COMMENT = 'QA warehouse for BI and reporting';

-- Creating roles for each environment
CREATE ROLE LOADER_PROD COMMENT = 'Role for production data ingestion';
CREATE ROLE TRANSFORMER_PROD COMMENT = 'Role for production data transformations';
CREATE ROLE REPORTER_PROD COMMENT = 'Role for production BI tools and data consumers';

CREATE ROLE LOADER_DEV COMMENT = 'Role for development data ingestion';
CREATE ROLE TRANSFORMER_DEV COMMENT = 'Role for development data transformations';
CREATE ROLE REPORTER_DEV COMMENT = 'Role for development BI tools and data consumers';

CREATE ROLE LOADER_PREPROD COMMENT = 'Role for QA data ingestion';
CREATE ROLE TRANSFORMER_PREPROD COMMENT = 'Role for QA data transformations';
CREATE ROLE REPORTER_PREPROD COMMENT = 'Role for QA BI tools and data consumers';


-- Granting permissions for production LOADER_PROD role
GRANT USAGE, OPERATE ON WAREHOUSE LOADING_PROD TO ROLE LOADER_PROD;
GRANT ALL ON DATABASE RAW_PROD TO ROLE LOADER_PROD;
GRANT CREATE TABLE ON ALL SCHEMAS IN DATABASE RAW_PROD TO ROLE LOADER_PROD;
GRANT CREATE TABLE ON FUTURE SCHEMAS IN DATABASE RAW_PROD TO ROLE LOADER_PROD;


-- Granting permissions for production TRANSFORMER_PROD role
GRANT USAGE, OPERATE ON WAREHOUSE TRANSFORMING_PROD TO ROLE TRANSFORMER_PROD;
GRANT USAGE ON DATABASE RAW_PROD TO ROLE TRANSFORMER_PROD;
GRANT ALL ON DATABASE ANALYTICS_PROD TO ROLE TRANSFORMER_PROD;
GRANT SELECT ON ALL TABLES IN DATABASE RAW_PROD TO ROLE TRANSFORMER_PROD;
GRANT SELECT ON FUTURE TABLES IN DATABASE RAW_PROD TO ROLE TRANSFORMER_PROD;
GRANT USAGE ON ALL SCHEMAS IN DATABASE RAW_PROD TO ROLE TRANSFORMER_PROD;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE RAW_PROD TO ROLE TRANSFORMER_PROD;

-- Granting permissions for production REPORTER_PROD role
GRANT USAGE, OPERATE ON WAREHOUSE REPORTING_PROD TO ROLE REPORTER_PROD;
GRANT USAGE ON DATABASE ANALYTICS_PROD TO ROLE REPORTER_PROD;
GRANT SELECT ON ALL TABLES IN DATABASE ANALYTICS_PROD TO ROLE REPORTER_PROD;
GRANT SELECT ON FUTURE TABLES IN DATABASE ANALYTICS_PROD TO ROLE REPORTER_PROD;

-- Granting permissions for development LOADER_DEV role
GRANT USAGE, OPERATE ON WAREHOUSE LOADING_DEV TO ROLE LOADER_DEV;
GRANT ALL ON DATABASE RAW_DEV TO ROLE LOADER_DEV;
GRANT CREATE TABLE ON ALL SCHEMAS IN DATABASE RAW_DEV TO ROLE LOADER_DEV;
GRANT CREATE TABLE ON FUTURE SCHEMAS IN DATABASE RAW_DEV TO ROLE LOADER_DEV;

-- Granting permissions for development TRANSFORMER_DEV role
GRANT USAGE, OPERATE ON WAREHOUSE TRANSFORMING_DEV TO ROLE TRANSFORMER_DEV;
GRANT USAGE ON DATABASE RAW_DEV TO ROLE TRANSFORMER_DEV;
GRANT ALL ON DATABASE ANALYTICS_DEV TO ROLE TRANSFORMER_DEV;
GRANT SELECT ON ALL TABLES IN DATABASE RAW_DEV TO ROLE TRANSFORMER_DEV;
GRANT SELECT ON FUTURE TABLES IN DATABASE RAW_DEV TO ROLE TRANSFORMER_DEV;
GRANT USAGE ON ALL SCHEMAS IN DATABASE RAW_DEV TO ROLE TRANSFORMER_DEV;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE RAW_DEV TO ROLE TRANSFORMER_DEV;

-- Granting permissions for development REPORTER_DEV role
GRANT USAGE, OPERATE ON WAREHOUSE REPORTING_DEV TO ROLE REPORTER_DEV;
GRANT USAGE ON DATABASE ANALYTICS_DEV TO ROLE REPORTER_DEV;
GRANT SELECT ON ALL TABLES IN DATABASE ANALYTICS_DEV TO ROLE REPORTER_DEV;
GRANT SELECT ON FUTURE TABLES IN DATABASE ANALYTICS_DEV TO ROLE REPORTER_DEV;

-- Granting permissions for LOADER_PREPROD role
GRANT USAGE, OPERATE ON WAREHOUSE LOADING_PREPROD TO ROLE LOADER_PREPROD;
GRANT ALL ON DATABASE RAW_PREPROD TO ROLE LOADER_PREPROD;
GRANT CREATE TABLE ON ALL SCHEMAS IN DATABASE RAW_PREPROD TO ROLE LOADER_PREPROD;
GRANT CREATE TABLE ON FUTURE SCHEMAS IN DATABASE RAW_PREPROD TO ROLE LOADER_PREPROD;


-- Granting permissions for TRANSFORMER_PREPROD role
GRANT USAGE, OPERATE ON WAREHOUSE TRANSFORMING_PREPROD TO ROLE TRANSFORMER_PREPROD;
GRANT USAGE ON DATABASE RAW_PREPROD TO ROLE TRANSFORMER_PREPROD;
GRANT ALL ON DATABASE ANALYTICS_PREPROD TO ROLE TRANSFORMER_PREPROD;
GRANT SELECT ON ALL TABLES IN DATABASE RAW_PREPROD TO ROLE TRANSFORMER_PREPROD;
GRANT SELECT ON FUTURE TABLES IN DATABASE RAW_PREPROD TO ROLE TRANSFORMER_PREPROD;
GRANT USAGE ON ALL SCHEMAS IN DATABASE RAW_PREPROD TO ROLE TRANSFORMER_PREPROD;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE RAW_PREPROD TO ROLE TRANSFORMER_PREPROD;


-- Granting permissions for REPORTER_PREPROD role
GRANT USAGE, OPERATE ON WAREHOUSE REPORTING_PREPROD TO ROLE REPORTER_PREPROD;
GRANT USAGE ON DATABASE ANALYTICS_PREPROD TO ROLE REPORTER_PREPROD;
GRANT SELECT ON ALL TABLES IN DATABASE ANALYTICS_PREPROD TO ROLE REPORTER_PREPROD;
GRANT SELECT ON FUTURE TABLES IN DATABASE ANALYTICS_PREPROD TO ROLE REPORTER_PREPROD;