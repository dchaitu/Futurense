

SHOW DATABASES;
USE `kalpa_plus`;
DESCRIBE `member_events`;
SHOW TABLES FROM `kalpa_plus`;

-- SELECT * FROM members
-- WHERE channel='EMAIL'
-- ORDER BY event_cost
-- ;

-- No of Renewals in each city

-- Find total renewal amt when for each city only when the renewal fee >1500
select city,sum(annual_fee) FROM
members
Where annual_fee>1500
group by city;

-- Find the total renerwal amt of those vitie with total renewal fee >5000
select city,sum(annual_fee) as total_fee FROM
members
Where annual_fee>1500
group by city
Having total_fee>5000;

# Using member_events, find the channels where members made at least 500 failed payment attempts.
# For each channel, show:
# - Number of failed payment attempts.
# - Number of distinct members who made those attempts.
# - Total event cost of those failed attempts.
# Include only events where event_type = 'PAYMENT_ATTEMPT' and outcome = 'FAILED'.
# Sort the result by failed payment attempts, highest first.

SELECT channel, sum(event_cost) as total_event_cost, count(distinct member_id) as unique_members
FROM member_events
where event_type = 'PAYMENT_ATTEMPT' and outcome = 'FAILED'
GROUP BY channel
HAVING count(event_id)>=500;

# Using renewal_opportunities, examine renewals due in September 2026.
# For each renewal_number, show:
# - Number of renewal opportunities.
# - Total renewal fees.
# - Average renewal fee.
# Show only groups with at least 1,000 renewal opportunities, sorted by total renewal fees, highest first.
# Use expiry_date to identify the month.
# Think: Do these fees represent money actually collected, or amounts members were due to pay?

SELECT renewal_number, Count(*) as total_reneval_opportunities, sum(renewal_fee) as total_renewal_fees, avg(renewal_fee) as avg_renewal_fees
FROM renewal_opportunities
-- WHERE expiry_date>='2026-09-01' and expiry_date<= '2026-10-01'
WHERE expiry_date BETWEEN '2026-09-01' AND '2026-10-01'
GROUP BY renewal_number
HAVING total_reneval_opportunities >=1000
ORDER BY total_renewal_fees desc;


# Kalpa’s team says: “Payment failures are the main reason members are not renewing. We should fix payments before offering discounts.”
# Using member_events, investigate whether the data supports this claim.
# Decide which comparisons matter, present evidence, and recommend what Kalpa should investigate first.
# What can this table establish—and what would you still need to know before accepting the claim?
SELECT outcome, count(*)
FROM member_events
GROUP BY outcome

-- HAVING event_type="PAYMENT_ATTEMPT"
;

SELECT event_type,outcome, count(*), sum(amount)
FROM member_events
GROUP BY outcome,event_type
;

SELECT event_type,outcome, count(*), sum(amount)
FROM member_events
WHERE event_type="PAYMENT_ATTEMPT"
GROUP BY outcome,event_type


;

SELECT member_id, renewal_number,
COUNT(*) 
FROM renewal_opportunities
GROUP BY member_id, renewal_number
HAVING COUNT(*)>1; 

SELECT member_id, expiry_date,
COUNT(*) 
FROM renewal_opportunities
GROUP BY member_id, expiry_date
HAVING COUNT(*)>1; 


-- every member_id comes with a renewal_id (first, second, third), every renewal 
-- is coming with expiry and deadline date, every renewal has a renewal fee and discount

SELECT member_id, count(expiry_date),count(renewal_deadline)
FROM renewal_opportunities
GROUP BY member_id
HAVING COUNT(*)>3;

SELECT date_format(expiry_date, '%d-%m-%Y')
FROM renewal_opportunities;
 
SELECT date_format(expiry_date, '%Y') as year, count(*)
FROM renewal_opportunities
GROUP BY year;

-- for each year distinct count of members
SELECT date_format(join_date, '%Y') as year, count(distinct member_id)
FROM members
GROUP BY year;

-- For each reneval_number, expiry_year how many members are there?-- 

SELECT date_format(join_date, '%Y') as expiry_year, count(member_id) as members,
renewal_number
FROM
renewal_opportunities
GROUP BY expiry_year, renewal_number;


Select outcome, detail_code,count(event_id) as events,count(distinct member_id) as members
FROM member_events
Where event_type = "PAYMENT_ATTEMPT"
GROUP BY outcome, detail_code;

-- 
# “First-time renewals deserve more attention than later renewals. We should offer a discount whenever a member reaches their first renewal.”

# Using renewal_opportunities, investigate whether first renewals represent a large enough share of upcoming renewals—and membership fees—to justify prioritising them.
# Choose the comparisons you think matter, present evidence, and recommend what the team should examine next.

SELECT renewal_number, COUNT(renewal_id)
FROM renewal_opportunities
WHERE date_format(expiry_date,'%d-%m-%Y')>='01-09-2026'
GROUP BY renewal_number;

-- If annunal fee > 1500 then high else low
SELECT *, CASE
WHEN annual_fee>1500 THEN "HIGH"
ELSE "LOW" END as annunal_percentage
FROM
members;

-- Find no of members who had high membership
SELECT *
CASE
WHEN annual_fee/1500>0.1 THEN "HIGH"
ELSE "LOW" END 
FROM
members;

-- How Many members are in high and low

SELECT CASE
WHEN annual_fee>1500 THEN "HIGH"
ELSE "LOW" END as annunal_percentage, COUNT(*) as members_count
FROM
members
GROUP BY annunal_percentage
;

SELECT 
CASE
WHEN
 renewal_number=1 THEN 'FIRST_RENEWAL'
 else
  'LATER_RENEWAL'
 END as user_renewals, count(renewal_id) as number_opportunities
FROM
renewal_opportunities
where expiry_date > '2026-09-01' and expiry_date < '2026-10-01' 
group by user_renewals;

-- Using member_events, examine payment attempts made during September 2026. For each channel, show:

-- Total payment attempts.
-- Successful payment attempts.
-- Failed payment attempts.

SELECT *,
CASE
	WHEN event_type='PAYMENT_ATTEMPT' AND outcome='SUCCESS' THEN 'SUCCESS'
    WHEN event_type='PAYMENT_ATTEMPT' AND outcome='FAILED' THEN 'FAILED'
    
END AS payment_status
FROM
member_events

where expiry_date > '2026-09-01' and expiry_date < '2026-10-01'
group by channel;


/*
Which cities have the most renewals coming due? For opportunities expiring in September 2026, show each city’s:
Number of distinct members due for renewal.
Number of renewal opportunities.
Total renewal fees due.
*/

SELECT m.city, count(DISTINCT m.member_id) as distinct_members, count(r.renewal_id) as renewal_opportunities,
sum(r.renewal_fee) as renewal_fees_due
FROM 
members m
LEFT JOIN renewal_opportunities r
ON m.member_id = r.member_id
where expiry_date >= '2026-09-01' and expiry_date < '2026-10-01'
GROUP BY m.city
ORDER BY renewal_opportunities DESC;

/*
Include members who were not due Show every member from Delhi or Mumbai, along with any renewal opportunities expiring in September 2026. 
Include members who had no opportunity that month. Return member ID, city, renewal ID and expiry date. 
Think: Which condition belongs in ON, and which belongs in WHERE?
*/

/*
Who had no payment attempt recorded? For September 2026 renewal opportunities,
 find those with no PAYMENT_ATTEMPT event. Return renewal ID, member ID, renewal number and expiry date. 
Use a LEFT JOIN. An opportunity with benefit or reminder events—but no payment attempt—must still appear.
*/

/*
For September 2026 opportunities, compare first renewals versus later renewals. Show:

Number of distinct opportunities.
Number of payment attempts.
Number of failed attempts.
Number of successful attempts. Include opportunities with no payment attempts.
*/

/*
For September 2026 opportunities, use all three tables to show each city’s:
- Number of distinct members due.
- Number of distinct members with at least one failed payment attempt.
- Number of failed payment attempts.
Include cities with no failures. Sort by members affected, highest first.
*/


