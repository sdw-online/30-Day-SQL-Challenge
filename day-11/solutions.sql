-- ============================================
-- DAY 11 SOLUTIONS: CASE WHEN
-- ============================================

-- Task 1: Classify by priority
SELECT
    claim_id,
    claimant_name,
    incident_type,
    claim_amount,
    CASE
        WHEN claim_amount >= 10000 THEN 'High'
        WHEN claim_amount >= 2500  THEN 'Medium'
        ELSE 'Low'
    END AS priority
FROM insurance_claims;

-- Task 2: Label incident types
SELECT
    claim_id,
    claimant_name,
    incident_type,
    CASE incident_type
        WHEN 'auto'      THEN 'Motor Vehicle'
        WHEN 'home'      THEN 'Property'
        WHEN 'health'    THEN 'Medical'
        WHEN 'travel'    THEN 'Travel'
        WHEN 'liability' THEN 'Liability'
    END AS incident_label
FROM insurance_claims;

-- Task 3: Flag SLA breaches
SELECT
    claim_id,
    claimant_name,
    response_hours,
    CASE
        WHEN response_hours > 48  THEN 'Breached'
        WHEN response_hours <= 48 THEN 'Within SLA'
        ELSE 'Not recorded'
    END AS sla_status
FROM insurance_claims;

-- Task 4: Count by priority band
SELECT
    COUNT(CASE WHEN claim_amount >= 10000 THEN 1 END) AS high_count,
    COUNT(CASE WHEN claim_amount >= 2500 AND claim_amount < 10000 THEN 1 END) AS medium_count,
    COUNT(CASE WHEN claim_amount < 2500 THEN 1 END)   AS low_count
FROM insurance_claims;

-- Task 5: Full triage report
SELECT
    claim_id,
    claimant_name,
    CASE incident_type
        WHEN 'auto'      THEN 'Motor Vehicle'
        WHEN 'home'      THEN 'Property'
        WHEN 'health'    THEN 'Medical'
        WHEN 'travel'    THEN 'Travel'
        WHEN 'liability' THEN 'Liability'
    END AS incident_label,
    claim_amount,
    CASE
        WHEN claim_amount >= 10000 THEN 'High'
        WHEN claim_amount >= 2500  THEN 'Medium'
        ELSE 'Low'
    END AS priority,
    CASE
        WHEN response_hours > 48  THEN 'Breached'
        WHEN response_hours <= 48 THEN 'Within SLA'
        ELSE 'Not recorded'
    END AS sla_status
FROM insurance_claims
ORDER BY
    CASE
        WHEN claim_amount >= 10000 THEN 1
        WHEN claim_amount >= 2500  THEN 2
        ELSE 3
    END,
    claim_amount DESC;
