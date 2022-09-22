/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [NAICS_Codes]
      ,[NAICS_Industry_Description]
  FROM [SBA].[dbo].[sba_industry_standards]


-- Create a table that contains just the sector codes and description

select *
into sba_naics_sector_codes_description
from(
SELECT NAICS_Industry_Description, 
	iif(NAICS_Industry_Description like '%–%', substring(NAICS_Industry_Description, 8, 2), '') as LookUpCodes,
	iif(NAICS_Industry_Description like '%–%', LTRIM(substring(NAICS_Industry_Description, charindex('–', NAICS_Industry_Description) + 1, len(NAICS_Industry_Description))), '') as Sector
from sba_industry_standards
where NAICS_Codes = ''
) main
where LookUpCodes <> '';

insert into sba_naics_sector_codes_description
values
('Sector 31 – 33 – Manufacturing', 32, 'Manufacturing'),
('Sector 31 – 33 – Manufacturing', 33, 'Manufacturing'),
('Sector 44 – 45 – Retail Trade', 45, 'Retail Trade'),
('Sector 48 – 49 – Transportation and Warehousing', 49, 'Transportation and Warehousing')

update sba_naics_sector_codes_description
set Sector = 'Manufacturing'
where LookUpCodes  = 31;

select * 
from sba_naics_sector_codes_description
order by LookUpCodes;