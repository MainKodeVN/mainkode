WITH source AS (

  SELECT * FROM {{ source('shopify', 'shopify_orders') }}

),

renamed AS (

  SELECT
    id,
    contact_email,
    payment_terms,
    total_tax_set,
    checkout_token,
    client_details,
    discount_codes,
    referring_site,
    shipping_lines,
    subtotal_price,
    taxes_included,
    billing_address,
    customer_locale,
    deleted_message,
    estimated_taxes,
    note_attributes,
    total_discounts,
    total_price_set,
    CAST(JSON_EXTRACT_PATH_TEXT(total_price_set, 'shop_money.amount') AS NUMERIC)        AS gross_sales_eur, -- this is pre refund
    CAST(JSON_EXTRACT_PATH_TEXT(total_price_set, 'presentment_money.amount') AS NUMERIC) AS gross_sales_lc, -- this is pre refund
    JSON_EXTRACT_PATH_TEXT(total_price_set, 'presentment_money.currency')                AS gross_sales_lc_id, -- this is pre refund
    total_price_usd,
    financial_status,
    landing_site_ref,
    order_status_url,
    shipping_address,
    JSON_EXTRACT_PATH_TEXT(billing_address, 'country')                                   AS country_code,
    created_at, --Order date
    closed_at,
    current_total_tax,
    source_identifier,
    total_outstanding,
    fulfillment_status,
    subtotal_price_set,
    total_tip_received,
    confirmation_number,
    current_total_price, --Current total price = revenue in euro (updated after refunds) 
    deleted_description,
    total_discounts_set,
    admin_graphql_api_id,
    discount_allocations,
    presentment_currency,
    current_total_tax_set,
    discount_applications,
    payment_gateway_names,
    CAST(current_subtotal_price AS NUMERIC)                                              AS current_subtotal_price,
    total_line_items_price,
    buyer_accepts_marketing,
    current_total_discounts,
    current_total_price_set,
    current_total_duties_set,
    total_shipping_price_set,
    merchant_of_record_app_id,
    original_total_duties_set,
    current_subtotal_price_set, --current subtotal price = amount excluding the shipping (updated for refunds) to be used for UK VAT 
    total_line_items_price_set,
    current_total_discounts_set,
    current_total_additional_fees_set,
    original_total_additional_fees_set

  FROM source

)

SELECT * FROM renamed
