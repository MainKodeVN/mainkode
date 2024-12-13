WITH your_table AS (
  SELECT
    id,
    shipping_address,
    created_at,
    line_items
  FROM
    {{ source('shopify', 'shopify_orders') }}
)

SELECT
  id,
  shipping_address,
  created_at,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'fulfillable_quantity'
  )                                                       AS fulfillable_quantity,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'fulfillment_service'
  )                                                       AS fulfillment_service,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'fulfillment_status'
  )                                                       AS fulfillment_status,
  JSON_EXTRACT_PATH_TEXT(line_items, 'gift_card')         AS gift_card,
  JSON_EXTRACT_PATH_TEXT(line_items, 'grams')             AS grams,
  JSON_EXTRACT_PATH_TEXT(line_items, 'name')              AS product_name,
  JSON_EXTRACT_PATH_TEXT(line_items, 'price')             AS price,
  JSON_EXTRACT_PATH_TEXT(line_items, 'product_exists')    AS product_exists,
  JSON_EXTRACT_PATH_TEXT(line_items, 'product_id')        AS product_id,
  CAST(
    JSON_EXTRACT_PATH_TEXT(line_items, 'quantity') AS NUMERIC
  )                                                       AS quantity,
  JSON_EXTRACT_PATH_TEXT(line_items, 'requires_shipping') AS requires_shipping,
  JSON_EXTRACT_PATH_TEXT(line_items, 'sku')               AS sku,
  JSON_EXTRACT_PATH_TEXT(line_items, 'taxable')           AS taxable,
  JSON_EXTRACT_PATH_TEXT(line_items, 'title')             AS title,
  JSON_EXTRACT_PATH_TEXT(line_items, 'total_discount')    AS total_discount,
  JSON_EXTRACT_PATH_TEXT(line_items, 'variant_id')        AS variant_id,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'variant_inventory_management'
  )                                                       AS variant_inventory_management,
  JSON_EXTRACT_PATH_TEXT(line_items, 'variant_title')     AS variant_title,
  JSON_EXTRACT_PATH_TEXT(line_items, 'vendor')            AS vendor,
  -- Extracting nested fields
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'price_set.presentment_money.amount'
  )                                                       AS presentment_money_amount,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'price_set.presentment_money.currency_code'
  )                                                       AS presentment_money_currency,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'price_set.shop_money.amount'
  )                                                       AS shop_money_amount,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'price_set.shop_money.currency_code'
  )                                                       AS shop_money_currency,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'total_discount_set.presentment_money.amount'
  )                                                       AS total_discount_presentment_money_amount,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'total_discount_set.presentment_money.currency_code'
  )                                                       AS total_discount_presentment_money_currency,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'total_discount_set.shop_money.amount'
  )                                                       AS total_discount_shop_money_amount,
  JSON_EXTRACT_PATH_TEXT(
    line_items, 'total_discount_set.shop_money.currency_code'
  )                                                       AS total_discount_shop_money_currency_code
FROM
  your_table
WHERE
  LOWER(
    JSON_EXTRACT_PATH_TEXT(line_items, 'name')
  ) NOT LIKE '%wholesale%'
  AND LOWER(
    JSON_EXTRACT_PATH_TEXT(line_items, 'name')
  ) NOT LIKE '%wholsale%'
  AND LOWER(
    JSON_EXTRACT_PATH_TEXT(line_items, 'name')
  ) NOT LIKE '%wholsale%'
--We filter out wholesale orders paid on shopify
--total_price = total_line_items_price - total_discounts + total_shipping_price_set(shop_money/amounts) - refunds (shop_money/amounts)
