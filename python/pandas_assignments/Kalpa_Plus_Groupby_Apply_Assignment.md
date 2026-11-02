# Kalpa Plus Groupby Apply Assignment

Use the already loaded DataFrames:

- `members` from `members.csv`
- `renewals` from `renewal_opportunities.csv`
- `events` from `member_events.csv`

Answer each question independently. Start from a fresh copy of the relevant DataFrame so columns created in one answer do not affect another.

## Instructions

1. Use `groupby().apply()` with a named custom function for every question. Do not use joins, merges, `transform`, pivots or `groupby().agg()`.
2. Some functions receive one Series; others receive a group DataFrame with several columns. Choose the required columns after `groupby` so the function does not depend on whether the grouping column is included.
3. When returning one value per original row, use `group_keys=False`. Return a Series or DataFrame containing exactly the group's original row indexes. Do not reset those indexes inside the function.
4. Assign row-level results back using their index labels. Keep the original row count and order unchanged. A grouped result may come back in a different order; do not assign it by converting it to a list or array.
5. For one scalar per group, use `reset_index(name="...")` to give the result a meaningful column name. For a named summary Series per group, reset the group index to obtain a summary table.
6. If a requested mean has no eligible observations, return `NaN`. If a requested share has a zero denominator, use the fallback specified in that question.
7. Keep money numeric. Listed annual fees and offered discounts are not proof of cash collected. Only successful payment-attempt amounts represent renewal cash.

If your date columns are still strings, convert them first:

```python
members["join_date"] = pd.to_datetime(members["join_date"])
renewals["expiry_date"] = pd.to_datetime(renewals["expiry_date"])
renewals["renewal_deadline"] = pd.to_datetime(renewals["renewal_deadline"])
events["event_time"] = pd.to_datetime(events["event_time"])
```

For expiry-year questions, you may create `expiry_year` using `renewals["expiry_date"].dt.year`. This is a supplied helper, not a separate analysis task.

## Questions

### 1

Using `members`, group by `acquisition_channel`.

Write a function that receives the `annual_fee` Series and returns the difference between its highest and lowest values. Produce one row per channel with an output column named `fee_range`.

### 2

Using `members`, group by `city`.

The function should receive the group DataFrame. Among members who were `"PAID"` on 9 October 2025, calculate the percentage who are `"EXPIRED"` on 9 October 2026.

Return one scalar per city, named `expired_previous_paid_pct`. If a city has no previously paid members, return `NaN`. Members previously marked `"NOT_JOINED"` or `"EXPIRED"` must not enter the denominator.

### 3

Using `members`, group by `acquisition_channel`.

Write a function that receives the group DataFrame and returns the mean `annual_fee` of members currently marked `"PAID"`. Produce `current_paid_average_fee`, with one row per acquisition channel.

### 4

Using `members`, group by `city`.

Write a function that returns a named summary Series containing:

- `registered_members`: number of rows in the group.
- `currently_paid`: number currently marked `"PAID"`.
- `current_paid_pct`: currently paid members as a percentage of all registered members in that city.

The final output should have one row per city and these three columns. This percentage is a billing-snapshot measure, not a renewal rate.

### 5

Using `members`, group by `city` and pass the `annual_fee` Series to your function.

Return a Series showing each member's annual fee as a percentage of the sum of listed annual fees in that city. Assign it back to `members` as `city_fee_share_pct`.

Preserve every original row index. This is a share of listed fees, not a share of collected revenue. If a total is zero, return zero for every row in that group.

### 6

Using `members`, group by `city` and pass the `join_date` Series to your function.

Return the number of whole days between each member's joining date and the earliest joining date in that city. Assign the returned Series as `days_after_city_first_join`.

The earliest joiner in each city should receive zero. Preserve the original indexes.

### 7

Using `members`, group by `city`.

For each city, calculate the mean annual fee among currently paid members. Your function should return a Series with one value for every original member row:

- For a currently paid member, return their fee minus that city's mean fee among currently paid members.
- For every other member, return `NaN`.

Assign the result as `paid_fee_difference`. Do not remove unpaid rows from the returned Series.

### 8

Using `members`, group by `city` and send the group DataFrame to your function.

Return a DataFrame with the same row indexes and two columns:

- `city_paid_member_count`: the number of currently paid members in the city, repeated on every member row.
- `paid_fee_share_pct`: each currently paid member's share of that city's total listed fees among currently paid members. Use zero for members not currently paid and for a group with no paid fee total.

Assign both returned columns back to the original rows. Explain why summing `city_paid_member_count` over those rows would overcount members.

### 9

Using `renewals`, group by `renewal_number`.

Write a function receiving the `offered_discount` Series. Return the percentage of records with a discount greater than zero, rounded to two decimal places.

Produce one row per renewal number, with a column named `discount_offer_pct`.

### 10

Using `renewals`, group by `renewal_number` and pass the group DataFrame.

Among records where `offered_discount > 0`, calculate the mean of `renewal_fee - offered_discount`.

Return one scalar per group, named `average_discounted_offer`. This is an average offered price, not average cash received.

### 11

Using `renewals`, group by `expiry_year`.

Write a function receiving the group DataFrame. Count records whose `renewal_deadline` is before 10 October 2026: these windows have finished by the end of 9 October.

Return one scalar named `finished_windows` per year. Do not infer successful renewal from this table.

### 12

Using `renewals`, group by `expiry_year` and return a named summary Series containing:

- `members_due`: number of records.
- `finished_windows`: number whose deadline is before 10 October 2026.
- `open_windows`: number whose deadline is on or after 10 October 2026.

Produce one summary row per year. Check that finished plus open windows equals members due in every group.

### 13

Using `renewals`, group by `renewal_number` and pass the `renewal_fee` Series.

Return a Boolean Series indicating whether each fee is strictly greater than its group's median fee. Assign it back as `above_group_median_fee`.

Values equal to the median should receive `False`.

### 14

Using `renewals`, group by both `expiry_year` and `renewal_number`.

Write a function receiving the group DataFrame. Calculate each row's offered price as `renewal_fee - offered_discount`. Return a Series showing the difference between that row's offered price and its group's mean offered price.

Assign it back as `offer_price_difference`, keeping every original index.

### 15

Using `renewals`, group by `renewal_number`.

Your function should return a DataFrame with the same original indexes containing:

- `net_offer_price`: renewal fee minus offered discount.
- `below_group_mean_offer`: whether that row's net offer price is strictly below its group's mean net offer price.

Assign both columns back to the original renewal rows.

### 16

Using `renewals`, group by `expiry_year`.

Return a DataFrame with one row for every original renewal record and two columns:

- `window_finished`: whether its deadline is before 10 October 2026.
- `finished_window_fee_share_pct`: its renewal fee as a percentage of the group's total renewal fees for finished windows only.

For an open window, its share should be zero. If the group's eligible fee total is zero, all shares should be zero. Assign both columns back. This share describes fees associated with eligible records, not actual renewals or cash received.

### 17

Using `events`, first select only `"PAYMENT_ATTEMPT"` events. Group by `channel` and send the `outcome` Series to your function.

Return the percentage of failed attempts, rounded to two decimal places. Produce one row per channel with a column named `failure_pct`.

### 18

Using payment-attempt rows from `events`, group by `channel` and pass the group DataFrame.

Return total payment-attempt cost divided by the number of successful payment events. Include failed-attempt costs in the numerator. Name the result `cost_per_successful_renewal`.

Return `NaN` if there are no successful payments. Do not divide by total attempts.

### 19

Using payment-attempt rows from `events`, group by `channel` and pass the `renewal_id` Series.

Return the percentage of distinct renewal IDs that have at least two attempts within that channel. Name the result `retry_pct`, rounded to two decimal places.

A renewal attempted in more than one channel can appear in both channel summaries. Explain why a high retry percentage does not necessarily mean those renewals ultimately failed.

### 20

Using payment-attempt rows from `events`, group by `channel`.

Return a named summary Series containing:

- `attempt_count`: number of payment attempts.
- `renewals_attempted`: number of distinct renewal IDs.
- `successful_payments`: number of successful payment events.
- `total_payment_cost`: cost of all attempts, including failures.

Produce a summary table with these four columns and one row per channel.

### 21

Using all rows in `events`, group by `event_type` and send the `event_cost` Series to your function.

Return a Series showing each event's cost minus the median event cost for that event type. Assign it to the original rows as `cost_difference_from_median`.

Preserve the original indexes and retain negative differences.

### 22

Using all rows in `events`, group by `channel` and pass the group DataFrame.

Calculate the mean `amount` using only successful payment-attempt rows within that channel. Return a Series with one value per original event row:

- For every payment-attempt row, return its amount minus that successful-payment mean.
- For all non-payment rows, return `NaN`.
- If the channel has no successful payments, return `NaN` for every row.

Assign the result as `amount_difference`. Failed attempts receive a difference for comparison, but their amounts must not enter the successful-payment mean.

### 23

Using all rows in `events`, group by `renewal_id`.

Return a DataFrame with the same row indexes containing:

- `renewal_payment_cost`: total cost of payment attempts for that renewal, repeated on every event row.
- `renewal_failed_payment_cost`: total cost of failed payment attempts for that renewal, repeated on every event row.

Include benefit, reminder and support rows in the returned result. A renewal with no payment attempts should receive zero in both columns. Assign the results back without changing the original row count.

### 24

Using all rows in `events`, group by `event_type`.

Return a DataFrame with the original indexes containing:

- `type_cost_share_pct`: each row's share of its event type's total event cost. Use zero if total cost is zero.
- `above_type_average_cost`: whether each row costs strictly more than its event type's average.

Assign both returned columns back. For a group with a positive cost total, check that its cost shares sum to approximately 100%.

### 25

Using `events`, select only payment-attempt rows, retaining their original indexes. Group by `renewal_id`.

Inside the function, sort the group's rows by `event_time`, using `event_id` to break any timestamp ties. Return a DataFrame containing:

- `chronological_attempt_number`: 1, 2, 3 and so on in timestamp order.
- `minutes_since_first_attempt`: elapsed minutes from the group's first attempt.

Keep the original event indexes even after sorting. Assign both returned columns to the corresponding rows in the full `events` DataFrame. Non-payment rows should remain `NaN` in these columns.

Explain why resetting the row index inside the function could place a result beside the wrong event.

## Submission

Submit one notebook with the question number, named function, `groupby().apply()` call and output preview for each answer.

For every row-level result, check that the returned indexes match the rows being updated. For the full-table questions, confirm that row count, row order and original index labels remain unchanged. For Question 25, check index alignment on the selected payment rows and verify that non-payment rows remain unfilled.

No answer key is included in this assignment.
