# Nashville Housing Prices Analysis

## Project Description

This project focuses on analyzing housing prices data from Nashville city in Tennessee. The analysis involves data exploration and cleaning using Excel and SQL, followed by visualization of key insights with Tableau. 

## Data Cleaning and Exploration

We cleaned and explored the dataset using SQL to find trends and provide insights to stakeholders. The following steps were taken to clean the data:

1. **Standardize Date Format**: Ensured consistency in date representation across the dataset.
2. **Populate Property Address Data**: Replaced null values in the property address column.
3. **Break Out the Address into Individual Columns**: Split the address into separate columns for address, city, and state to handle excessively long address entries.
4. **Break Out the Owner Address into Individual Columns**: Similarly, split the owner address into separate columns for address, city, and state.
5. **Change 'Y' and 'N' to 'Yes' and 'No' in "Sold as Vacant" Field**: Ensured the field values were either 'Yes' or 'No', replacing any 'Y' or 'N'.
6. **Remove Duplicates**: Eliminated any duplicate records in the dataset.
7. **Order by ParcelID**: Sorted the dataset by the ParcelID column for better organization.

## Visualizations

We used Tableau to visualize the cleaned data, focusing on the following key insights:

1. **Average Sale Price by Land Value**: We explored the sale prices by different land categories and visualized the price differences in a clear and comprehensible table.
2. **Property Sale Trends by City**: Created a bar graph to illustrate the average sale prices across different cities within Nashville.

![Dashboard](https://github.com/SamirG-ov/PortfolioProjects/assets/47461720/dfc67c86-5042-4bd8-a621-30a215ead34a)

## Tools Used

- **Excel**: Initial data exploration and basic cleaning.
- **SQL**: Data cleaning and transformation.
- **Tableau**: Data visualization.

## Conclusion

This project provides a comprehensive analysis of housing prices in Nashville, Tennessee, using SQL for data cleaning and Tableau for visualization. The insights derived from this analysis can be valuable for stakeholders in making informed decisions.
