/*

Attempt at ETL: Hong Kong 7-Eleven and Circle-K store location data

Data scraped using Octoparse 8
https://www.7-eleven.com.hk/en/store
https://www.circlek.hk/en/store

*/

SELECT *
FROM PortfolioProject711CK..CK

SELECT *
FROM PortfolioProject711CK..SE

SELECT DISTINCT District
FROM PortfolioProject711CK..CK

SELECT DISTINCT District
FROM PortfolioProject711CK..SE

--Remove Macau and Zhuhai Districts
DELETE FROM PortfolioProject711CK..CK
WHERE  [District] IN ('Doumen', 'Hengqin', 'Jida', 'Jinding', 'Macau', 'Nanping', 'Tangjia', 'Wanzai', 'Xiangzhou', 'Xinxiangzhou')

DELETE FROM PortfolioProject711CK..SE
WHERE [District] IN ('Macau')

--Standardize districts, fix spelling
UPDATE PortfolioProject711CK..CK
SET District = 'Ap Lei Chau'
WHERE District = 'Ap Lei Chau'

UPDATE PortfolioProject711CK..CK
SET District = 'Wan Chai'
WHERE District = 'Wanchai'

UPDATE PortfolioProject711CK..CK
SET District = 'Mong Kok'
WHERE District = 'Mongkok'

UPDATE PortfolioProject711CK..CK
SET District = 'Pok Fu Lam'
WHERE District = 'Pok Fu lam'

UPDATE PortfolioProject711CK..CK
SET District = 'Sha Tin'
WHERE District = 'Shatin'

UPDATE PortfolioProject711CK..CK
SET District = 'Fo Tan'
WHERE District = 'Shatin Fo Tan'

UPDATE PortfolioProject711CK..CK
SET District = 'Tai Wai'
WHERE District = 'Shatin Tai Wai'

UPDATE PortfolioProject711CK..CK
SET District = 'Tai Koo'
WHERE District = 'Taikoo'

UPDATE PortfolioProject711CK..CK
SET District = 'To Kwa Wan'
WHERE District = 'Tokwawan'

UPDATE PortfolioProject711CK..SE
SET District = 'Ho Man Tin'
WHERE District = 'Homantin'

UPDATE PortfolioProject711CK..SE
SET District = 'Mong Kok'
WHERE District = 'Mongkok'

UPDATE PortfolioProject711CK..SE
SET District = 'Sham Shui Po'
WHERE District = 'Shamshuipo'

UPDATE PortfolioProject711CK..SE
SET District = 'Sha Tin'
WHERE District = 'Shatin'

UPDATE PortfolioProject711CK..SE
SET District = 'To Kwa Wan'
WHERE District = 'Tokwawan'

UPDATE PortfolioProject711CK..SE
SET District = 'Yau Ma Tei'
WHERE District = 'Yaumatei'

--Group Districts based on Hong Kong's official 18 districts
--1. Islands
--2. Kwai Tsing
--3. North
--4. Sai Kung
--5. Sha Tin
--6. Tai Po
--7. Tsuen Wan
--8. Tuen Mun
--9. Yuen Long
--10. Kowloon City
--11. Kwun Tong
--12. Sham Shui Po
--13. Wong Tai Sin
--14. Yau Tsim Mong
--15. Central and Western
--16. Eastern
--17. Southern
--18. Wan Chai

--https://www.rvd.gov.hk/doc/tc/hkpr13/06.pdf

ALTER TABLE PortfolioProject711CK..CK
ADD District2 Nvarchar(255)

UPDATE PortfolioProject711CK..CK
SET District2 = CASE WHEN District IN ('Cheung Chau', 'Tung Chung') THEN 'Island'
				WHEN District IN ('Kwai Chung', 'Tsing Yi') THEN 'Kwai Tsing'
				WHEN District IN ('Fanling', 'Lo Wu', 'Sheung Shui') THEN 'North'
				WHEN District IN ('Sai Kung', 'Tseung Kwan O') THEN 'Sai Kung'
				WHEN District IN ('Ma On Shan', 'Sha Tin', 'Fo Tan', 'Tai Wai') THEN 'Sha Tin'
				WHEN District IN ('Tai Po') THEN 'Tai Po'
				WHEN District IN ('Ma Wan', 'Tai Wo Hau', 'Tsuen Wan') THEN 'Tseun Wan'
				WHEN District IN ('Tuen Mun') THEN 'Tuen Mun'
				WHEN District IN ('Tin Shui Wai', 'Yuen Long') THEN 'Yuen Long'
				WHEN District IN ('Ho Man Tin', 'Hung Hom', 'Kowloon City', 'Kowloon Tong', 'To Kwa Wan') THEN 'Kowloon City'
				WHEN District IN ('Kowloon Bay', 'Kwun Tong', 'Lam Tin', 'Ngau Tau Kok', 'Yau Tong') THEN 'Kwun Tong'
				WHEN District IN ('Cheung Sha Wan', 'Lai Chi Kok', 'Mei Foo', 'Sham Shui Po', 'Shek Kip Mei') THEN 'Sham Shui Po'
				WHEN District IN ('Choi Hung', 'Diamond Hill', 'Lok Fu', 'San Po Kong', 'Tsz Wan Shan', 'Wong Tai Sin') THEN 'Wong Tai Sin'
				WHEN District IN ('Jordan', 'Mong Kok', 'Prince Edward', 'Tai Kok Tsui', 'Tsim Sha Tsui', 'Yau Ma Tei') THEN 'Yau Tsim Mong'
				WHEN District IN ('Central', 'Queensway', 'Sai Wan', 'Sai Ying Pun', 'Sheung Wan', 'Western District') THEN 'Central and Western'
				WHEN District IN ('Chai Wan', 'Heng Fa Chuen', 'North Point', 'Quarry Bay', 'Tai Koo', 'Shau Kei Wan', 'Siu Sai Wan', 'Tin Hau') THEN 'Eastern'
				WHEN District IN ('Aberdeen', 'Ap Lei Chau', 'Pok Fu Lam', 'Wong Chuk Hang') THEN 'Southern'
				WHEN District IN ('Causeway Bay', 'Happy Valley', 'Wan Chai') THEN 'Wan Chai'
				ELSE District2
				END

ALTER TABLE PortfolioProject711CK..SE
ADD District2 Nvarchar(255)

UPDATE PortfolioProject711CK..SE
SET District2 = CASE WHEN District IN ('Cheung Chau', 'Tung Chung', 'HK International Airport', 'Lantau Island') THEN 'Island'
				WHEN District IN ('Kwai Chung', 'Tsing Yi') THEN 'Kwai Tsing'
				WHEN District IN ('Fanling', 'Lo Wu', 'Sheung Shui') THEN 'North'
				WHEN District IN ('Sai Kung', 'Tseung Kwan O') THEN 'Sai Kung'
				WHEN District IN ('Ma On Shan', 'Sha Tin', 'Fo Tan', 'Tai Wai', 'University') THEN 'Sha Tin'
				WHEN District IN ('Tai Po') THEN 'Tai Po'
				WHEN District IN ('Ma Wan', 'Tai Wo Hau', 'Tsuen Wan') THEN 'Tseun Wan'
				WHEN District IN ('Tuen Mun') THEN 'Tuen Mun'
				WHEN District IN ('Tin Shui Wai', 'Yuen Long', 'Lok Ma Chau') THEN 'Yuen Long'
				WHEN District IN ('Ho Man Tin', 'Hung Hom', 'Kowloon City', 'Kowloon Tong', 'To Kwa Wan') THEN 'Kowloon City'
				WHEN District IN ('Kowloon Bay', 'Kwun Tong', 'Lam Tin', 'Ngau Tau Kok', 'Yau Tong', 'Sau Mau Ping') THEN 'Kwun Tong'
				WHEN District IN ('Cheung Sha Wan', 'Lai Chi Kok', 'Mei Foo', 'Sham Shui Po', 'Shek Kip Mei') THEN 'Sham Shui Po'
				WHEN District IN ('Choi Hung', 'Diamond Hill', 'Lok Fu', 'San Po Kong', 'Tsz Wan Shan', 'Wong Tai Sin') THEN 'Wong Tai Sin'
				WHEN District IN ('Jordan', 'Mong Kok', 'Prince Edward', 'Tai Kok Tsui', 'Tsim Sha Tsui', 'Yau Ma Tei', 'Tsim Sha Tsui East') THEN 'Yau Tsim Mong'
				WHEN District IN ('Central', 'Queensway', 'Sai Wan', 'Sai Ying Pun', 'Sheung Wan', 'Western District', 'Admiralty', 'Western') THEN 'Central and Western'
				WHEN District IN ('Chai Wan', 'Heng Fa Chuen', 'North Point', 'Quarry Bay', 'Tai Koo', 'Tai Koo Shing', 'Shau Kei Wan', 'Siu Sai Wan', 'Tin Hau', 'Fortress Hill', 'Sai Wan Ho') THEN 'Eastern'
				WHEN District IN ('Aberdeen', 'Ap Lei Chau', 'Pok Fu Lam', 'Wong Chuk Hang', 'Southern', 'Stanley') THEN 'Southern'
				WHEN District IN ('Causeway Bay', 'Happy Valley', 'Wan Chai') THEN 'Wan Chai'
				ELSE District2
				END

