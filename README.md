# SilkStep Commerce — Analytics Platform

## Company & Role
I work as a **Data Analyst** at **SilkStep Commerce**, a mid-size Central Asian e-commerce marketplace connecting customers with vetted third-party sellers (electronics, home & living, beauty, apparel).

## Project Overview
This repository contains the PostgreSQL-based analytics environment used at SilkStep Commerce.  
It covers the full pipeline:

- Importing raw marketplace CSVs into a relational schema  
- Running validation checks (PK/FK constraints, data types)  
- Writing SQL queries to answer key business questions  
- Building Python-powered reporting with static charts, interactive visualizations, and Excel exports for stakeholders  

---

## Main Analytics (screenshot)

![Main analytics](images/main-analytics.png)

## ER Diagram

![ER Diagram](er/er-diagram.png)

---

## Dataset
Internal SilkStep order, CRM and logistics data (structured similar to the public Fecom dataset on Kaggle).  
Contains customers, orders, order items, sellers, payments, reviews, and geolocation information.

---

## Key Analytics & Deliverables

### SQL Business Queries
Every SQL query combines multiple tables with **2+ JOINs** to reflect real business questions rather than just IDs. Examples:

- **Revenue share by product category**  
- **Top sellers by delivered revenue**  
- **Average review scores by category (with thresholds)**  
- **Daily delivered revenue trends**  
- **Distribution of order values**  
- **Price vs. review correlation at product level**  
- **Monthly revenue by country**

### Static Reporting (matplotlib)
- Pie, bar, horizontal bar, line, histogram, scatter plots  
- All charts saved to `/charts/`  
- Each chart has clear **title, axis labels, legend (if applicable)**  
- Console output summarises row counts and purpose of each chart  

### Interactive Reporting (Plotly)
- Monthly revenue by country with a **time slider** (`animation_frame="month"`)  
- Opens in browser as an HTML dashboard (`charts/timeslider_revenue_by_country.html`)  
- Used in stakeholder demos to interactively explore revenue trends  

### Excel Exports (openpyxl)
- All DataFrames exported to `/exports/`  
- **Formatting included:**  
  - Frozen headers and first column  
  - Filters on all columns  
  - Conditional formatting (gradient min→mid→max)  
- Console log example:  
  ```text
  Created file analytics_export.xlsx, 6 sheets, 1234 rows
