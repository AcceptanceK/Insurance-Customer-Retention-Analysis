WITH ranked_premiums AS (
    SELECT
        policy_id,
        monthly_premium,
        ROW_NUMBER() OVER (
            PARTITION BY policy_id
            ORDER BY effective_date DESC, premium_record_id DESC
        ) AS premium_rank
    FROM premium_history
),
premium_flags AS (
    SELECT
        policy_id,
        CASE
            WHEN MAX(monthly_premium) FILTER (WHERE premium_rank = 1)
               > MAX(monthly_premium) FILTER (WHERE premium_rank = 2)
            THEN 1 ELSE 0
        END AS increase_flag
    FROM ranked_premiums
    WHERE premium_rank <= 2
    GROUP BY policy_id
),
claim_flags AS (
    SELECT
        policy_id,
        MAX(CASE WHEN claim_status = 'Rejected' THEN 1 ELSE 0 END) AS rejected_flag
    FROM claims
    GROUP BY policy_id
),
payment_flags AS (
    SELECT
        policy_id,
        MAX(CASE WHEN payment_status = 'Missed' THEN 1 ELSE 0 END) AS missed_flag
    FROM premium_payments
    GROUP BY policy_id
)
SELECT
    COALESCE(pf.increase_flag, 0)
      + COALESCE(cf.rejected_flag, 0)
      + COALESCE(mf.missed_flag, 0)                            AS risk_signals,
    COUNT(*)                                                   AS total_policies,
    COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')      AS cancelled_policies,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')
        / COUNT(*),
        1
    )                                                          AS cancellation_rate
FROM policies p
LEFT JOIN premium_flags pf ON pf.policy_id = p.policy_id
LEFT JOIN claim_flags   cf ON cf.policy_id = p.policy_id
LEFT JOIN payment_flags mf ON mf.policy_id = p.policy_id
GROUP BY 1
ORDER BY risk_signals DESC;