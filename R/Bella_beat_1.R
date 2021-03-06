## Business Task
## Analyze smart device usage data in order to gain insight into how consumers use non-Bellabeat smart devices and provide high-level recommendation for Bellabeat's marketing strategy. The main questions include:
  
##  What are some trends in smart device usage?
##  How could these trends apply to Bellabeat customers?
##  How could these trends help influence Bellabeat marketing strategy?

## User's tendency to use different tracking features
## User's activity and exercise trend
## User's sleep pattern

## 3. Prepare data
## Fitabit dataset

## These datasets were generated by respondents to a distributed survey via Amazon Mechanical Turk between 03/12/2016-05/12/2016. Thirty eligible Fitbit users consented to the usage of their personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. Individual reports can be parsed by export session ID (column A) or timestamp (column B). Variation between output represents use of different types of Fitbit trackers and individual tracking behaviors / preferences.

## The explanation for each measurment in the dataset is present here: https://www.fitabase.com/media/1930/fitabasedatad



install.packages("skimr")
install.packages("janitor")
install.packages("tidyverse")
install.packages("dpylr")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("ggpubr")
install.packages("rmarkdown")

library(skimr)
library(janitor)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggpubr)

#Import data
daily_activity <- dailyActivity_merged
hourly_calories <- hourlyCalories_merged
hourly_intensities <- hourlyIntensities_merged
hourly_steps <- hourlySteps_merged
daily_sleep <- sleepDay_merged
weight <- weightLogInfo_merged
heartrate <- heartrate_seconds_merged
minute_sleep <- minuteSleep_merged

## 4. Process Data 

#Check missing values
sum(is.na(daily_activity)) #No missing value
sum(is.na(hourly_calories)) #No missing value
sum(is.na(hourly_intensities)) #No missing value
sum(is.na(hourly_steps)) #No missing value
sum(is.na(daily_sleep)) #No missing value
sum(is.na(weight)) #65 missing values in the Fat columns

## Most users do not enter the Fat column. This is probably because most people do not want to measure or lack equipment to their fat on a regular basis.

#Check for duplicates
sum(duplicated(daily_activity)) #No duplicates
sum(duplicated(hourly_calories)) #No duplicates
sum(duplicated(hourly_intensities)) #No duplicates
sum(duplicated(hourly_steps)) #No duplicates
sum(duplicated(daily_sleep)) # 3 duplicates
daily_sleep <- distinct(daily_sleep) #Remove duplicates
sum(duplicated(weight)) #No duplicates

## I removed 3 duplicated rows from daily_sleep table

#What do these datasets involve?
colnames(daily_activity)
colnames(hourly_calories)
colnames(hourly_intensities)
colnames(hourly_steps)
colnames(daily_sleep)
colnames(weight)

## The primary key for this data set is user id's.
## In daily tables, there is a date column, followed by the data of the respective day.
## In hourly tables, there is a datetime column showing each hour in the day, followed by data of the respective hour.

##Checking for Unique Id's
n_distinct(daily_activity$Id)
n_distinct(hourly_calories$Id)
n_distinct(hourly_intensities$Id)
n_distinct(hourly_steps$Id)
n_distinct(daily_sleep$Id)
n_distinct(weight$Id)

## The number of users of each features are greatly different. Among 33 users participating, there are:
  
## 72% (24 users) have tried sleep tracking
## 42% (14 users) have tried heartrate tracking
## Only 24% (8 users) have tried weight tracking

## However, the date and time columns are in character type, and the names are not cleaned. Thus, next, I will move through each of table and perform data transformation, including:
  
## Clean column names
## Convert date and time columns to appropriate type and format
## Create a weekday column
## Drop unnecessary columns

## Transform Data

# Create activity dataframe
activity <- daily_activity %>%
  clean_names() %>%
  mutate(activity_date = mdy(activity_date),
         weekday = weekdays(activity_date)) %>%
  mutate(weekday = fct_relevel(weekday, 
                               c("Monday","Tuesday","Wednesday",
                                 "Thursday","Friday",
                                 "Saturday","Sunday"))) %>%
  rename(date = activity_date, steps = total_steps, 
         distance = total_distance) %>%
  select(-c(5:10))
head(activity)

# Create sleep dataframe
sleep <- daily_sleep %>%
  clean_names() %>%
  separate(col = sleep_day, into = c('date','time'), sep = " ") %>%
  mutate(date = mdy(date), weekday = weekdays(date)) %>%
  mutate(weekday = fct_relevel(weekday, 
                               c("Monday","Tuesday","Wednesday",
                                 "Thursday","Friday",
                                 "Saturday","Sunday"))) %>%
  rename(records = total_sleep_records, 
         asleep = total_minutes_asleep, in_bed = total_time_in_bed) %>%
  mutate(asleep_hr = asleep/60, in_bed_hr = in_bed/60) %>%
  select(-time)
head(sleep)

# Create weight dataframe
weight <- weight %>%
  clean_names() %>%
  separate(col = date, into = c('date','time'), sep = " ") %>%
  mutate(date = mdy(date)) %>%
  select(-c(time, log_id, weight_pounds))
head(weight)

# Create activity_hr dataframe
activity_hr <- hourly_intensities %>%
  full_join(hourly_steps, by = c("Id", "ActivityHour")) %>%
  full_join(hourly_calories, by = c("Id", "ActivityHour")) %>%
  clean_names() %>%
  separate(col = activity_hour, into = c('date','time','AM/PM'), sep = " ") %>%
  unite(time, c('time', 'AM/PM'), sep = " ", remove = TRUE) %>%
  mutate(date = mdy(date), weekday = weekdays(date), 
         time = format(parse_date_time(time,'%I:%M:%S %p'), format = "%R")) %>%
  mutate(weekday = fct_relevel(weekday, c("Monday","Tuesday","Wednesday",
                                          "Thursday","Friday",
                                          "Saturday","Sunday")))
head(activity_hr)

# Prepare heartrate dataframe, because I just analyse participation of users in heartrate tracking, I just keep id and date column
heartrate2 <- heartrate %>%
  clean_names() %>%
  mutate(time = mdy_hms(time), date = as.Date(time)) %>%
  select(c(id,date)) %>%
  distinct()
head(heartrate2)

# Prepare sleep minutes data
sleep_min <- minute_sleep %>%
  clean_names() %>%
  separate(col = date, into = c('date','time', 'AM/PM'), sep = " ") %>%
  unite(time, c('time','AM/PM'), sep = " ", remove = TRUE) %>%
  mutate(date = mdy(date), time = format(parse_date_time(time, '%I:%M:%S %p'), 
                                         format = "%R"),
         sleep_status = case_when(value == 1 ~ "asleep",
                                  value == 2 ~ "restless",
                                  value == 3 ~ "awake")) %>%
  select(-c(value,log_id))
head(sleep_min)

## 5. Analyse Data

## User Activity Data
user_activity <- activity %>%
  full_join(sleep, by = c("id","date")) %>%
  full_join(heartrate2, by = c("id","date")) %>%
  full_join(weight, by = c("id","date")) %>%
  select(c(1:2)) %>%
  mutate(used_sleep = id %in% sleep$id & date %in% sleep$date, 
         used_activity = id %in% activity$id & date %in% activity$date,
         used_heartrate = id %in% heartrate2$id & date %in% heartrate2$date,
         used_weight = id %in% weight$id & date %in% weight$date) %>%
  group_by(date) %>%
  summarise(activity = sum(used_activity), sleep = sum(used_sleep), heartrate = sum(used_heartrate), weight = sum(used_weight)) %>%
  gather(key= "key", value = "value", sleep, activity, heartrate, weight)
ggplot(user_act) + geom_line(mapping = aes(x=date,y=value,color = key)) + ggtitle("The Participation Trends of User in the period") + labs(x="Date", y ="Number of users") 

summary(user_act$no_id)

## The number of user each day ranges from 21 users in the last day to 33 users, with mean of 30 users

## The number of user participating starts to drop after 16 days with increasing rate. After 4 weeks, about 1/3 of users stopped using the tracker

### Sleep data
# Create sleep id participation
par_sleep_id <- 
  group_by(sleep, id) %>%
  summarise(no_day = length(unique(date)))

# Filter for sleep data
sleep_drop_id <- par_sleep_id %>%
  filter(no_day <= 5) %>%
  pull(id)
sleep_drop_id

## These users participate from 5 days to below so I drop

# Drop low participating users
sleep_new <- filter(sleep, !id %in% sleep_drop_id)
sleep_min_new <- filter(sleep_min, !id %in% sleep_drop_id)
length(unique(sleep_new$id)) # 16 users left

## After dropping 5 ids, the number of current unique ids left in the sleep tables is 16 ids

## Grouping User

## High intensity: in the 4th quartile of mean intensity of users
## Moderately intensity: in the 3rd quartile of mean intensity of users
## Light intensity: in the 2nd quartile of mean intensity of users
## Low intensity: in the 1st quartile of mean intensity of users
## To make sure users who participate too little may affect the group calculation. Thus, I only select users who participate more than 5 d

# Create a participation dataframe
par_act_id <-
  group_by(activity, id) %>%
  summarise(no_day = length(unique(date)))
# Filter activity data
act_drop_id <- par_act_id %>%
  filter(no_day <= 5) %>%
  pull(id)
act_drop_id

## User with Id 4057192912 only participates for 4 days, thus I drop this user ID from the analysis
# Drop user id
activity_new <- filter(activity, !id %in% act_drop_id)
length(unique(activity_new$id)) # 32 users 
activity_hr_new <- filter(activity_hr, !id %in% act_drop_id)
length(unique(activity_hr_new$id)) # 32 users

## After dropping 1 id, the number of unique ids in the activity tables are 32 ids

# Group users based on average intensity per day
intensity_day <- subset(activity_hr_new, select = c(id,date, total_intensity)) %>%
  group_by(id, date) %>%
  summarise(intensity_perday = sum(total_intensity))
intensity_group <- intensity_day %>%
  group_by(id,.add = TRUE) %>%
  summarise(avg_intensity_perday = mean(intensity_perday)) %>%
  mutate(quartile = as.character(as.numeric(cut(avg_intensity_perday, 
                                                quantile(avg_intensity_perday, 
                                                         probs=c(0, 0.25,0.5, 0.75, 1)), 
                                                include.lowest=TRUE))),
         group = case_when(quartile == "1" ~ "Low intensity",
                           quartile == "2" ~ "Light intensity",
                           quartile == "3" ~ "Moderate intensity",
                           quartile == "4" ~ "High intensity")) %>%
  mutate(group = fct_relevel(group, c("Low intensity","Light intensity", 
                                      "Moderate intensity", "High intensity")))
head(intensity_group)

#Plot overview of the 4 groups
ggplot(intensity_group, aes(y=avg_intensity_perday,x=group)) + 
  geom_boxplot(aes(fill = group)) + ggtitle("User Groups Based on Average Intenisty") +
  labs(x = "Group", y="Average Intensity Per Day") + theme(legend.title = element_blank(), 
                                                           legend.position =  "bottom")
## Discussion:
  
## Low intensity users tend to have an average intensity per day less than 200
## Light intensity users tend to have an average intensity per day around 250
## Moderate intensity users tend to have an average intensity per day near 350
## High intensity users tend to have an average intensity around 400

# Id list of each user in the groups:
high_int_ids <- intensity_group %>%
  filter(group == "High intensity") %>%
  pull(id)
high_int_ids
moderate_int_ids <- intensity_group %>%
  filter(group == "Moderate intensity") %>%
  pull(id)
moderate_int_ids
light_int_ids <- intensity_group %>%
  filter(group == "Light intensity") %>%
  pull(id)
light_int_ids
low_int_ids <- intensity_group %>%
  filter(group == "Low intensity") %>%
  pull(id)
low_int_ids

## Move on to sleep data, I group users into 2 groups based on average sleep time:

## Lack of sleep: users with average sleep time less than 7 hours a day
## Enough sleep: users with average sleep time from 7 hours or more a day

sleep_state <- sleep_new %>%
  group_by(id) %>%
  summarise(asleep = mean(asleep_hr)) %>%
  mutate(state = case_when(asleep < 7 ~ "Lack of sleep", 
                           asleep >= 7 ~ "Enough sleep"))
lack_sleep <- sleep_state %>%
  filter(state == "Lack of sleep")
full_sleep <- sleep_state %>%
  filter(state == "Enough sleep")

# Summary of 2 groups
length(unique(lack_sleep$id))
summary(lack_sleep$asleep)
length(unique(full_sleep$id))
summary(full_sleep$asleep)

## In the sample, 6 users have lack of sleep and 10 users have average enough sleep.
## The average hours of "Enough sleep" group is 7.6 hours.
## The average hours of "Lack of sleep" group is 6.1 hours.

## Answering questions

## Q1: What is the users' sleep pattern among groups?

sleep_state %>% 
  select(-c(asleep)) %>%
  inner_join(sleep_new, by = "id") %>%
  group_by(weekday,state) %>%
  summarise(asleep_hr = mean(asleep_hr)) %>%
  ggplot(aes(x = weekday, y = asleep_hr, fill = state)) + geom_bar(stat = "identity") + facet_grid(~state) + ggtitle("Trend of Sleep hours of users") + labs(x="Weekday",y="Sleep Hours")

## Both group sleep the most on Sunday but their other weekdays have seen different sleep trend leading up to Sunday
## While "Enough sleep" group sleep the least at the middle of the week, users with lack of sleep deprives most sleep on Monday
## For users with enough sleep, they sleep the more on both saturday and sunday, but for users with lack of sleep, they only sl

## Users categorized in getting enough sleep

sleep_state %>%
  select(-asleep) %>%
  right_join(sleep_min_new, by = "id") %>%
  group_by(date,state,sleep_status) %>%
  summarise(avg_hour = mean(n())/60) %>%
  filter(sleep_status == "restless"| sleep_status == "awake") %>%
  ggplot() + geom_bar(aes(x=sleep_status, y=avg_hour,fill=state), position = "dodge",stat = "identity") + ggtitle("Comparison of awake and restless hours","Between Lack of sleep users and Enough sleep users") + labs(x="Sleep status", y = "Hours")

## Users with lack of sleep have to go through longer hours of restlessness, which may be part of the reason.

##Q2: What is the tracking feature usage trend?

#Obtain feature usage data by groups
usage_by_fea <- intensity_group %>%
  mutate(used_sleep = id%in%sleep$id, used_heartrate = id%in%heartrate2$id, used_weight = id%in%weight$id) %>%
  gather(key = "feature", value = "usage", 
         c(used_sleep, used_heartrate, used_weight)) %>% #reshape to long format
  select(-c(avg_intensity_perday, quartile))
#Plot grouped bar chart
ggplot(usage_by_fea, aes(x=group, y=as.numeric(usage), fill = feature)) + 
  stat_summary(fun = sum, geom = "bar", position = "dodge") + 
  ggtitle("Features usage among groups") +
  labs(x = "Group", y="Number of users") + theme(legend.title = element_blank(), 
                                                 legend.position =  "top")

## Most users in every group used sleep tracking feature
## A portion of user in each groups may be willing to try out other tracking features such as heartrate or weight
## Moderate intensity and high intensity users tend to measure their weight and heart rate also
## However, the sample is small and should be investigated with a larger scale to reach a conclusion


##Q3: What is the trend in user daily usage?
##Number of day used by each groups

#Obtain usage data of each user groups
usage_by_day <- intensity_group %>%
  inner_join(activity, by = "id") %>%
  select(c(id,date,group)) %>%
  group_by(group,id) %>%
  summarise(no_day = length(date))
#Plot bar chart
ggplot(usage_by_day, aes(x=group, y = no_day,)) + 
  stat_summary(geom = "bar", fun = "mean",fill = "#FF6666") +
  ggtitle("Average Number of Usage Days Among Groups") +
  labs(x = "Group", y="Number of days")

## Discussion:
  
## There are not much difference in the average usage days among groups
## Interestingly, even if the user have low or light intensity, they tend to stick with the tracking system as long as high int

##Q4: What is the trend of users' activity?
##Active and Inactive periods in a day
##Average daily active minutes

# Obtain active minutes by groups
active_min <- intensity_group %>%
  inner_join(activity , by = "id") %>%
  select(c(id,group,very_active_minutes,fairly_active_minutes)) %>%
  group_by(group, id) %>%
  summarise(very_active_minutes = round(mean(very_active_minutes)),
            fairly_active_minutes = round(mean(fairly_active_minutes))) %>%
  gather(key = "active_type", value = "minutes", very_active_minutes, fairly_active_minutes)

# Plot box plot
ggplot(active_min,aes(x=group, y= minutes, fill = group)) + geom_boxplot() + 
  geom_hline(yintercept = mean(active_min$minutes), color = "blue") + xlab("User Group") + 
  ylab("Minutes") + ggtitle("Comparison of Active Minutes by User Group","Average active minutes is 17.3") + 
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),legend.title = element_blank()) + 
  theme(legend.position = "top") + facet_wrap(~active_type)

## Discussion:
  
## High intensity group mainly performs active sessions in their active periods, while moderate intensity group has more equal amount of very active minutes and fairly active minutes
## Low intensity and light intensity group have very short active periods throughout their day

##### Active minutes throughout days of week

# Obtain active minutes by weekday
active_min_weekday <- intensity_group %>%
  inner_join(activity , by = "id") %>%
  select(c(id,group,date,very_active_minutes,fairly_active_minutes,weekday)) %>%
  gather(key = "active_type", value = "minutes", 
         very_active_minutes, fairly_active_minutes)
#Stacked Bar plot 
ggplot(active_min_weekday) + 
  geom_bar(mapping = aes(x=weekday, y = minutes, fill = active_type), 
           stat ="summary", fun="mean", position = "stack") + 
  theme(legend.position = "top", legend.title = element_blank(),
        axis.text.x = element_text(angle = 30,size=6)) + 
  facet_grid( ~ group) + ggtitle("Weekday Active Minutes by Groups") + 
  labs(x="Weekday", y="active minutes")

## Discussion:
  
##  High intensity group has consistent routine for their active minutes, they make sure that they spend more than an hour every day for active activities, and more active in the start and end of the week
## Moderate group has around 30 - 50 minutes of active minutes each day, with the lowest days are Sunday and Thrusday
## Low intensity group and Light intensity group have less than 20 minutes of active minutes each day

##Lightly active and inactive periods comparison among groups
##Average lightly and inactive hours

# Obtain inactive and lightly active hours by group
inactive_hour <- intensity_group %>%
  inner_join(activity , by = "id") %>%
  select(c(id,group,lightly_active_minutes,sedentary_minutes)) %>%
  group_by(group, id) %>%
  summarise(lightly_active_hours = round(mean(lightly_active_minutes)/60),
            sedentary_hours = round(mean(sedentary_minutes)/60)) %>%
  gather(key = "active_type", value = "hours", lightly_active_hours, sedentary_hours)
# Boxplot
ggplot(inactive_hour,aes(x=group, y= hours, fill = group)) + geom_boxplot() + 
  geom_hline(yintercept = mean(inactive_hour$hours), color = "blue") + xlab("User Group") + 
  ylab("Hours") + ggtitle("Comparison of Inactive and Lightly Active Hours by User Group","Average inactive and lightly active hours is 9.8 hours") + 
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(),legend.title = element_blank()) + 
  theme(legend.position = "top") + facet_wrap(~active_type)

## Discussion:
  
## There is abnormal amount of sedentary hours among low intensity users. This indicate the measured data might be inaccurate due to devices not working, or this group of user had to sit for too long and do not need to move throughout their day. They have very low activity time throughout the days for all types of active activities

##Inactive and lightly hour throughout days of week

inactive_minutes_weekday <- intensity_group %>%
  inner_join(activity , by = "id") %>%
  select(c(id,group,date,lightly_active_minutes,sedentary_minutes,weekday)) %>%
  gather(key = "active_type", value = "minutes", lightly_active_minutes, sedentary_minutes)
ggplot(inactive_minutes_weekday) + 
  geom_bar(mapping = aes(x=weekday, y = minutes/60, fill = active_type), 
           stat ="summary", fun="mean", position = "stack") + 
  theme(legend.position = "top", legend.title = element_blank(),
        axis.text.x = element_text(angle = 30,size=6)) + 
  facet_grid( ~ group) + ggtitle("Weekday Inactive and Lightly Active Hours by Groups") + 
  labs(x="Weekday", y="Hours")

inactive_minutes_weekday_1 <- inactive_minutes_weekday%>% select(c(id)) %>% filter(group == "Low intensity")
View(inactive_minutes_weekday_1)
n_distinct(inactive_minutes_weekday_1$id)

## Surprisingly, High intensity group users also have higher sedentary minutes than moderate and light intensity groups. This is probably due to they actively track their activity more frequently than other groups.
## For others, they may neglect their tracking devices in cases when out of batteries or not tracker not working.

##Intensity among groups
##Intensity throughout days of week

intensity_weekday <- intensity_day %>%
  inner_join(intensity_group, by = 'id') %>%
  mutate(weekday = weekdays(date)) %>%
  mutate(weekday = fct_relevel(weekday,c("Monday","Tuesday","Wednesday",
                                         "Thursday","Friday","Saturday","Sunday"))) %>%
  select(-c(quartile, avg_intensity_perday))
ggplot(intensity_weekday, aes(x = weekday, y = intensity_perday, fill = group)) + 
  geom_bar(stat='summary', fun = 'mean',position = "stack") + 
  theme(legend.position = "top", legend.title = element_blank(),
        axis.text.x = element_text(angle = 30,size=6)) + 
  facet_grid(~group) + ggtitle("Level of Intensity by User Groups throughout Week") +
  labs(x="Weekday",y="Average Intensity")

## Discussion:
  
##  High intensity group: Intensity is high throughout
## Moderate intensity: They have high intensity but have inconsitent pattern between each day of week
## Light intensity: They have relatively high level of intensity at the end of week, and rest on sunday
## Low intensity: low intensity throughout the wee

##Intensity throughout the day
##Light and low intensity group

intensity_hr <- activity_hr_new %>%
  select(c(id,date,time,total_intensity,weekday)) %>%
  left_join(intensity_group, by = "id")
intensity_hr %>%
  group_by(group,weekday,time) %>%
  summarise(intensityhr = mean(total_intensity)) %>%
  filter(group == "Light intensity" | group == "Low intensity") %>%
  ggplot(aes(x=time, y=intensityhr, fill = intensityhr))+ 
  scale_fill_gradient(low = "#FFC058", high = "#623E9D")+
  geom_bar(stat = 'identity', show.legend = TRUE) +
  coord_flip() +
  ggtitle("Intensity By Hours", "Low and Light Intensity group") +
  xlab("Hour") + ylab("Intensity") + labs(fill = "Intensity value") +
  theme(axis.text.x = element_text(size=6), axis.text.y = element_text(size=5))+
  theme(legend.position = "top")+
  facet_grid(group~weekday)

## Discuss:
  
## Low intensity group: intensity throughout week is consistent, which tend to the value peaks at noon time
## Light intensity group: on weekday, they are more active in the afternoon and evening, while on weekend, their most active period is at noon

## Moderate and High intensity groups

intensity_hr %>%
  group_by(group,weekday,time) %>%
  summarise(intensityhr = mean(total_intensity)) %>%
  filter(group == "Moderate intensity" | group == "High intensity") %>%
  ggplot(aes(x=time, y=intensityhr, fill = intensityhr))+ 
  scale_fill_gradient(low = "#2AF203", high = "#151E11")+
  geom_bar(stat = 'identity', show.legend = TRUE) +
  coord_flip() +
  ggtitle("Intensity By Hours", "Moderate and High Intensity group") +
  xlab("Hour") + ylab("Intensity") + labs(fill = "Intensity value") +
  theme(axis.text.x = element_text(size=6), axis.text.y = element_text(size=5))+
  theme(legend.position = "top")+
  facet_grid(group~weekday)

## Discuss:
  
## These 2 groups tend to have certain very active hour each day throughout the week
## However, for moderate intensity group, there are different active periods between weekend and weekdays, in weekend they are more active at noon while on weekdays, their peak hours are the evening
## The peak active hours are from 17:00 to 19:00

##Q5: What is the correlation between steps and intensity among groups?
  
activity_group <- activity_new %>%
  inner_join(intensity_group, by = "id") %>%
  inner_join(intensity_day, by=c("id","date")) %>%
  select(-c(4, 11:12))

ggscatter(activity_group, x = "intensity_perday", y="steps",color = "group", cor.coef = TRUE, facet.by = "group", ellipse = TRUE, cor.coef.size = 7, ggtheme = theme_bw()) + geom_smooth() + ggtitle("Correlation between Steps and Intensity","Between groups") + labs(x = "Intensity", y = "Steps") 


