Select *
From PortfolioProject..NashvilleHousing

--Standardized date format

ALTER TABLE NashvilleHousing 
ALTER COLUMN SaleDate DATE;

--Populate Property Address data


Update a

Set a.PropertyAddress =  ISNULL(a.propertyAddress, b.PropertyAddress)

From PortfolioProject..NashvilleHousing a

Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID] <> b.[UniqueID]

-- Breaking out Address into Individual Columns (Address, City, State)


Alter Table NashvilleHousing

Add PropertyCity VARCHAR(255), PropertyStreetAddress VARCHAR(255) 

Update NashvilleHousing

Set PropertyCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress))

Update NashvilleHousing

Set PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

Alter Table NashvilleHousing

Add OwnerCity VARCHAR(255), OwnerStreetAddress VARCHAR(255), OwnerState VARCHAR(255)

Update NashvilleHousing

Set OwnerCity = PARSENAME(Replace(OwnerAddress,',', '.'), 2);

Update NashvilleHousing
Set OwnerStreetAddress = PARSENAME(Replace(OwnerAddress,',', '.'), 3);

Update NashvilleHousing
Set OwnerState = PARSENAME(Replace(OwnerAddress,',', '.'), 1);


--Change Y and N to Yes and No in "Sold as Vacant" field

Update NashvilleHousing

Set SoldAsVacant = CASE When SoldASVacant = 'Y' Then 'Yes'
						When SoldAsVacant = 'N' Then 'No'
						Else SoldAsVacant
						End

--Remove Duplicates

With RowNumCTE As(
Select *,
	Row_Number()Over(
	PARTITION BY ParcelID,
				 SalePrice,
				 PropertyStreetAddress,
				 PropertyCity,
				 SaleDate,
				 LegalReference
				 Order by
				     UniqueID) row_num
From PortfolioProject..NashvilleHousing


)
Delete  
From RowNumCTE

Where row_num>1

--Delete Unused Columns

Alter Table NashvilleHousing

Drop Column TaxDistrict, PropertyAddress, OwnerAddress



