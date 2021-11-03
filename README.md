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


### Answering Questions:

### Q1: What is the users' sleep pattern among groups?

![image](https://user-images.githubusercontent.com/90097839/140059951-7fe3b9e0-db3d-4a32-bbde-8367c9aa3607.png)

 * Both group sleep the most on Sunday but their other weekdays have seen different sleep trend leading up to Sunday
 * While "Enough sleep" group sleep the least at the middle of the week, users with lack of sleep deprives most sleep on Monday
 * For users with enough sleep, they sleep the more on both saturday and sunday, but for users with lack of sleep, they only sleep more on Sunday

### Users categorized in getting enough sleep: 

![image](https://user-images.githubusercontent.com/90097839/140060909-f50c48cb-26a9-4b9c-934c-2ea64aa086e6.png)

 * Users with lack of sleep have to go through longer hours of restlessness, which may be part of the reason.


### Q2: What is the tracking feature usage trend?

![image](https://user-images.githubusercontent.com/90097839/140061522-49a766bf-7a6b-4ae4-af8f-c62bc90c18d8.png)

 * Most users in every group used sleep tracking feature
 * A portion of user in each groups may be willing to try out other tracking features such as heartrate or weight
 * Moderate intensity and high intensity users tend to measure their weight and heart rate also
 * However, the sample is small and should be investigated with a larger scale to reach a conclusion


### Q3: What is the trend in user daily usage?
#### Number of day used by each groups

![image](https://user-images.githubusercontent.com/90097839/140062356-959c3fc9-9ade-47ff-a12b-4219107dc309.png)


### Discussion:
  
 * There are not much difference in the average usage days among groups
 * Interestingly, even if the user have low or light intensity, they tend to stick with the tracking system as long as high int

### Q4: What is the trend of users' activity?
#### Active and Inactive periods in a day
##### Average daily active minutes

![image](https://user-images.githubusercontent.com/90097839/140062734-3d4043cf-7bef-4b6e-b68c-6321fea0802b.png)

### Discussion:
  
 * High intensity group mainly performs active sessions in their active periods, while moderate intensity group has more equal amount of very active minutes and fairly active minutes
 * Low intensity and light intensity group have very short active periods throughout their day

#### Active minutes throughout days of week

![image](https://user-images.githubusercontent.com/90097839/140063463-9ee97a70-38de-4eeb-9ed4-245df1a1000f.png)

### Discussion:
  
 * High intensity group has consistent routine for their active minutes, they make sure that they spend more than an hour every day for active activities, and more active in the start and end of the week
 * Moderate group has around 30 - 50 minutes of active minutes each day, with the lowest days are Sunday and Thrusday
 * Low intensity group and Light intensity group have less than 20 minutes of active minutes each day

#### Lightly active and inactive periods comparison among groups
##### Average lightly and inactive hours

![image](https://user-images.githubusercontent.com/90097839/140063964-4ef6b482-c5de-4d61-8df5-9cacb6cd2e14.png)

### Discussion:
  
 * There is abnormal amount of sedentary hours among low intensity users. This indicate the measured data might be inaccurate due to devices not working, or this group of user had to sit for too long and do not need to move throughout their day. They have very low activity time throughout the days for all types of active activities

#### Inactive and lightly hour throughout days of week

![image](https://user-images.githubusercontent.com/90097839/140064290-4386e8a9-a7e9-41ff-b081-2e1e4157000e.png)

 * Surprisingly, High intensity group users also have higher sedentary minutes than moderate and light intensity groups. This is probably due to they actively track their activity more frequently than other groups.
 * For others, they may neglect their tracking devices in cases when out of batteries or not tracker not working.

#### Intensity among groups
##### Intensity throughout days of week

![image](https://user-images.githubusercontent.com/90097839/140064486-db8b135f-623f-448f-87e3-b7163f8e448c.png)

### Discussion:
  
 * High intensity group: Intensity is high throughout
 * Moderate intensity: They have high intensity but have inconsitent pattern between each day of week
 * Light intensity: They have relatively high level of intensity at the end of week, and rest on sunday
 * Low intensity: low intensity throughout the wee

#### Intensity throughout the day
##### Light and low intensity group

![image](https://user-images.githubusercontent.com/90097839/140064687-df481185-58d5-4986-9d23-0f121c28400e.png)

### Discuss:
  
 * Low intensity group: intensity throughout week is consistent, which tend to the value peaks at noon time
* Light intensity group: on weekday, they are more active in the afternoon and evening, while on weekend, their most active period is at noon

#### Moderate and High intensity groups


