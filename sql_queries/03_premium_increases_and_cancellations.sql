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
premium_compare AS (
    SELECT
        policy_id,
        MAX(monthly_premium) FILTER (WHERE premium_rank = 1) AS latest_premium,
        MAX(monthly_premium) FILTER (WHERE premium_rank = 2) AS previous_premium
    FROM ranked_premiums
    WHERE premium_rank <= 2
    GROUP BY policy_id
)
SELECT
    CASE
        WHEN pc.previous_premium IS NULL                THEN 'No Previous Premium'
        WHEN pc.latest_premium > pc.previous_premium    THEN 'Increased'
        ELSE 'No Increase'
    END                                                          AS premium_change_group,
    COUNT(*)                                                     AS total_policies,
    COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')        AS cancelled_policies,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')
        / COUNT(*),
        1
    )                                                            AS cancellation_rate
FROM policies p
LEFT JOIN premium_compare pc
    ON pc.policy_id = p.policy_id
GROUP BY 1
ORDER BY cancellation_rate DESC;