# SQL-Projects

### E-Commerce Data Modeling and Analysis
Dataset - https://www.kaggle.com/competitions/instacart-market-basket-analysis/data

##### Project Description:

In this project, I utilized a dataset from Kaggle to develop a data model and load the data into a PostgreSQL database using Python. The objective was to analyze the data and gain insights using various SQL queries.

To accomplish this, I followed a systematic approach. First, I created temporary tables to facilitate data analysis. The temporary tables were designed to provide information on different aspects of the dataset.

Here are the key analyses performed using the temporary tables:

###### *Reorder Analysis*:  
Calculated the total number of times each product was reordered and the average number of times each product was added to a cart.

###### *Unique Product Analysis*: 
Determined the total number of unique products purchased.

###### *Weekday vs. Weekend Analysis*:
Explored the total number of products purchased on weekdays versus weekends.

###### *Time of Day Analysis*:
Investigated the average time of day when products in each department were ordered.

###### *Popular Aisle Analysis*:
Created a temporary table that grouped the orders by aisle and identified the top 10 most popular aisles. This analysis included the total number of products purchased and the total number of unique products purchased from each aisle.

Finally, I combined the results from all the temporary tables by joining them together. This integration allowed me to create a final table that aligned with the specific requirements of the business manager.

By following this approach, I was able to gain valuable insights from the dataset and present them in a cohesive manner. The project showcased the use of Python for data loading, PostgreSQL for data analysis, and effective SQL queries for extracting meaningful information.



### Instagram Data Modeling and Analysis
In this project, I analyzed a dataset using PostgreSQL, employing various powerful functions and techniques. I started by creating an ER model and a corresponding data model. I then utilized join operations, subqueries, CTE, Window Functions, CASE statements, CTAS, and temporary tables to extract and manipulate the data effectively. The project showcased practical examples and i have provided documentation within the repository.
