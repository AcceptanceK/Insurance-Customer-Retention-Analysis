WITH customer_policies AS (
    SELECT
        c.customer_id,
        COUNT(p.policy_id)                                     AS total_policies,
        COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')  AS cancelled_policies
    FROM customers c
    LEFT JOIN policies p
        ON p.customer_id = c.customer_id
    GROUP BY c.customer_id
)
SELECT
    CASE
        WHEN total_policies = 0                    THEN 'No Policies'
        WHEN cancelled_policies = 0                THEN 'Fully Active'
        WHEN cancelled_policies = total_policies   THEN 'Fully Cancelled'
        ELSE 'Partially Cancelled'
    END                                            AS customer_status,
    COUNT(*)                                       AS total_customers,
    SUM(total_policies)                            AS total_policies,
    SUM(cancelled_policies)                        AS cancelled_policies
FROM customer_policies
GROUP BY 1
ORDER BY total_customers DESC;