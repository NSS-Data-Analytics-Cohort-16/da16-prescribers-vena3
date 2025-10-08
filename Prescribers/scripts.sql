-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

select  
	   c.npi, 
	   sum(total_claim_count) as number_of_claims
from  prescriber as c
inner join prescription as p
on c.npi = p.npi
group by c.npi
order by number_of_claims DESC
limit 1

	
--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.

select  
	   c.npi, c.nppes_provider_first_name  as first_name,
	   c.nppes_provider_last_org_name  as last_name, c.specialty_description,
	   sum(total_claim_count) as number_of_claims
from  prescriber as c
inner join prescription as p
on c.npi = p.npi
group by c.npi, first_name, last_name, specialty_description
order by number_of_claims DESC
limit 1


	 
-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?

select  c.specialty_description,
        sum(total_claim_count) as total_claims
from  prescriber as c
left join prescription as p
on c.npi = p.npi
where total_claim_count IS NOT NULL
group by c.specialty_description
order by total_claims DESC
limit 1

--     b. Which specialty had the most total number of claims for opioids?

select c.specialty_description,
      sum(total_claim_count) AS claims_for_opioids
from prescriber AS c
inner join prescription AS p
    ON c.npi = p.npi
inner join drug AS d 
    ON d.drug_name = p.drug_name
where d.opioid_drug_flag = 'Y'
group by c.specialty_description
order by claims_for_opioids DESC
limit 5;


--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

select distinct c.specialty_description
from  prescriber as c
inner join  prescription AS p
on c.npi = p.npi
where p.npi IS NOT NULL


--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?


select c.specialty_description as specialty,
       round(avg(total_claim_count), 2) AS claims_for_opioids
from prescriber AS c
inner join prescription AS p
    on c.npi = p.npi
inner join drug AS d 
    ON d.drug_name = p.drug_name
where d.opioid_drug_flag = 'Y'
group by c.specialty_description
order by claims_for_opioids DESC


-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?

select c.generic_name as drug_name,
       sum(p.total_drug_cost) as total_cost
 from prescription as p
 inner join drug as c
 on c.drug_name = p.drug_name 
 group by generic_name
 order by total_cost DESC
 limit 1

--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs. **Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/ 

--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.

-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.
