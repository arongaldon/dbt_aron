{{ config(materialized='table') }}

WITH source_data AS (

    SELECT 1 AS id
    UNION ALL
    SELECT NULL AS id

),

final AS (

SELECT *
FROM source_data
WHERE id IS NOT NULL

)

SELECT * FROM final
