select * from NashvilleHousing;


--Cleaning Data in SQL Queries

select * from NashvilleHousing;


--Standardize Date Format

select SaleDateConverted --CAST(SaleDate as date) as new_sale_date
from NashvilleHousing;

Alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = CAST(SaleDate as date);


-- Populate Property Address Data

Select propertyaddress
from NashvilleHousing
where propertyaddress is null;

SELECT a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) as PropertyAddress_Updated
from NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID =b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]


UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID =b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]

--Address Breakdown to Individual Columns(Address, City, State)


SELECT
SUBSTRING(PropertyAddress, 1, charindex(',', propertyaddress)-1) as address,
SUBSTRING(PropertyAddress, charindex(',', propertyaddress)+1, len(PropertyAddress)) as State

from NashvilleHousing;

ALTER Table NashVilleHousing
ADD PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, charindex(',', propertyaddress)-1)


ALTER Table NashVilleHousing
ADD PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, charindex(',', propertyaddress)+1, len(PropertyAddress))


SELECT PropertySplitCity, PropertySplitAddress
FROM NashVilleHousing;

select * from NashvilleHousing;

SELECT
PARSENAME(Replace(owneraddress, ',', '.'),3),
PARSENAME(Replace(owneraddress, ',', '.'),2),
PARSENAME(Replace(owneraddress, ',', '.'),1)
from nashvillehousing;

ALTER Table NashVilleHousing
ADD OwnerSplitAddress nvarchar(255);

update nashvillehousing
set OwnerSplitAddress = PARSENAME(Replace(owneraddress, ',', '.'),3)

ALTER Table NashVilleHousing
ADD OwnerSplitCity nvarchar(255);

update nashvillehousing
set OwnerSplitCity = PARSENAME(Replace(owneraddress, ',', '.'),2)

ALTER Table NashVilleHousing
ADD OwnerSplitState nvarchar(255);

update nashvillehousing
set OwnerSplitState = PARSENAME(Replace(owneraddress, ',', '.'),1)

--Change Y and N to Yes/NO

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


Select SoldAsVacant,
Case
WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant
END
FROM NashvilleHousing;

Update NashvilleHousing
SET SoldAsVacant = Case
WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant
END

--Remove Duplicates


WITH RowNumCTE as(
Select *,
ROW_NUMBER() OVER(Partition by ParcelId,PropertyAddress, SalePrice,SaleDate, LegalReference ORDER BY UniqueId) row_num
from NashvilleHousing)

DELETE from RowNumCTE
where row_num >1;


--Delete Unused Columns

ALTER Table NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

select * from NashvilleHousing;

ALTER Table NashVilleHousing
DROP COlUMN SaleDate;