WITH policy_payments AS (
    SELECT
        policy_id,
        COUNT(payment_id)                                        AS payment_count,
        COUNT(*) FILTER (WHERE payment_status = 'Missed')        AS missed_count
    FROM premium_payments
    GROUP BY policy_id
)
SELECT
    CASE
        WHEN pp.missed_count > 0   THEN 'Missed Payments'
        WHEN pp.payment_count > 0  THEN 'No Missed Payments'
        ELSE 'No Payment Records'
    END                                                          AS payment_group,
    COUNT(*)                                                     AS total_policies,
    COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')        AS cancelled_policies,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')
        / COUNT(*),
        1
    )                                                            AS cancellation_rate
FROM policies p
LEFT JOIN policy_payments pp
    ON pp.policy_id = p.policy_id
GROUP BY 1
ORDER BY cancellation_rate DESC;