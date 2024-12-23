
### **Why this model?**
Running a fashion e-commerce business means you have lots of different costs: from making your products, shipping them, and paying platform fees, to marketing and VAT taxes. To figure out whether your business is making money (profitability), you need to track all these costs alongside your revenue **on the order level**.

### **Profitability Formula:**
This is the simplified equation we’re using:

**Profit (EUR) = Revenue from sales**  
\- Refunds  
\- Platform & Payment Gateway Fees  
\- Manufacturing Costs  
\- Marketing Costs  
\- Shipping Costs  
\- VAT Costs

---

### **Step-by-Step Approach:**

1. **Break down all costs and revenue** into simple tables. Each table shows one type of cost (e.g., shipping, marketing) per order.  
2. **Join these tables** into one “master table” (called a **fact order table**) so every order has all the associated costs in one place.
3. **Do calculations on this table** to find things like gross revenue, net revenue, cost of goods sold (COGS), and profit.

---

### **How does it work?**

#### Example:
Imagine you have the following details for a single order (Order ID: #1001):

- **Revenue**: €100 (customer paid this amount)
- **Refunds**: €10 (refund issued to the customer)
- **VAT (tax)**: €15 (tax you need to pay)
- **Platform Fees**: €5 (Shopify’s cut)
- **Payment Fees**: €3 (PayPal’s cut)
- **Manufacturing Cost**: €30 (cost of making the product)
- **Shipping Cost**: €7 (shipping company fee)
- **Marketing Cost**: €10 (ad spend to get the customer)

Now calculate step by step:

1. **Gross Revenue**:  
   Revenue - Refunds = €100 - €10 = **€90**

2. **Net Revenue**:  
   Gross Revenue - VAT = €90 - €15 = **€75**

3. **COGS (Cost of Goods Sold)**:  
   Manufacturing Cost + Shipping Cost + Platform & Payment Fees = €30 + €7 + (€5 + €3) = **€45**

4. **Gross Profit**:  
   Net Revenue - COGS - Marketing Cost = €75 - €45 - €10 = **€20**

So, **Profit for Order #1001 = €20**

---

### **How is this structured in the model?**

1. **Data sources** (Shopify, Google Sheets, etc.) give you tables like:  
   - **Orders Table**: Contains order details like revenue, refunds, etc.  
   - **Shipping Costs Table**: Lists shipping costs per order.  
   - **VAT Table**: Contains VAT rates by country.  
   - **Manufacturing Costs Table**: Shows cost per product (SKU).  
   - **Marketing Costs Table**: Aggregates marketing costs per month.

2. **Intermediate tables**: Combine or calculate individual costs per order, like:  
   - VAT cost per order (using VAT rate and revenue).  
   - Shipping cost by matching order IDs with tracking info.  

3. **Fact Order Table**: All costs and revenues for each order are combined into one table.

---

### **Mock Example of Final Table:**

| **Order ID** | **Revenue (EUR)** | **Refunds (EUR)** | **VAT Costs (EUR)** | **Platform Fees (EUR)** | **Payment Fees (EUR)** | **Manufacturing Costs (EUR)** | **Shipping Costs (EUR)** | **Marketing Costs (EUR)** | **Profit (EUR)** |
|--------------|--------------------|--------------------|----------------------|--------------------------|-------------------------|-----------------------------|--------------------------|--------------------------|-------------------|
| #1001        | 100                | 10                 | 15                   | 5                        | 3                       | 30                          | 7                        | 10                       | 20                |
| #1002        | 200                | 0                  | 30                   | 10                       | 6                       | 50                          | 12                       | 20                       | 72                |
| #1003        | 150                | 20                 | 25                   | 8                        | 4                       | 40                          | 10                       | 15                       | 28                |

---

### **Key Questions the Model Can Answer:**
1. **Is my business profitable?** (Look at total profit across all orders).  
2. **How does profitability change over time?** (Group orders by month, quarter, year).  
3. **Which costs are eating up most of my revenue?** (Break costs into percentages).  
4. **How can I improve profitability?** (E.g., switch to a cheaper shipping company).

---

### What is the **`CASE` Statement** Doing?
The `CASE` statement is calculating **gross profit (`gross_profit_EUR`)** for each order. 

However, some orders are **cancelled**, meaning:
1. No shipping, manufacturing, or VAT costs are incurred.
2. Only marketing costs might have been spent.

So, the `CASE` ensures:
- **If the order is cancelled:** Gross profit is just negative marketing costs.
- **If the order is processed:** Gross profit is calculated normally by subtracting all the costs from the revenue.

---

#### **Scenario 1: Cancelled Orders**
The code checks for cancelled orders with this part:
```sql
WHEN st.shipping_costs IS NULL 
     AND ot.gross_sales_EUR - IFNULL(rt.total_refund_amount_EUR, 0) < 20
```

- **`st.shipping_costs IS NULL`**: This means no shipping costs exist, likely because the order was cancelled.
- **`ot.gross_sales_EUR - IFNULL(rt.total_refund_amount_EUR, 0) < 20`**:
  - `gross_sales_EUR` is the total revenue from the order.
  - `total_refund_amount_EUR` is how much was refunded.
  - If the **net revenue** (revenue after refunds) is less than €20, it’s likely a cancelled order.

For these orders, gross profit is calculated as:
```sql
-ROUND(IFNULL(mkt.avg_paidmktgcosts_per_order, 0), 2)
```
This simply makes the gross profit equal to **negative marketing costs**, because:
- You spent money on marketing.
- But no revenue came in due to cancellation.

---

#### **Scenario 2: Processed Orders**
If the order is not cancelled (i.e., it has shipping costs and enough revenue), the code calculates gross profit normally with this:
```sql
ELSE ROUND((ot.gross_sales_EUR 
            - IFNULL(rt.total_refund_amount_EUR, 0) 
            - vt.vat_fee 
            - (IFNULL(mkt.avg_paidmktgcosts_per_order, 0) 
               + mt.total_manufacturing_costs 
               + st.shipping_costs 
               + ct.total_commision_EUR)), 2)
```

Here’s the breakdown:
1. **Start with Gross Sales**:  
   `ot.gross_sales_EUR`
   
2. **Subtract Refunds**:  
   `- IFNULL(rt.total_refund_amount_EUR, 0)`  
   If no refund exists, assume `0`.

3. **Subtract VAT Fees**:  
   `- vt.vat_fee`



Continuing from where I left off:

4. **Subtract All Costs**:
   This includes:
   - **Marketing Costs**: `IFNULL(mkt.avg_paidmktgcosts_per_order, 0)` (default to `0` if no value exists).
   - **Manufacturing Costs**: `mt.total_manufacturing_costs`.
   - **Shipping Costs**: `st.shipping_costs`.
   - **Commission Fees**: `ct.total_commision_EUR`.

5. **Round the Result**:  
   The entire calculation is wrapped in `ROUND(..., 2)` to ensure the result is rounded to 2 decimal places.

---

### Real-Life Mock Example

Here’s a simplified mock example to illustrate both cases:

#### Example 1: **Cancelled Order**
| Field                       | Value  |
|-----------------------------|--------|
| `gross_sales_EUR`           | €10    |
| `total_refund_amount_EUR`   | €10    |
| `vat_fee`                   | NULL   |
| `avg_paidmktgcosts_per_order` | €5   |
| `manufacturing_costs`        | NULL   |
| `shipping_costs`             | NULL   |
| `commission_costs`           | NULL   |

- **Step 1: Check Conditions for Cancelled Order**:
  - `shipping_costs IS NULL` → True.
  - `gross_sales_EUR - total_refund_amount_EUR = 10 - 10 = 0` (less than €20) → True.

- **Step 2: Apply Cancelled Order Formula**:
  ```sql
  gross_profit_EUR = - ROUND(IFNULL(avg_paidmktgcosts_per_order, 0), 2)
                   = - ROUND(5, 2)
                   = -5
  ```

So, the gross profit is **€-5**.

---

#### Example 2: **Processed Order**
| Field                       | Value   |
|-----------------------------|---------|
| `gross_sales_EUR`           | €100    |
| `total_refund_amount_EUR`   | €0      |
| `vat_fee`                   | €15     |
| `avg_paidmktgcosts_per_order` | €10    |
| `manufacturing_costs`        | €30     |
| `shipping_costs`             | €7      |
| `commission_costs`           | €5      |

- **Step 1: Check Conditions for Cancelled Order**:
  - `shipping_costs IS NULL` → False.
  - No need to proceed further; this is a processed order.

- **Step 2: Apply Processed Order Formula**:
  ```sql
  gross_profit_EUR = ROUND(gross_sales_EUR 
                           - total_refund_amount_EUR 
                           - vat_fee 
                           - (avg_paidmktgcosts_per_order 
                              + manufacturing_costs 
                              + shipping_costs 
                              + commission_costs), 2)

                   = ROUND(100 
                           - 0 
                           - 15 
                           - (10 + 30 + 7 + 5), 2)

                   = ROUND(100 - 15 - 52, 2)

                   = ROUND(33, 2)

                   = 33
  ```

So, the gross profit is **€33**.

---

### Key Takeaways

- The `CASE` statement ensures **cancelled orders** are handled differently to avoid incorrect calculations.
- **Cancelled orders** only record marketing costs as a loss.
- **Processed orders** calculate profit normally, including all costs and revenues.
- This approach ensures clean and accurate profitability reporting for all orders.