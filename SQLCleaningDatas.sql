

/*

Resumo de DataCleaning usando SQL Query

*/

Select *
From dataClean.dbo.DataCasa

--> Padronização de Formato de Data 

SELECT saleDateConvert, CONVERT(DATE, SaleDate)
FROM dataClean.dbo.DataCasa;

Update DataCasa
set SaleDate = Convert(Data,SaleDate)


Alter Table DataCasa
add saleDateConvert Date;

Update DataCasa
Set saleDateConvert = CONVERT(Date, SaleDate)


-- data de endereço

SELECT PropertyAddress
FROM dataClean.dbo.DataCasa
Order By ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID , b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From dataClean.dbo.DataCasa a
Join dataClean.dbo.DataCasa b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From dataClean.dbo.DataCasa a
Join dataClean.dbo.DataCasa b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Quebra de endereço para colunas individuais 

SELECT PropertyAddress
FROM dataClean.dbo.DataCasa


Select
substring(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1) as endereco
, substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress)) as endereco

FROM dataClean.dbo.DataCasa

Alter Table DataCasa
add PropiedadeSeparadaEndereco Nvarchar(255);

Alter Table DataCasa
add PropiedadeSeparadaCidade Nvarchar(255);

Update DataCasa
Set PropiedadeSeparadaEndereco = substring(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1)


Update DataCasa
Set PropiedadeSeparadaCidade = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))

Select *
From dataClean.dbo.DataCasa


Select OwnerAddress
From dataClean.dbo.DataCasa

Select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
From dataClean.dbo.DataCasa


Alter Table DataCasa
add DonoSeparadaEndereco Nvarchar(255);

Alter Table DataCasa
add DonoSeparadaCidade Nvarchar(255);

Alter Table DataCasa
add DonoSeparadaEstado Nvarchar(255);

Update DataCasa
Set DonoSeparadaEndereco = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)


Update DataCasa
Set DonoSeparadaCidade = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)


Update DataCasa
Set DonoSeparadaEstado = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

Select *
From dataClean.dbo.DataCasa


-- Mudar variavel da coluna SolAsVacant de Y e N para Sim ou Não 

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From dataClean.dbo.DataCasa
Group By SoldAsVacant
Order by 2

Select SoldAsVacant
, case when SoldAsVacant = 'Y' Then 'Sim'
	When SoldAsVacant = 'N' Then 'Não'	
	When SoldAsVacant = 'No' Then 'Não'	
	When SoldAsVacant = 'Yes' Then 'Sim'	
	Else SoldAsVacant
	END
From dataClean.dbo.DataCasa

Update DataCasa
Set SoldAsVacant= case when SoldAsVacant = 'Y' Then 'Sim'
	When SoldAsVacant = 'N' Then 'Não'	
	When SoldAsVacant = 'No' Then 'Não'	
	When SoldAsVacant = 'Yes' Then 'Sim'	
	Else SoldAsVacant
	END

-- Remoção de duplicados 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER ( 
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by
					uniqueID
					) row_num



From dataClean.dbo.DataCasa
)

--Delete (duplicados deletado)

Select *
From RowNumCTE
Where row_num > 1 
Order By PropertyAddress




-- Exclusão de colunas não suavel

Select *
From dataClean.dbo.DataCasa

ALTER TABLE dataClean.dbo.DataCasa
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE dataClean.dbo.DataCasa
DROP COLUMN SaleDaate