/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) *
FROM [SBA].[dbo].[sba_public_data]

-- Summary of all PPP loans approved by SBA. grouped by year

select 
	year(DateApproved),
	count(LoanNumber) Number_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average_Loan_Size
from sba_public_data
group by year(DateApproved)

-- Originating Lender Exploration

select	
	year(DateApproved),
	count(distinct OriginatingLender) as OriginatingLender,
	count(LoanNumber) Number_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average_Loan_Size	
from sba_public_data
group by year(DateApproved)

-- Top 15 Originating Lenders by loan count, total amount and average in 2020 and 2021

select top (15)
	OriginatingLender,
	count(LoanNumber) Number_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average_Loan_Size	
from sba_public_data
where year(DateApproved) = 2020
group by OriginatingLender
order by Approved_Amount desc

select top (15)
	OriginatingLender,
	count(LoanNumber) Number_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average_Loan_Size	
from sba_public_data
where year(DateApproved) = 2021
group by OriginatingLender
order by Approved_Amount desc

-- Top 20 industries that received PPP loans in 2020 and 2021

select top (20)
	d.Sector, 
	count(p.LoanNumber) Number_Approved,
	sum(p.InitialApprovalAmount) Approved_Amount,
	avg(p.InitialApprovalAmount) Average_Loan_Size
from sba_public_data p
join sba_naics_sector_codes_description d
	on left(p.NAICSCode, 2) = d.LookUpCodes
where year(DateApproved) = 2020
group by d.Sector
order by Approved_Amount desc

select top (20)
	d.Sector, 
	count(p.LoanNumber) Number_Approved,
	sum(p.InitialApprovalAmount) Approved_Amount,
	avg(p.InitialApprovalAmount) Average_Loan_Size
from sba_public_data p
join sba_naics_sector_codes_description d
	on left(p.NAICSCode, 2) = d.LookUpCodes
where year(DateApproved) = 2021
group by d.Sector
order by Approved_Amount desc

-- Approved Amount of Each Industry in 2020 and 2021 as a Percentage
with cte as 
(
select top (20)
	d.Sector, 
	count(p.LoanNumber) Number_Approved,
	sum(p.InitialApprovalAmount) Approved_Amount,
	avg(p.InitialApprovalAmount) Average_Loan_Size
from sba_public_data p
join sba_naics_sector_codes_description d
	on left(p.NAICSCode, 2) = d.LookUpCodes
where year(DateApproved) = 2020
group by d.Sector
--order by Approved_Amount desc
)
select Sector, Number_Approved, Approved_Amount, Average_Loan_Size,
	concat(Approved_Amount/sum(Approved_Amount) OVER() * 100, '%') Percentage_by_Amount
from cte
order by Approved_Amount desc


with cte as 
(
select top (20)
	d.Sector, 
	count(p.LoanNumber) Number_Approved,
	sum(p.InitialApprovalAmount) Approved_Amount,
	avg(p.InitialApprovalAmount) Average_Loan_Size
from sba_public_data p
join sba_naics_sector_codes_description d
	on left(p.NAICSCode, 2) = d.LookUpCodes
where year(DateApproved) = 2021
group by d.Sector
--order by Approved_Amount desc
)
select Sector, Number_Approved, Approved_Amount, Average_Loan_Size,
	concat(Approved_Amount/sum(Approved_Amount) OVER() * 100, '%') Percentage_by_Amount
from cte
order by Approved_Amount desc

--- How much of the PPP loans were forgiven by year

select 
	year(DateApproved),
	count(LoanNumber) Number_Approved,
	sum(CurrentApprovalAmount) Current_Approved_Amount,
	avg(CurrentApprovalAmount) Current_Average_Loan_Size,
	sum(ForgivenessAmount) Amount_Forgiven,
	concat(sum(ForgivenessAmount) * 100/sum(CurrentApprovalAmount), '%') as Percent_Forgiven
from sba_public_data
group by year(DateApproved)

--- Year, Month with highest PPP Loans approved

select
	year(DateApproved),
	month(DateApproved),
	count(LoanNumber) Number_Approved,
	sum(InitialApprovalAmount) Approved_Amount,
	avg(InitialApprovalAmount) Average_Loan_Size
from sba_public_data
group by year(DateApproved),
		month(DateApproved)
order by Approved_Amount desc