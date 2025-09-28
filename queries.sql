-- queries.sql — Assignment #2 (SilkStep / FecomDB, PostgreSQL)

----------------------------------------------------------------
-- name: pie_revenue_by_category
-- Pie: доля выручки по категориям (delivered), топ-10 + "Other"
WITH delivered AS (
  SELECT order_id FROM orders WHERE order_status = 'delivered'
),
by_cat AS (
  SELECT p.product_category AS category,
         SUM(oi.price) AS revenue
  FROM order_items oi
  JOIN delivered d ON d.order_id = oi.order_id
  JOIN products  p ON p.product_id = oi.product_id
  GROUP BY 1
),
ranked AS (
  SELECT category, revenue,
         ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rn
  FROM by_cat
)
SELECT CASE WHEN rn <= 10 THEN category ELSE 'Other' END AS category,
       SUM(revenue) AS revenue
FROM ranked
WHERE revenue > 0
GROUP BY 1
ORDER BY revenue DESC;

----------------------------------------------------------------
-- name: bar_top_sellers_by_revenue
-- Bar: топ-10 продавцов по выручке (delivered)
SELECT s.seller_id,
       COALESCE(s.seller_city, 'N/A') AS seller_city,
       ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
JOIN orders  o ON o.order_id = oi.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_city
ORDER BY revenue DESC
LIMIT 10;

----------------------------------------------------------------
-- name: barh_avg_review_by_category
-- BarH: средняя оценка отзывов по категориям (порог ≥50), топ-20
WITH base AS (
  SELECT p.product_category AS category, r.review_score
  FROM order_reviews r
  JOIN orders      o  ON o.order_id = r.order_id
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN products    p  ON p.product_id = oi.product_id
  WHERE r.review_score BETWEEN 1 AND 5
),
agg AS (
  SELECT category,
         ROUND(AVG(review_score), 3) AS avg_score,
         COUNT(*) AS n_reviews
  FROM base
  GROUP BY category
)
SELECT category, avg_score, n_reviews
FROM agg
WHERE n_reviews >= 50
ORDER BY avg_score DESC, n_reviews DESC
LIMIT 20;

----------------------------------------------------------------
-- name: line_daily_revenue
-- Line: дневная выручка по доставленным заказам
SELECT DATE(o.order_purchase_timestamp) AS day,
       SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers c    ON c.customer_trx_id = o.customer_trx_id  
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1 ASC;

----------------------------------------------------------------
-- name: hist_order_value
-- Hist: распределение стоимости заказа (сумма позиций) среди delivered
WITH ov AS (
  SELECT oi.order_id, SUM(oi.price) AS order_value
  FROM order_items oi
  GROUP BY 1
)
SELECT ov.order_value
FROM ov
JOIN orders o    ON o.order_id = ov.order_id
JOIN customers c ON c.customer_trx_id = o.customer_trx_id  -- 2-й JOIN
WHERE o.order_status = 'delivered';
----------------------------------------------------------------
-- name: scatter_price_vs_review
-- Scatter: средняя цена товара vs средняя оценка (порог ≥30 заказов)
WITH product_stats AS (
  SELECT p.product_id,
         p.product_category AS category,
         AVG(oi.price) AS avg_price,
         COUNT(DISTINCT oi.order_id) AS n_orders
  FROM order_items oi
  JOIN products p ON p.product_id = oi.product_id
  GROUP BY 1, 2
),
review_stats AS (
  SELECT p.product_id,
         AVG(r.review_score) AS avg_review
  FROM order_reviews r
  JOIN orders      o  ON o.order_id = r.order_id
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN products    p  ON p.product_id = oi.product_id
  WHERE r.review_score BETWEEN 1 AND 5
  GROUP BY 1
)
SELECT ps.avg_price, rs.avg_review, ps.category, ps.n_orders
FROM product_stats ps
JOIN review_stats rs ON rs.product_id = ps.product_id
WHERE ps.n_orders >= 30;

----------------------------------------------------------------
-- name: timeslider_monthly_revenue_by_country
-- Plotly time slider: помесячная выручка по странам покупателей
SELECT to_char(o.order_purchase_timestamp, 'YYYY-MM') AS month,
       c.customer_country AS country,
       ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers c    ON c.customer_trx_id = o.customer_trx_id
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
ORDER BY month ASC, revenue DESC;
