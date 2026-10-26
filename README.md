# Superstore Sales & Profitability Analysis

**A SQL Server exploratory analysis of what drives profit, where performance varies, and which business questions deserve a closer look.**

This project turns Superstore order, manager, and return data into a set of business-focused SQL analyses and a concise findings report. It examines product profitability, customer segments, regional performance, discount patterns, and order returns—with a focus on distinguishing observed patterns from conclusions the data cannot prove.

> **Portfolio highlight:** Tables generated **$208.0K in sales but lost $17.8K** (a **-8.53% margin**), while the West had an **11.56% order return rate** compared with **5.79% overall**. These results are investigation priorities, not proof of what caused the losses or returns.

## Project deliverables

- [SQL Server setup and data-loading script](scripts/ddl_script.sql)
- [Exploratory analysis queries](scripts/eda_script.sql)
- [Analysis findings and recommendations (PDF)](Superstore_Sales_Profitability_Analysis_Report.pdf)
- Source data in [`datasets/`](datasets/)

## Business questions

- Which product subcategories generate meaningful sales but weak or negative profit?
- How does profit contribution differ across customer segments?
- Does product profitability vary by region?
- How are discount levels associated with profit and margin?
- What proportion of distinct orders were returned, and where are returns concentrated?

## Selected findings

| Area | Finding | Why it matters |
|---|---|---|
| Product profitability | **Tables:** $208,020 sales, -$17,753 profit, **-8.53% margin** | High sales do not necessarily translate into profit; investigate product mix, costs, and discounts. |
| Product profitability | **Bookcases:** -3.15% margin; **Supplies:** -2.51% margin | Loss-making subcategories merit a closer look at product- and transaction-level performance. |
| Thin margins | **Machines:** $189,925 sales, $3,462 profit, **1.82% margin** | A profitable category can still retain little profit relative to revenue. |
| Discount patterns | In the observed data, displayed discount levels of **30% and above** had negative aggregate profit; the 10% and 20% groups had positive aggregate profit. | Review high-discount transactions and business context; this association does not establish causation or justify a blanket discount cap. |
| Returns | **296 of 5,111 distinct orders** were marked returned: **5.79% overall**. The West was **11.56%** (189 of 1,635 orders). | The West is a clear signal for follow-up; investigate returned orders by product, shipping mode, and time period where the data supports it. |
| Customer segments | Consumer contributed **46.66%** of total profit; Consumer and Corporate together contributed **78.90%**. | Profit contribution is not the same as profit margin; compare both before judging segment efficiency. |

These are exploratory results from the included dataset. Discount patterns are associations, not causal evidence. Return rates are calculated at the **order level**, not the item or unit level. An order-level return cannot identify which item was returned when the order contains multiple products.

## Analysis approach

The project uses SQL Server queries to:

- Aggregate sales and profit by subcategory, segment, region, category, and discount.
- Calculate profit margin as profit divided by sales, with `NULLIF` to guard against division by zero.
- Use a window function to calculate each customer segment's share of total profit.
- Compare distinct orders with returned order IDs to calculate order-level return rates.
- Use common table expressions and `UNION ALL` to compare return rates across multiple dimensions.

## Tools and skills demonstrated

- **Microsoft SQL Server / T-SQL**
- Relational table design and CSV data loading with `BULK INSERT`
- Exploratory data analysis and business-focused question framing
- Aggregations, grouping, joins, CTEs, window functions, and conditional-safe calculations
- Interpreting metrics, documenting limitations, and translating results into next steps

## Repository structure

```text
.
├── datasets/
│   ├── orders.csv
│   ├── people.csv
│   ├── returns.csv
│   └── sample_superstore.xls
├── scripts/
│   ├── ddl_script.sql
│   └── eda_script.sql
├── Superstore_Sales_Profitability_Analysis_Report.pdf
└── README.md
```

## Run the analysis

### Requirements

- Microsoft SQL Server
- SQL Server Management Studio (SSMS) or another SQL Server-compatible query editor
- Access to the CSV files from the SQL Server database engine

### Steps

1. Clone or download this repository.
2. Open [`scripts/ddl_script.sql`](scripts/ddl_script.sql) in SSMS.
3. Update each `BULK INSERT` file path in that script to the absolute path of the corresponding CSV on your machine.
4. Ensure the SQL Server service account can read those files and has the permissions required to run `BULK INSERT`.
5. Execute the DDL and loading script once to create the `SuperStore` database, its tables, and load the data.
6. Open and execute [`scripts/eda_script.sql`](scripts/eda_script.sql) against the loaded database.
7. Compare query results with the [PDF report](Superstore_Sales_Profitability_Analysis_Report.pdf).

The scripts use the database name `SuperStore` and the table names `dbo.orders`, `dbo.people`, and `dbo.returns`. The setup script creates these tables and loads data; if you need to run the setup again, remove or otherwise manage the existing tables first to avoid table-already-exists errors.

## Recommendations from the analysis

1. **Investigate loss-making subcategories.** Start with Tables and Bookcases; inspect product-level profit, discount, cost, and regional patterns.
2. **Review high-discount transactions.** Understand why discounts of 30% or more were applied and assess profitability in context before changing discount policy.
3. **Investigate the West's return rate.** Break down returned orders by product or category, shipping mode, and time period where the available data allows.
4. **Compare profit contribution with margin.** A segment's share of total profit alone does not show its profitability per sales dollar.
5. **Validate regional product observations.** Capture exact region-by-subcategory metrics before treating patterns such as Furnishings in Central as established findings.

## Scope and limitations

- The analysis is exploratory and describes patterns in the supplied data; it does not establish causation.
- The returns file identifies returned **order IDs**, not the specific returned products or quantities.
- A returned order may contain items from multiple categories, so category-level order return rates may overlap.
- Regional subcategory observations should be checked against the detailed SQL output before being used to support targeted decisions.

---

**Interested in how I approach business analysis?** Start with the [EDA queries](scripts/eda_script.sql) and [findings report](Superstore_Sales_Profitability_Analysis_Report.pdf): together, they show the path from business questions to measurable insights and cautious, actionable recommendations.
