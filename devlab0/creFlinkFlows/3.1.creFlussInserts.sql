

SET 'sql-client.execution.result-mode' = 'tableau';
SET 'parallelism.default' = '2';
SET 'sql-client.verbose' = 'true';
SET 'execution.runtime-mode' = 'streaming';


--- Push Data ---

--- Populate Unnested tables

SET 'pipeline.name' = 'Unnest factory_iot_north into factory_iot_north_unnested';

INSERT INTO fluss_catalog.fluss.factory_iot_north_unnested
SELECT
     ts                                             AS ts
    ,metadata.siteId                                AS siteId
    ,metadata.deviceId                              AS deviceId
    ,metadata.sensorId                              AS sensorId
    ,metadata.unit                                  AS unit
    ,measurement                                    AS measurement
    ,DATE_FORMAT(TO_TIMESTAMP_LTZ(ts, 3), 'yyyyMM') AS partition_month
FROM hive_catalog.iot.factory_iot_north;

SET 'pipeline.name' = 'Unnest factory_iot_south into factory_iot_south_unnested';

INSERT INTO fluss_catalog.fluss.factory_iot_south_unnested
SELECT
     ts                                             AS ts
    ,metadata.siteId                                AS siteId
    ,metadata.deviceId                              AS deviceId
    ,metadata.sensorId                              AS sensorId
    ,metadata.unit                                  AS unit
    ,metadata.ts_human                              AS ts_human
    ,metadata.location.latitude                     AS latitude
    ,metadata.location.longitude                    AS longitude
    ,measurement                                    AS measurement
    ,DATE_FORMAT(TO_TIMESTAMP_LTZ(ts, 3), 'yyyyMM') AS partition_month
FROM hive_catalog.iot.factory_iot_south;


SET 'pipeline.name' = 'Unnest factory_iot_east into factory_iot_east_unnested';

INSERT INTO fluss_catalog.fluss.factory_iot_east_unnested
SELECT
     ts                                             AS ts
    ,metadata.siteId                                AS siteId
    ,metadata.deviceId                              AS deviceId
    ,metadata.sensorId                              AS sensorId
    ,metadata.unit                                  AS unit
    ,metadata.ts_human                              AS ts_human
    ,metadata.location.latitude                     AS latitude
    ,metadata.location.longitude                    AS longitude
    ,metadata.deviceType                            AS deviceType
    ,measurement                                    AS measurement
    ,DATE_FORMAT(TO_TIMESTAMP_LTZ(ts, 3), 'yyyyMM') AS partition_month
FROM hive_catalog.iot.factory_iot_east;

