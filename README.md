# Fitness-Tracker-Analysis

## Purpose: 
### The goal of this project is to analyze FITBIT fitness data to discover opportunities for Bellabeat’s business. Specifically, I will analyze the consumer data to learn how consumers are using their devices, which will help guide Bellabeat’s marketing direction.

### The goals of my research aim to answer the following questions:

 * What are some trends in smart device usage?
 * How could these trends apply to Bellabeat customers?
 * How could these trends help influence Bellabeat marketing strategy?

### I will follow the steps of the data analysis process: ask, prepare, process, analyze, share, and act.

### Deliverables:

 * A clear summary of the business task
 * A description of all data sources used
 * Documentation of any cleaning or manipulation of data
 * A summary of your analysis
 * Supporting visualizations and key findings
 * Your top high-level content recommendations based on your analysis
 
 ### Estimated time of the Project: 7-9 Days
 
 ## 1. Ask:
 
 ### Business Task: 
 #### The objective is to analyze user data to derive insights into how consumers use fitness products. After uncovering these insights, the analytics team is to apply what they have learned to one Bellabeat product and recommend opportunities for improving or creating new marketing strategies.
 
### Stakeholders:
#### Urška Sršen, Bellabeat’s cofounder and Chief Creative Officer; Sando Mur, Bellabeat’s other cofounder and key team member; and Bellabeat's marketing analytics team.
 

## 2. Prepare:

### The second step for analyzing data is the prepare phase. This phase involves determining what data is appropriate for our analysis, ensuring the data is credible and ethical, as well as properly accessing and organizing the data.

### The data I will be using for this analysis was already provided to me, so I will not be collecting any additional data for this project. Knowing where the data is stored and who created it is an important step in validating the data. The dataset for this project was created by Möbius and is publicly availble on Kaggle, found [here](https://www.kaggle.com/arashnic/fitbit).

### The explanation for each measurment in the dataset is present [here](https://www.fitabase.com/media/1930/fitabasedatad).

### In terms of credibility, on the surface this data shows some concerns. For instance, the data only has 30 unique identifiers, which is an extremely small sample of the entire population. However, in order to fully assess the validity of this dataset, let's see if it "ROCCCs." Below the acronym is filled out, along with a spectrum of ratings where 1 represents a weak aspect of the data and 5 represents a strong aspect of the data.

 R - Reliability (2 out of 5). : It is unclear as to whether the data collected was randomly distributed. In addition, with data collected from only 30 participants, our dataset is quite small and thus possibly not representative of the true population. However, the data seems to be collected from a well-established company (see "Cited" below), which lends it some credibility.

 O - Originality (2 out of 5). : The data was collected from a third-party entity, Amazon Mechanical Turk. There is limited information on how the surveys were collected or distributed, so we can not be sure if they are random. This could be problematic because of its potential for bias - without random sampling we are not getting a true picture of the overall population.

 C - Comprehensive (2 out of 5). : The dataset is not very comprehensive - it only encompasses the data from 30 individuals. Additionally, with the data being collected only over a span of two months, it is not comprehensive. In other words, we are unable to determine whether fitness tech usage changes month-over-month as we are missing 10 months' worth of data.

 C - Current (3 out of 5). : The dataset was released on Kaggle in January 2021, about six months before writing this project. However, the data itself was taken from March 12, 2016 through May 12, 2016. This means the data is 5 years outdated and, subsequently, may not be reliable.

 C - Cited (4 out of 5). : The dataset is cited from a place called Zenodo which, after a brief Google search, seems to be a fairly reputable website where large data can be shared publicly and used by anyone interested in accessing it. In addition, the data is said to be collected from researchers (Robert Furberg, Julia Brinton, Michael Keating, and Alexa Ortiz) from RTI International, a well-established non-profit organization providing research and technical services.

The dataset clearly is not the most comprehensive, so my analysis likely will not fully represent the population. The data provided will help identify trends in Bellabeat users specifically, which is what Bellabeat is looking for; however, the analysis would likely be more representative and insightful if used alongside another dataset and/or additional information collected by Bellabeat.

### After identifying the data' integrity, it is time to prepare the data for analysis.

## 3. Process:

### Tools: R(Statistical Programming Language), one to most comprehensive tools for data cleaning, transforming and visualizing. Different R Packages were used to conduct the aforementioned tasks 

### Ensuring clean data:
 * Check for missing values
 * Check for duplicates
 * Finding Primary Key
 * Checking for Unique ID

### Tranforming data: 
 * Clean column names
 * Convert date and time columns to appropriate type and format
 * Create a weekday column
 * Drop unnecessary columns
 * Creating different dataframes to get data ready to be analysed

## 4. Analyze:

### User Activity data:

![image](https://user-images.githubusercontent.com/90097839/140050271-d9b71fdd-55e6-4343-b084-e06b864043bd.png)

### The number of users of each features are greatly different. Among 33 users participating, there are:
  
 * 72% (24 users) have tried sleep tracking
 * 42% (14 users) have tried heartrate tracking
 * Only 24% (8 users) have tried weight tracking
 * The number of user each day ranges from 21 users in the last day to 33 users, with mean of 30     users
 * The number of user participating starts to drop after 16 days with increasing rate. After 4 weeks, about 1/3 of users stopped using the tracker


### Grouping Users:

![image](https://user-images.githubusercontent.com/90097839/140051154-5410d54c-4284-49b9-92cf-7a81ec88dd0d.png)

### Discussion:
  
 * Low intensity users tend to have an average intensity per day less than 200
 * Light intensity users tend to have an average intensity per day around 250
 * Moderate intensity users tend to have an average intensity per day near 350
 * High intensity users tend to have an average intensity around 400


### Sleep Data:

#### 1. Lack of sleep: users with average sleep time less than 7 hours a day
#### 2. Enough sleep: users with average sleep time from 7 hours or more a day

#### In the sample, 
 * 6 users have lack of sleep and 10 users have average enough sleep.
 * The average hours of "Enough sleep" group is 7.6 hours.
 * The average hours of "Lack of sleep" group is 6.1 hours.


