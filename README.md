# CSV-Files
Original Dataset
- [Laptop Dataset By Pradeep Jangir]
- (https://www.kaggle.com/datasets/pradeepjangirml007/laptop-data-set)

# Collection of Data Used
- "9_26_24_Laptop prices_transformed.csv" 
- "9_26-24_laptop_prices_trasformed - Summary of Laptop Specifications Based on Brand.csv"
- "9_26_24_Laptop prices_transformed - Summary of Laptops Between 500 - 1000 USD.csv"
- "9_26_24_Laptop_prices_transformed - Laptops Between 500 - 1000 USD.csv"

# Code Used
- SQL - Used MySQL Workbench 8.0 CE
- Note: There is no import Schema/table in SQL script due to using the onboard features of MySQL ("Create Schema" > "Table Data Import Wizard").
- Note: After running script for the first time, remove lines 65-66 and 68-69.

# Link to Tableau Dashboard
https://public.tableau.com/views/LaptopSpecificationsDataset/SummaryofDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

# Laptop Specifications Case Study:
This study is focuses on the observation on the laptop market and their specifications. The purpose behind this study is to plan how digital programs will be made surrounding these components. To be clear, these specifications are meant to focus on the majority of consumer devices rather than everyone. This is important because it allows businesses/companies, or smaller indie game developers, to understand how their application should be developed surrounding the user limitations. This in turn encourages more consumers to continue/start using the application due to its optimization on current hardware. 

Note that this is a personal project and that it was all conducted out of curiosity/personal interest.

# Summary

## Intro
Like many other devices, laptops have a CPU, GPU, and RAM. These components determine the performance of the application on the user's device. To clarify, the combination of components determine the overall usability of the application for consumers. The overall budget limitations determine what companies put into their devices. Understanding the common price range laptops are being sold at and their components allows developers to determine what they can do with their application in order to increase usability of the digital application.

## Tools Used
- Kaggle (Source of Dataset)
- Excel (Clean the data and create visualizations)
- [SQL (Clean and format the data)](https://github.com/jehnsun/case_study_laptop_specifications_9_23_24/blob/main/SQL%20script%20for%20laptops.sql)
- [Tableau (More visualizations)](https://public.tableau.com/views/LaptopSpecificationsDataset/SummaryofDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Conclusion
Majority of laptops in the market are within the price range of 500 to 1000 USD. In order for companies to fit within budget contraints, many of these laptops contain either an 11th gen, 12th gen, Intel Core i5, or a AMD Hexa-Core Ryzen 5 as the main choice of CPU (Processor). Secondly, companies use the Iris Xe and Integrated Graphics as the main GPU. Finally, companies use DDR4 as the main source of RAM. These specifications identify the starting point companies should use to understand what to develop their application around. 

## Where to Go From Here?
Today - Identify the goals/focus of the digital program

Tomorrow - Use the laptop specifications as a starting point to determine limitations. Determine basic and recommended specifications required to run the program

Next Year - Evaluate potential bugs that could occur with consumer devices and improve optimization based on feedback. Create a roadmap of potential features that could improve on the overall user expereince and how it can be built upon existing hardware. 

Please contact Johnson Vo (johnsonvo277@gmail.com) with any questions.

## Code

```SQL
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
```
