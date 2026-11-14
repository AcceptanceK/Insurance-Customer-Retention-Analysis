# South African Insurance Customer Retention & Policy Cancellation Analysis

## Project Overview

A fictional South African short-term insurer wants to understand which customers and policies are being lost, how premium changes, claims and payment behaviour relate to cancellations, and where retention efforts could have the most impact.

**Business objective:** Analyse policy cancellations separately from complete customer loss, identify patterns associated with cancellations, and recommend targeted retention opportunities.

## Tools and Data

- **Tools:** PostgreSQL and DBeaver
- **Data:** Fictional South African short-term insurance records; monetary values are in South African rand (ZAR)
- **Dataset snapshot:** 31 October 2026
- **Tables:** `customers` (320), `policies` (460), `premium_history` (901), `claims` (156), and `premium_payments` (4,215)
- **Analysis:** Eight SQL business questions
- **Insurance products:** Vehicle, Home, Contents and Personal Accident

`customers.customer_id` links customers to policies. The policy-level tables (`premium_history`, `claims` and `premium_payments`) link to `policies` through `policy_id`.

## Executive Summary

### Customer Retention

Of **460 policies**, **71 (15.4%)** were cancelled, but only **29 of 320 customers (9.1%)** had lost all their insurance cover. A further **37 customers** cancelled some policies while keeping other cover active; **254 customers** had no cancellations.

**Mass Market** had the highest policy cancellation rate (**17.4%**) and accounted for **18 of the 29** customers who lost all their cover. Affluent followed at **15.6%**, while Premium was lowest at **4.8%**.

### Cancellation-Related Warning Signs

- **Rejected claims:** Policies with at least one rejected claim had a **31.4%** cancellation rate, versus **14.6%** for policies with no claims and **12.5%** for policies with other claims.
- **Premium increases:** Policies with an increase had a **16.6%** cancellation rate, versus **9.3%** for policies with no increase.
- **Missed payments:** Policies with at least one missed payment had an **18.3%** cancellation rate, versus **11.2%** for policies without missed payments.
- **Combined signals:** Cancellation rates rose from **3.1%** for policies with zero signals to **10.2%** with one, **19.9%** with two, and **25.0%** with three. **53 of 71 cancellations (75%)** involved policies with at least two signals.

These are **observed associations**, not proof that a particular event caused cancellation or validated predictions of future churn. The timing of signals relative to cancellation has not been established.

### Strategic Priorities

Prioritise investigating **Mass Market** cancellations, followed by **Affluent**. Contact **partially cancelled customers** to understand why they dropped cover and protect their remaining policies. Investigate **active policies with multiple warning signs** for potential early intervention.

Before automating alerts, check the timing of premium changes, missed payments and rejected claims; distinguish customer-initiated cancellations from insurer-initiated cancellations; and examine cancellation reasons, policy mix and premium income. Pilot early payment reminders, flexible payment dates and clearer claims communication before wider rollout.

## SQL Analyses

| # | Business question | SQL query | CSV result |
|---|---|---|---|
| 01 | How many customers own one or multiple policies? | [sql_queries](sql_queries/01_customer_policy_ownership.sql) | [results](results/01_customer_policy_ownership.csv) |
| 02 | Which insurance products have the highest cancellation rates? | [sql_queries](sql_queries/02_cancellations_by_product.sql) | [results](results/02_cancellations_by_product.csv) |
| 03 | How are premium increases associated with cancellations? | [sql_queries](sql_queries/03_premium_increases_and_cancellations.sql) | [results](results/03_premium_increases_and_cancellations.csv) |
| 04 | How does claims experience relate to cancellations? | [sql_queries](sql_queries/04_claims_and_cancellations.sql) | [Results](results/04_claims_and_cancellations.csv) |
| 05 | Are missed payments associated with more cancellations? | [sql_queries](sql_queries/05_missed_payments_and_cancellations.sql) | [results](results/05_missed_payments_and_cancellations.csv) |
| 06 | How many customers retain cover after cancelling a policy? | [sql_queries](sql_queries/06_customer_retention_status.sql) | [results](results/06_customer_retention_status.csv) |
| 07 | How do combined warning signs relate to cancellation rates? | [sql_queries](sql_queries/07_combined_retention_risk_signals.sql) | [results](results/07_combined_retention_risk_signals.csv) |
| 08 | Which customer segments have the most cancellations and complete customer losses? | [sql_queries](sql_queries/08_retention_by_customer_segment.sql) | [results](results/08_retention_by_customer_segment.csv) |

For detailed business insights and recommendations for each analysis, see [business_insights](business_insights/key_findings.md).

## SQL Skills Demonstrated

- Joining customer, policy, premium, claim and payment data with **`LEFT JOIN`**
- Summarising customer and policy KPIs using **`COUNT`**, **`SUM`**, **`GROUP BY`** and conditional **`FILTER`**
- Building multi-step analyses using **common table expressions (`WITH`)**
- Comparing premium records with **`ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)`**
- Classifying customer status and warning signs using **`CASE WHEN`**
- Handling missing values with **`COALESCE`** and preventing division by zero with **`NULLIF`**
- Calculating cancellation rates without double-counting policies across one-to-many tables

## Project Structure

```text
sa-insurance-customer-retention-analysis/
├── README.md
├── business_insights/
│   └── key_findings.md
├── sql_queries/
│   ├── 01_customer_policy_ownership.sql
│   ├── 02_cancellations_by_product.sql
│   ├── 03_premium_increases_and_cancellations.sql
│   ├── 04_claims_and_cancellations.sql
│   ├── 05_missed_payments_and_cancellations.sql
│   ├── 06_customer_retention_status.sql
│   ├── 07_combined_retention_risk_signals.sql
│   └── 08_retention_by_customer_segment.sql
└── results/
    ├── 01_customer_policy_ownership.csv
    ├── 02_cancellations_by_product.csv
    ├── 03_premium_increases_and_cancellations.csv
    ├── 04_claims_and_cancellations.csv
    ├── 05_missed_payments_and_cancellations.csv
    ├── 06_customer_retention_status.csv
    ├── 07_combined_retention_risk_signals.csv
    └── 08_retention_by_customer_segment.csv
```

## Limitations

- This is a **fictional, static dataset**, not a live insurance portfolio.
- Cancellation rates are calculated from the recorded policy statuses; they are **not annualised churn rates**.
- The analyses do not establish the sequence of all warning signs and cancellations, so they cannot establish causation or predictive effectiveness.
- A customer cancelling one policy is not necessarily a customer leaving the insurer; customer-level retention is calculated separately.
- Some groups, particularly the Premium segment and the three-warning-sign group, are small, so their rates should be interpreted cautiously.

## Data Privacy

All customers, policies, payments and claims in this project are fictional and intended for SQL learning and portfolio demonstration.
