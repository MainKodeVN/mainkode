### **Understanding Marketing Cost Allocation**

When running ads, we want to understand how much marketing money is spent for each sale made in our online store. However, tracking tools (like UTM tags or Facebook's API) don't always catch all sales accurately. Only **30% of sales** are properly tracked, even though we estimate that at least **70% of sales come from ads**. 

To solve this, we use two approaches to estimate marketing costs:

---

### **Option 1: Marketing Cost by Total Orders**
In this method, we divide the total marketing spend in a country by the total number of orders in that country for the same month. This gives us an **average cost per sale**:

\[
\text{Average Cost Per Sale} = \frac{\text{Total Marketing Spend}}{\text{Total Orders}}
\]

#### **Example:**
- **Ad Spend in U.S. (October):** $10,000  
- **Total Orders in U.S. (October):** 1,000  
\[
\text{Cost Per Sale} = \frac{10,000}{1,000} = 10 \, \text{dollars per order}
\]

#### **Pros:**
1. Covers all orders, including the ones tracking missed.
2. Simple and easy to calculate.

#### **Cons:**
1. Assumes every sale came from ads, which isn’t true (e.g., some sales may be organic or direct traffic).
2. Has an error rate of around **20%**, as not all orders are influenced by ads.

---

### **Option 2: Marketing Cost for Tracked Orders**
Here, we calculate marketing costs using only the sales that can be directly linked to specific ads using tracking data. For this, we divide the total ad spend by the number of orders tracked:

\[
\text{Cost Per Tracked Sale} = \frac{\text{Total Marketing Spend}}{\text{Tracked Orders}}
\]

#### **Example:**
- **Ad Spend in U.S. (October):** $10,000  
- **Tracked Orders in U.S. (October):** 300  
\[
\text{Cost Per Tracked Sale} = \frac{10,000}{300} = 33.33 \, \text{dollars per order}
\]

#### **Pros:**
1. Focuses only on orders you know came from ads.
2. Provides a precise cost for tracked orders.

#### **Cons:**
1. Ignores orders that tracking missed (70% of sales are underestimated).
2. Makes costs appear artificially high since only 30% of orders are tracked.

---

### **Why We Chose Option 1**
Although Option 1 assumes all orders come from ads, it's still more reliable because:
1. It includes all orders, even the ones tracking missed.
2. The insights are broader and easier to apply when planning budgets and campaigns.
3. The error margin (~20%) is smaller compared to the large underestimation in Option 2.

---

### **Step-by-Step Process for Option 1**

1. **Count Total Orders Per Month Per Country**  
   From Shopify data, count how many orders were made in each country for each month.

   **Example:**  
   - October 2023 (U.S.): 1,000 orders  
   - October 2023 (UK): 500 orders  

2. **Sum Ad Spend Per Month Per Country**  
   From Facebook Ads data, sum up the total spend for each country and month.

   **Example:**  
   - October 2023 (U.S.): $10,000  
   - October 2023 (UK): $5,000  

3. **Calculate Average Marketing Cost Per Order**  
   Divide the total ad spend by the total number of orders for each country and month.

   **Example:**  
   - **U.S. (October):**  
     \[
     \text{Cost Per Sale} = \frac{10,000}{1,000} = 10 \, \text{dollars per order}
     \]
   - **UK (October):**  
     \[
     \text{Cost Per Sale} = \frac{5,000}{500} = 10 \, \text{dollars per order}
     \]

---

### **How This Helps**
- **Marketing Efficiency:** This method shows how much you’re spending on ads for each sale, helping you optimize your budget.
- **Country-Level Insights:** You can identify high-cost or low-cost markets for better resource allocation.
- **Actionable Data:** The calculations are simple and applicable for campaign planning and performance monitoring.

--- 
