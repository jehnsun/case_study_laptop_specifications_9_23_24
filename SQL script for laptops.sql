SET SQL_SAFE_UPDATES = 0;
#Allows users to permanently update the dataset

UPDATE laptop_prices_9_23_24.`laptop`
set SSD = REPLACE(TRIM(SSD), 'NO SSD', 'NA');
#Replaced missing values from the original table within the SSD with 'NA'

UPDATE laptop_prices_9_23_24.`laptop`
SET SSD = REPLACE(TRIM(SSD), ' GB SSD Storage', ''); 
#Removed unnecessary strings from the original data
#Meant to give the user pure numbers for easier calculation

UPDATE laptop_prices_9_23_24.`laptop`
set HDD = REPLACE(TRIM(HDD), 'No HDD', 'NA');
#Replaced missing values from the original table within the HDD column with 'NA'

UPDATE laptop_prices_9_23_24.`laptop`
SET HDD = REPLACE(TRIM(HDD), ' GB HDD Storage', '');
#Removed unnecessary strings from the original data
#Meant to give the user pure numbers for easier calculation

UPDATE laptop_prices_9_23_24.`laptop`
set RAM = REPLACE(TRIM(RAM), ' LP', '');
#Removed unnecessary strings from the original data
#Meant to give the user pure numbers for easier calculation

UPDATE laptop_prices_9_23_24.`laptop`
set RAM = REPLACE(TRIM(RAM), ' RAM', '');
#Removed unnecessary strings from the original data
#Meant to give the user pure numbers for easier calculation

UPDATE laptop_prices_9_23_24.`laptop`
SET RAM = REPLACE(RAM, ' GB', '');
#Removed unnecessary strings from the original data
#Meant to give the user pure numbers for easier calculation

UPDATE laptop_prices_9_23_24.`laptop`
SET RAM_TYPE = REPLACE(TRIM(RAM_TYPE), ' RAM', '');
#Removed unnecessary strings from the original data

UPDATE laptop_prices_9_23_24.`laptop`
SET Processor_Name = REPLACE(TRIM(Processor_Name), ' Processor', '');

UPDATE laptop_prices_9_23_24.`laptop`
SET GPU = CASE 
			WHEN GPU = ''
            THEN 'NA'
            WHEN GPU = 'Graphics'
            THEN 'NA'
            ELSE GPU
            END;
#Removed unknown data with the GPU column
#9 Rows have been changed

DELETE FROM laptop_prices_9_23_24.`laptop`
WHERE (`SSD`< 256 AND `HDD` < 256 );
#Removed potential faulty data (approx. 100 rows deleted)
#Went from 3975 rows to 3875

DELETE FROM laptop_prices_9_23_24.`laptop`
WHERE Ghz = 0;
#222 rows deleted
#Deleted rows where Ghz = 0 b/c the rows did not have a specific processor_name

ALTER TABLE laptop_prices_9_23_24.`laptop`
RENAME COLUMN Price to USD;

UPDATE laptop_prices_9_23_24.`laptop`
SET USD = (USD*0.012);

#9/27 Converted the prices of indian rupee to USD

select
	TRIM(Brand) as Brand,
    TRIM(Processor_Name) AS `CPU`,
    TRIM(Processor_Brand) AS CPU_BRAND,
    TRIM(RAM) AS `RAM(GB)`,
    #Trims unneccesary spaces within the dataset and renamed the columns
    CASE
		WHEN RAM_TYPE = 'RAM'
        THEN 'NA'
        ELSE RAM_TYPE
        END as RAM_TYPE,
		#Subquery to clean data. These lines remove the unneccessary spaces within the data and singles
        #out the values with only 'RAM' and replaces them with 'NA'
	CASE
        TRIM(GPU)
        WHEN INSTR(GPU, ',') = 0
        THEN LEFT(GPU, (INSTR(GPU,' GPU')-1))
		ELSE GPU
        END AS 'GPU',
	#Cleaned out the data to only show the GPU model
    #Currently using MySQL to run the functions, hence why I decided to use this subquery
    #Unable to use CHARINDEX() and SUBSTRING_INDEX() due to MySQL limitations
    CAST(
		(CASE
		WHEN SSD = 'NA'
        THEN 0
        ELSE SSD
		END) AS double) as `SSD(GB)`,
	CAST(
		(CASE
		WHEN HDD = 'NA'
        THEN 0
        ELSE HDD
        END) as double) as`HDD(GB)`,
	#Subquery to clean out the data similar to RAM_TYPE, whereas it replaces NA values with 0 
    #indicating no storage.
    #Purpose is to allow the subquery to convert the data from string into working numbers in order
    #to perform necessary calculations. 
	ROUND(USD, 2) AS USD
    #Converted Indian Rupee to USD then rounded to the nearest hundredths
from
	laptop_prices_9_23_24.`laptop`
where
	USD BETWEEN 500 AND 1000;

