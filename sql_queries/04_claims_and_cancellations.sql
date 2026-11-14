WITH policy_claims AS (
    SELECT
        policy_id,
        COUNT(claim_id)                                      AS claim_count,
        COUNT(*) FILTER (WHERE claim_status = 'Rejected')    AS rejected_count
    FROM claims
    GROUP BY policy_id
)
SELECT
    CASE
        WHEN pc.rejected_count > 0  THEN 'Rejected Claim'
        WHEN pc.claim_count > 0     THEN 'Other Claims'
        ELSE 'No Claims'
    END                                                         AS claim_experience,
    COUNT(*)                                                    AS total_policies,
    COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')       AS cancelled_policies,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE p.policy_status = 'Cancelled')
        / COUNT(*),
        1
    )                                                           AS cancellation_rate
FROM policies p
LEFT JOIN policy_claims pc
    ON pc.policy_id = p.policy_id
GROUP BY 1
ORDER BY cancellation_rate DESC;