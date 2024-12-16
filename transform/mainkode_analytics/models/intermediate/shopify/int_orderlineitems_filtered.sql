/*
Our intermediary e-commerce order line items table where we clean out data:
1. Exclude line items from before the transition to Shopify.
2. Exclude rows where the shipping address is NULL (possibly wholesale orders without individual shipping).
3. Exclude line items with titles containing variations of "wholesale" (likely wholesale orders that do not need to be analyzed).
*/

SELECT *
FROM {{ ref('stg_shopify__orderlineitems') }}
WHERE shipping_address IS NOT NULL -- Include only rows where the shipping address is not NULL (filter out wholesale or incomplete orders)
  AND product_name NOT LIKE '%wholesale%' -- Exclude rows where the 'name' column contains the word 'wholesale' (case-insensitive match)
