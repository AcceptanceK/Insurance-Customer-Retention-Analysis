WITH customer_policies AS (
    SELECT
        c.customer_id,
        c.customer_segment,
        COUNT(p.policy_id)                                     AS total_policies,
        COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')  AS cancelled_policies
    FROM customers c
    LEFT JOIN policies p
        ON p.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_segment
)
SELECT
    customer_segment,
    COUNT(*)                                                   AS total_customers,
    SUM(total_policies)                                        AS total_policies,
    SUM(cancelled_policies)                                    AS cancelled_policies,
    ROUND(
        100.0 * SUM(cancelled_policies)
        / NULLIF(SUM(total_policies), 0),
        1
    )                                                          AS cancellation_rate,
    COUNT(*) FILTER (
        WHERE total_policies > 0
          AND cancelled_policies = total_policies
    )                                                          AS fully_cancelled_customers
FROM customer_policies
GROUP BY customer_segment
ORDER BY cancellation_rate DESC NULLS LAST;