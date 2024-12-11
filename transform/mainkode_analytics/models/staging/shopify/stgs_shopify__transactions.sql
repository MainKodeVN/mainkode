WITH cleaned_receipt_table AS (

  SELECT
    *,
    TO_JSON(receipt) AS cleaned_receipt
  FROM {{ source('shopify', 'shopify_transactions') }}

)

SELECT
  _airbyte_raw_id,
  _airbyte_extracted_at,
  id,
  order_id,
  kind,
  status,
  gateway,
  amount,
  created_at,
  CAST(JSON_EXTRACT_PATH_TEXT(cleaned_receipt, 'fee_amount') AS NUMERIC)    AS fee_amount_local_currency,
  JSON_EXTRACT_PATH_TEXT(cleaned_receipt, 'fee_amount_currency_id')         AS fee_amount_currency_id,
  CAST(JSON_EXTRACT_PATH_TEXT(cleaned_receipt, 'settle_amount') AS NUMERIC) AS settle_amount,
  CAST(JSON_EXTRACT_PATH_TEXT(cleaned_receipt, 'exchange_rate') AS NUMERIC) AS exchange_rate
  -- Nested `PaymentInfo` fields (repeating some fields to showcase the structure, adjust as needed)
  --JSON_EXTRACT_PATH_TEXT(JSON_EXTRACT_PATH_TEXT(cleaned_receipt, '$.PaymentInfo'), '$.TransactionID') AS PaymentInfo_TransactionID,
  -- Nested `PaymentInfo.SellerDetails` fields
  --JSON_EXTRACT_PATH_TEXT(JSON_EXTRACT_PATH_TEXT(JSON_EXTRACT_PATH_TEXT(cleaned_receipt, '$.PaymentInfo'), '$.SellerDetails'), '$.PayPalAccountID') AS SellerDetails_PayPalAccountID
FROM cleaned_receipt_table
