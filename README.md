# Mainkode Analytics  

This project provides a modular, reusable, and open-source **dbt pipeline** to calculate e-commerce profitability. By integrating data from key sources like **Shopify**, **Facebook Ads**, **FedEx**, **GLS**, and more, the pipeline delivers actionable insights to optimize operations and marketing strategies.  

## Key Dashboards  
1. **Revenue & Profit Overview**: Order-level profitability.  
2. **Cost Factor Analysis**: Cost impacts as a % of revenue.  
3. **Profit Margins by Country**: Top-performing regions.  
4. **Marketing ROI**: Profit-driven ad spend optimization.  

## Architecture  

![ELT drawio (1)](https://github.com/user-attachments/assets/aca71b55-cffd-4d71-8186-ed3f373b42ba)  

- **Data Sources**:  
  - Shopify: Orders, transactions, balances.  
  - Facebook Ads: Marketing performance.  
  - PayPal: Payment processing.  
  - FedEx/GLS: Shipping data (via GSheets).  
  - Manufacturing Costs: Cost data (via GSheets).  
- **Models**:  
  - **Staging**: Source data cleaning.  
  - **Intermediate**: Revenue and cost modeling.  
  - **Marts**: Profitability metrics and KPIs (`fact_orders`).  

## Workflow  

![elt1 drawio](https://github.com/user-attachments/assets/0b837175-70e9-47d3-a2c7-37afeaafed61)  

### Production  

![elt2 drawio](https://github.com/user-attachments/assets/9d13a89a-44b2-47c4-a5fd-7ae88323190d)  

## Data Lineage  

<img width="746" alt="image" src="https://github.com/user-attachments/assets/4378e864-49c2-4cff-ae2a-ff7ed2b8550b" />  

## Visualization

![Untitled_Report-1](https://github.com/user-attachments/assets/c3dfa1e7-1df2-41a5-8f22-4c7eaf452167)

---  

**Author**: [Phong Nguyen](https://github.com/shrestic) (a.k.a. shrestic)  
