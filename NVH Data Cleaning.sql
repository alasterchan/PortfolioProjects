/*

Nashville Housing Data Cleaning

*\


--Check tables
SELECT *
FROM dbo.NashvilleHousing

--Convert SaleDate data type 
ALTER TABLE NashvilleHousing
ADD SaleDate2 DATE;

UPDATE NashvilleHousing
SET SaleDate2 = CONVERT(DATE, SaleDate)

--Fill in null PropertyAddress values based on matching ParcelID in other rows
SELECT *
FROM dbo.NashvilleHousing
WHERE PropertyAddress is NULL

SELECT *
FROM dbo.NashvilleHousing
ORDER BY ParcelID

SELECT x.ParcelID, x.PropertyAddress, y.ParcelID, y.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing AS x
JOIN dbo.NashvilleHousing AS y
	ON x.ParcelID = y.ParcelID
	AND x.UniqueID<> y.UniqueID 
WHERE x.PropertyAddress IS NULL

UPDATE x
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing AS x
JOIN dbo.NashvilleHousing AS y
	ON x.ParcelID = y.ParcelID
	AND x.UniqueID<> y.UniqueID 
WHERE x.PropertyAddress IS NULL

--Divide PropertyAddress and OwnerAddress into separate columns (Address, City, State)

SELECT PropertyAddress
FROM dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(PropertyAddress, ‘,’, ‘.’), 2)
, PARSENAME(REPLACE(PropertyAddress ‘,’, ‘.’), 1)
FROM dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySepAddress Nvarchar(255)

ALTER TABLE NashvilleHousing
ADD PropertySepCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySepAddress = PARSENAME(REPLACE(PropertyAddress, ‘,’, ‘.’), 2)

UPDATE NashvilleHousing
SET PropertySepCity = PARSENAME(REPLACE(PropertyAddress ‘,’, ‘.’), 1)


SELECT OwnerAddress
FROM dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ‘,’, ‘.’), 3)
, PARSENAME(REPLACE(OwnerAddress ‘,’, ‘.’), 2)
, PARSENAME(REPLACE(OwnerAddress ‘,’, ‘.’), 1)
FROM dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSepAddress Nvarchar(255)

ALTER TABLE NashvilleHousing
ADD OwnerSepCity Nvarchar(255)

ALTER TABLE NashvilleHousing
ADD OwnerSepState Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSepAddress = PARSENAME(REPLACE(OwnerAddress, ‘,’, ‘.’), 3)

UPDATE NashvilleHousing
SET OwnerSepCity = PARSENAME(REPLACE(OwnerAddress ‘,’, ‘.’), 2)

UPDATE NashvilleHousing
SET OwnerSepState = PARSENAME(REPLACE(OwnerAddress, ‘,’, ‘.’), 1)


--Standardise SoldAsVacant entries

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = ‘Y’ THEN ‘Yes’
		WHEN SoldAsVacant = ‘N’ THEN ‘No’
		ELSE SoldAsVacant
		END
FROM dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = ‘Y’ THEN ‘Yes’
		WHEN SoldAsVacant = ‘N’ THEN ‘No’
		ELSE SoldAsVacant
		END
 
--Remove duplicates

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER
(
PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference 
ORDER BY UniqueID
)
AS RowNumber
FROM dbo.NashvilleHousing
ORDER BY ParcelID
)
—SELECT *
DELETE
FROM RowNumCTE
WHERE RowNumber > 1

--Delete unused columns

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDatre, PropertyAddress, OwnerAddress, TaxDistrict

