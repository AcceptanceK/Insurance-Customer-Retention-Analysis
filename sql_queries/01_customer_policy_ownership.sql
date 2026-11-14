WITH customer_policies AS (
    SELECT
        c.customer_id,
        COUNT(p.policy_id) AS policy_count
    FROM customers c
    LEFT JOIN policies p
        ON p.customer_id = c.customer_id
    GROUP BY c.customer_id
)
SELECT
    COUNT(*)                                          AS total_customers,
    COUNT(*) FILTER (WHERE policy_count = 1)          AS customers_with_one_policy,
    COUNT(*) FILTER (WHERE policy_count > 1)          AS customers_with_multiple_policies,
    COUNT(*) FILTER (WHERE policy_count = 0)          AS customers_without_policies
FROM customer_policies;