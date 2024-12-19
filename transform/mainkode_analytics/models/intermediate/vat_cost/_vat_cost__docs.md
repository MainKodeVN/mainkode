### **Document: VAT Fee Calculation Pipeline**

#### **Overview**
The VAT fee calculation pipeline aims to compute VAT fees for e-commerce orders across multiple countries, incorporating country-specific rules and handling complexities such as refunds and exchange rates. This document outlines the theoretical approach and steps involved in modeling the VAT fees.

---

### **Key Concepts**

1. **Value-Added Tax (VAT):**
   - VAT is a consumption tax applied to the value added to goods and services. It is calculated as a percentage of the sale price.

2. **Country-Specific Rules:**
   - Different countries have different VAT rates, which may vary year by year.
   - Specific rules, such as the UK's handling of orders exceeding a certain threshold, require additional logic.

3. **Refunds:**
   - VAT is only applicable to revenue generated after deducting refunds. Orders with partial or full refunds need adjustments in the VAT calculation.

4. **Exchange Rates:**
   - When applying VAT rules based on thresholds (e.g., 135 pounds in the UK), dynamic currency conversion is required to compare order values in a consistent currency.

---

### **Challenges**

1. **Handling Refunds:**
   - Refund data must be extracted and applied to calculate the effective order value.
   - Refund statuses (e.g., "pending" or "success") influence how refunds are treated.

2. **Dynamic VAT Rates:**
   - VAT rates vary by country and fiscal year, requiring a lookup from a VAT rates table.

3. **UK-Specific Rules:**
   - For orders originating in the UK:
     - VAT is charged only if the order value (excluding shipping) is below 135 pounds (converted to EUR).
     - For orders above this threshold, VAT is paid by the client, and no additional VAT fee is applied.

---

### **Theoretical Steps**

#### **Step 1: Extract and Process Transactions**
- **Input:** Raw transactions data, including financial details such as fees, refunds, and exchange rates.
- **Goal:** Extract relevant data fields and clean JSON structures for accurate processing.
- **Output:** A table containing parsed financial data such as refund amounts and exchange rates.

#### **Step 2: Calculate Refund Amounts**
- **Input:** Transactions data filtered for refunds and the main orders table.
- **Logic:**
  - Identify refunds where the transaction type is "REFUND" and the status is "SUCCESS" or "PENDING."
  - Assign a default refund value of zero if no refund exists.
- **Output:** A refund table linking each order to its refund amount.

#### **Step 3: Match Orders with VAT Rates**
- **Input:** Orders table and VAT rates table.
- **Logic:**
  - Match each order’s country code and fiscal year to the corresponding VAT rate.
- **Output:** A table with VAT rates associated with each order.

#### **Step 4: Calculate VAT Fees**
- **Input:** Orders table, VAT rates table, and refunds table.
- **Logic:**
  - **No VAT Countries:** Assign a VAT fee of 0 for countries without VAT.
  - **Non-UK Countries:** VAT fee = (Post-refund order value) × (VAT rate).
  - **UK Orders:**
    - Calculate the order value excluding shipping and post-refunds.
    - Convert 135 pounds to EUR dynamically using the formula:
      \[
      \text{Threshold in EUR} = 135 \times \frac{\text{Gross Sales in EUR}}{\text{Gross Sales in Local Currency}}
      \]
    - If the post-refund order value (excluding shipping) is below this threshold, apply the VAT rate.
    - Otherwise, set the VAT fee to 0, as VAT is paid by the client.
- **Output:** A table with calculated VAT fees for each order.

---

### **Special Case: UK VAT Calculation**
- **Threshold Logic:**
  - Compare the order value (post-refunds, excluding shipping) to the 135-pound threshold in EUR.
- **Dynamic Conversion:**
  - Use real-time exchange rates from order data to dynamically calculate the threshold.
- **VAT Rules:**
  - If the order value exceeds the threshold, VAT is paid by the client, and the fee is 0.
  - If below the threshold, VAT is calculated as a percentage of the order value.
