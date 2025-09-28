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

![Main analytics](images/01_pie_revenue_by_category.png) 
![](images/02_bar_top_sellers_by_revenue.png)
![](images/03_barh_avg_review_by_category.png)

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


## How to Run

### Requirements
- PostgreSQL (local or containerized)  
- Python 3.11+  
- Libraries:  
  - `pandas`  
  - `matplotlib`  
  - `plotly`  
  - `sqlalchemy`  
  - `openpyxl`  
  - `psycopg2`  

### Setup
```bash
pip install -r requirements.txt

How to Run
Requirements

PostgreSQL (local or containerized)

Python 3.11+

Libraries:

pandas

matplotlib

plotly

sqlalchemy

openpyxl

psycopg2

Setup
pip install -r requirements.txt

Configure connection in config.py
SQLALCHEMY_DATABASE_URL = "postgresql+psycopg2://postgres:YOUR_PASSWORD@127.0.0.1:5433/fecomdb"

Generate All Reports
python analytics.py

Run a Specific Chart
python -c "from analytics import chart_barh; chart_barh()"

Launch Interactive Time Slider
python -c "from analytics import show_time_slider; show_time_slider()"

Live Demo Workflow

During internal demos, we often prove that the analytics layer is connected to live production data:

Generate a chart (e.g., daily revenue).

Insert a new order into the DB.

Regenerate the chart → the new point immediately appears.

This workflow builds trust with stakeholders by showing that dashboards update directly from transactions.

Example demo script (safe transaction + rollback):

BEGIN;

INSERT INTO orders (order_id, customer_trx_id, order_status, order_purchase_timestamp)
VALUES ('demo_order_001', (SELECT customer_trx_id FROM customers LIMIT 1), 'delivered', NOW());

INSERT INTO order_items (order_id, order_item_id, product_id, seller_id, price)
VALUES ('demo_order_001', 1, (SELECT product_id FROM products LIMIT 1),
        (SELECT seller_id FROM sellers LIMIT 1), 99.90);

INSERT INTO order_reviews (review_id, order_id, review_score, review_creation_date)
VALUES ('demo_review_001', 'demo_order_001', 5, NOW());

-- regenerate chart here

ROLLBACK;

Technical Stack

PostgreSQL — OLTP + analytics schema

SQLAlchemy — connection and query management

pandas — tabular analytics, ETL

matplotlib — static reports

plotly — interactive visualizations

openpyxl — Excel exports with corporate formatting

All charts follow a consistent style: titles, axis labels, readable scales, and legends where appropriate.
Outliers are capped at the 99th percentile for clarity.
