SELECT
    product_type,
    COUNT(policy_id)                                           AS total_policies,
    COUNT(*) FILTER (WHERE policy_status = 'Active')           AS active_policies,
    COUNT(*) FILTER (WHERE policy_status = 'Cancelled')        AS cancelled_policies,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE policy_status = 'Cancelled')
        / NULLIF(COUNT(policy_id), 0),
        1
    )                                                          AS cancellation_rate
FROM policies
GROUP BY product_type
ORDER BY cancellation_rate DESC NULLS LAST,
         total_policies DESC;