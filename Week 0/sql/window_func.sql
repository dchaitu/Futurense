SHOW DATABASES;
USE `kalpa_plus`;

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    member_id VARCHAR(10),
    amount INT
);

INSERT INTO orders (order_id, member_id, amount)
VALUES
    ('O01', 'M01', 500),
    ('O02', 'M01', 300),
    ('O03', 'M02', 700),
    ('O04', 'M03', 400),
    ('O05', 'M05', 600);

SELECT * ,SUM(amount) OVER() FROM orders;

SELECT * ,SUM(amount) OVER(PARTITION BY member_id) FROM orders;

-- Using renewal_opportunities, display every opportunity and add the total renewal fees due across all opportunities belonging to that member.

SELECT *, SUM(renewal_fee) OVER(PARTITION BY member_id)
FROM renewal_opportunities;

-- Using members, display every member and add the number of members from the same city.
SELECT *, COUNT(member_id) OVER(PARTITION BY city) FROM members;


/*
Using renewal_opportunities, display every opportunity and add the total renewal fees due across all opportunities belonging to that member.

Using members, display every member and add the number of members from the same city.

Members in each city Using members, display every member and add the number of members from the same city.

Events per renewal opportunity Using member_events, display every event and add the total number of events recorded against the same renewal_id.

Cost of serving each member Using member_events, display every event and add the total recorded event cost for that member.

Successful collections by channel Using member_events, select only successful payment attempts. Display every selected event and add the total successful payment amount collected through that event’s channel.

*/
SELECT * ,SUM(amount) OVER(PARTITION BY member_id ORDER BY order_date) FROM orders;

-- For each member find his latest payment attempt
SELECT * from
(SELECT *, RANK() OVER(PARTITION BY member_id ORDER BY event_time DESC) as latest_date
FROM member_events
WHERE event_type= "PAYMENT_ATTEMPT"
) as t
Where t.latest_date=1;

WITH cte as
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY member_id ORDER BY event_time DESC) as latest_date
FROM member_events
WHERE event_type= "PAYMENT_ATTEMPT"
)
SELECT * from cte
Where cte.latest_date=1;


/*
1. Which members account for the highest recorded service costs in each city?
Using members and member_events, calculate each member’s total recorded event cost during September 2026. Include members who had no events during the month, with a cost of zero.
Use a CTE to calculate the member totals. Then use a window function to rank members within each city, highest cost first.
Return members in the top three distinct cost levels in each city. Members with equal costs should share a rank, with no gaps between ranks.
Show member ID, city, total event cost and rank.

*/


/*
Question 1: Highest service costs in each city
Kalpa wants to identify members with the highest recorded service costs in each city.

Using members and member_events:

Calculate each member’s total event_cost during September 2026.
Include members with no events during the month, showing their cost as zero.
Use a CTE to calculate the member totals.
Use a window function to rank members within each city, highest cost first.
Return members in the top three distinct cost levels in each city. Equal costs should receive the same rank, with no gaps between ranks.
Required columns: member ID, city, total event cost and rank.

Explain: Where should the September date condition go to preserve members with no events?
*/
SELECT m.city, me.member_id, SUM(event_cost) 
FROM member_events me
JOIN members m
ON m.member_id = me.member_id
WHERE me.event_time> '2026-09-01' AND me.event_time<'2026-10-01'
GROUP BY m.city;

-- kaggle


/*
Question 2: Daily renewal collections
Kalpa wants to understand how renewal collections accumulated during September 2026.

Using member_events:

Select successful payment attempts made during September 2026.
Use a CTE to calculate total collections for each channel and payment date.
Use window functions to calculate:
Cumulative collections within each channel, ordered by date.
Average daily collections for each channel across dates with successful payments.
The difference between each day’s collections and that channel’s average.
Required columns: channel, payment date, daily collections, cumulative collections, average daily collections and difference from average.

Explain: Why is the average of daily collection totals different from the average amount per successful payment?

*/

