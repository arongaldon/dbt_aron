{{ config(materialized='table') }}

WITH source_data AS (

    SELECT 1 AS id, 'uno' AS name
    UNION ALL
    SELECT NULL AS id, 'nulo' AS name
    UNION ALL
    SELECT 2 AS id, 'dos' AS name

),

final AS (

SELECT *
FROM source_data
WHERE id IS NOT NULL

)

SELECT * FROM final
