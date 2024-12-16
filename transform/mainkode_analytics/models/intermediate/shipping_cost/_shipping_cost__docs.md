### **Challenges:**
1. **FedEx Data:**
   - Straightforward data structure.
   - Contains details like the **tracking number**, **shipping cost (net of VAT)**, **recipient country**, and **type of service** (e.g., standard or express delivery).
   - **No API available** for automatic data retrieval, so data has to be manually downloaded monthly and uploaded into the data warehouse.

2. **Spring Data:**
   - **Messy and complex data structure:**
     - **Multiple records for one order:** Each order has a tracking number, but there are multiple derivatives of the tracking number for additional charges like fuel fees, surcharges, or other supplements.
     - **Extra costs:** Spring charges for bulk order pick-ups separately, which aren't directly tied to individual orders.
   - No API is available either, so historical data is uploaded via Excel invoices.

3. **Combining FedEx and Spring Data:**
   - The structure of Spring’s data must be transformed to match the simplicity of FedEx’s data (one tracking number per order with total costs). This involves:
     1. Aggregating Spring’s multiple tracking numbers into one.
     2. Distributing bulk pick-up fees proportionally across orders.
     3. Ensuring certain orders (e.g., those starting with "1Z96") are excluded from additional pick-up fees.

---

### **Step-by-Step Process:**

#### **Step 1: Preparing FedEx Data**
- Since FedEx provides no API or scraping options, the process is manual:
  1. **Monthly Reports** are downloaded containing the shipping history.
  2. This data is uploaded to the warehouse using a tool called **Airbyte Google Sheets connector**.
  3. The data structure includes:
     - **Tracking Number:** Identifies each shipment.
     - **Net Shipping Cost:** The amount charged (before VAT).
     - **Country:** The recipient’s location.
     - **Service Type:** Whether it’s standard or express delivery.
- **Example:**
  | Tracking Number | Net Shipping Cost | Country  | Service Type |
  |-----------------|-------------------|----------|--------------|
  | FE12345         | €10.00           | Germany  | Standard      |
  | FE67890         | €15.00           | France   | Express       |

#### **Step 2: Preparing Spring Data**
- Spring’s data is messier and requires a lot of preprocessing:
  1. **Load Invoices:** Upload historical invoices into the warehouse via Airbyte.
  2. **Aggregate Costs:** For each tracking number, combine all related charges (e.g., base shipping fee + surcharges).
     - **Example:**
       - Tracking Number: `SP12345` (base) + `SP12345/FUEL` (fuel surcharge) + `SP12345/DIST` (distance fee).
       - Aggregate these to calculate the **total cost for the order.**
  3. **Distribute Pick-Up Fees:** Spring charges fees for bulk pick-ups (e.g., €100 for all orders shipped that month). These fees must be split among all the month’s orders to reflect their fair share of costs.
  4. **Exclude Certain Orders:** Orders starting with `1Z96` should not have pick-up fees added.

- **Example Before Aggregation:**
  | Tracking Number       | Cost  |
  |-----------------------|-------|
  | SP12345               | €8.00 |
  | SP12345/FUEL          | €1.50 |
  | SP12345/DIST          | €0.50 |
  | Bulk Pick-Up Cost     | €100.00 (for 100 orders that month) |

- **After Aggregation and Fee Distribution:**
  - Tracking Number: `SP12345`
  - Total Cost: €10.00 (€8.00 + €1.50 + €0.50 + €1.00 [pick-up fee distribution])

#### **Step 3: Modeling Spring Data**
- This step focuses on transforming the Spring data into a structure similar to FedEx’s:
  - **One Order = One Tracking Number + Total Cost.**
  - Create intermediary variables, such as:
    - **Cleaned Tracking Number:** Remove `/FUEL` and other suffixes to group costs by order.
    - **Monthly Pick-Up Fee Share:** Divide pick-up costs among all orders for the month.
    - **Final Net Cost per Order:** Add base shipping cost and surcharges, then distribute pick-up fees.

#### **Step 4: Combining Both Datasets**
- Once Spring’s data is cleaned and structured, combine it with FedEx data into a single table:
  - **Columns:** Tracking Number | Total Shipping Costs | Recipient Country | Service Type
  - Ensure the data is consistent and standardized.

---

### **Mock Example: Final Combined Table**
| Tracking Number | Total Shipping Costs | Country  | Service Type |
|-----------------|-----------------------|----------|--------------|
| FE12345         | €10.00               | Germany  | Standard      |
| FE67890         | €15.00               | France   | Express       |
| SP12345         | €10.00               | Italy    | Standard      |
| SP67890         | €12.50               | Spain    | Express       |

---
### What is  Bulk pick-up charges
**Bulk pick-up charges** are fees that a shipping provider, like Spring in this case, charges for collecting a large number of packages or shipments from a business's warehouse or storage facility. Instead of charging these costs per individual order, the provider charges a single **bulk fee** for the entire pick-up operation, regardless of the number of packages collected during that pick-up.

### Why Do Bulk Pick-Up Charges Exist?
1. **Operational Costs:** The shipping provider incurs costs for sending a vehicle, manpower, and resources to the warehouse to pick up items in bulk.
2. **Efficiency:** It simplifies billing for the provider since they do not charge for each individual package but for the entire pick-up event.
3. **High Volume Businesses:** These fees often apply to businesses shipping many orders at once, such as e-commerce companies.

---

### **Challenges with Bulk Pick-Up Charges**
- **No Direct Connection to Individual Orders:** Bulk pick-up costs aren't tied to a specific order or tracking number. This creates a challenge when trying to allocate or account for these charges across individual orders.
- **Need for Distribution:** To make sense of the total costs at an order level, these bulk charges must be fairly distributed among all the shipments picked up during that event or time period (e.g., across all shipments in a month).

---

### **How Bulk Pick-Up Charges Are Handled in the Document**
1. The total pick-up fee for a given period (e.g., a month) is **distributed proportionally** across all the orders shipped during that time.
2. For example, if the pick-up fee is €100 for 100 orders in a month, each order will get an additional cost of €1 (€100 ÷ 100 orders).
3. Some exceptions may apply:
   - Certain orders (e.g., ones starting with "1Z96") should **not** receive any additional costs from bulk pick-up fees.

---

### **Example of Bulk Pick-Up Charges**
- **Scenario:** A company ships 200 orders in a month, and Spring charges €200 for bulk pick-up.
  - Total pick-up fee: €200
  - Number of orders: 200
  - **Pick-Up Fee Per Order:** €200 ÷ 200 = €1 per order

- **Before Accounting for Bulk Pick-Up Charges:**
  | Tracking Number | Base Cost | Surcharges | Total Cost (Pre-Pick-Up) |
  |-----------------|-----------|------------|--------------------------|
  | SP12345         | €8.00     | €2.00      | €10.00                   |
  | SP67890         | €10.00    | €1.50      | €11.50                   |

- **After Distributing Bulk Pick-Up Charges:**
  | Tracking Number | Base Cost | Surcharges | Pick-Up Fee | Total Cost |
  |-----------------|-----------|------------|-------------|------------|
  | SP12345         | €8.00     | €2.00      | €1.00       | €11.00     |
  | SP67890         | €10.00    | €1.50      | €1.00       | €12.50     |

