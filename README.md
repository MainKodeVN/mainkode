# Mainkode Analytics

This project delivers a modular, reusable, and open-source **dbt pipeline** for calculating e-commerce profitability, integrating key data sources like **Shopify**, **Facebook Ads**, **FedEx**, **GLS**, and more. The pipeline enables businesses to quickly model revenue, costs, and profitability metrics, offering insights to optimize operations and marketing strategies.  

## Key Dashboards  
1. **Revenue & Profit Overview**: Drill down to order-level profitability.  
2. **Cost Factor Analysis**: Understand cost impacts as a % of revenue.  
3. **Profit Margins by Country**: Identify top-performing regions.  
4. **Marketing ROI**: Optimize spend based on profit-driven ROI.  

## Architecture


![ELT drawio (1)](https://github.com/user-attachments/assets/aca71b55-cffd-4d71-8186-ed3f373b42ba)
- **Data Sources**:  
  - Shopify: Orders, balance, and transaction data.  
  - Facebook Ads: Marketing performance.  
  - PayPal: Payment processing.  
  - FedEx/GLS: Shipping (via GSheets).  
  - Manufacturing Costs: Cost data (via GSheets).
- **Models**:  
  - **Staging**: Clean raw data from source systems.  
  - **Intermediate**: Model revenue and costs separately.  
  - **Marts**: Compute profitability metrics and KPIs in a `fact_orders` table.
## Workflow
![elt1 drawio](https://github.com/user-attachments/assets/0b837175-70e9-47d3-a2c7-37afeaafed61)
- ### Production:

![elt2 drawio](https://github.com/user-attachments/assets/9d13a89a-44b2-47c4-a5fd-7ae88323190d)


## Data Lineage
<img width="746" alt="image" src="https://github.com/user-attachments/assets/4378e864-49c2-4cff-ae2a-ff7ed2b8550b" />
