

# Introduction

I will be walking you through the Bellabeat case study project I completed as part of the Google Data Analytics Professional Certificate. This tutorial would be used to walk my team of analysts at Bellabeat through my steps and thought processes while deriving insights from this data set. I will include project overview in the form of a statement of the business task, data overview, data clean up documentation, summary of data analysis, and a summary of insights that would be presented to senior executives.

## Project Overview - Business Task

In this project, I will be using competitor data to explore daily habits of current consumers of smart devices. This insight will help guide marketing and development strategies for Bellabeat.

In this dataset, I chose to focus on: feature usage, times of usage, and sleep trends. To guide my analysis, the following research questions were posed:

1.  What features of the FitBit are most used?
    -   Is there a relationship between engagement of a feature and activity?
2.  What times do users log in steps?
    -   Does this change with activity intensity?
3.  Is there a relationship between sleep and activity?
    -   Does sleep delay, as a measure of sleep quality, change with respect to activity?

## Data Overview

### Source

The chief creative officer of Bellabeat would like my insights to be derived from [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit), a CC0: Public Domain data set published on Kaggle.com by user Mobius. This data was collected via the crowdsourcing website for businesses, Amazon Mechanical Turk (MTurk) over 31 days in 2016. The researchers who collected this data originally published it on [Zenodo](https://zenodo.org/record/53894#.YMoUpnVKiP9). The aim of the researchers was to establish a protocol where fitness data could be collected remotely.

Sources:

[Furberg, R., Brinton, J., Keating, M., & Ortiz, A. (2016). Crowd-sourced Fitbit datasets 03.12.2016-05.12.2016 [Data set]. Zenodo. https://doi.org/10.5281/zenodo.53894](https://zenodo.org/record/53894#.YMoUpnVKiP9)

[Brinton JE, Keating MD, Ortiz AM, Evenson KR, Furberg RD. Establishing Linkages Between Distributed Survey Responses and Consumer Wearable Device Datasets: A Pilot Protocol. JMIR Res Protoc. 2017 Apr 27;6(4):e66. doi: 10.2196/resprot.6513. PMID: 28450274; PMCID: PMC5427248.](https://www.researchprotocols.org/2017/4/e66/).

### Integrity

Mturk is a platform that allows users (Mturkers) to sign up for Human Intelligence Tasks (HIT), usually part of online research studies, and receive monetary compensation. Studies like the one previously cited, opt to use Mturk because it is low cost, the availability of online research support from the site, and the ability to acquire a vast amount of data from a demographically diverse sample (Brinton et al., 2017).

The authors of the study obtained approval from the RTI International Institutional Review Board. Participants were asked to track the following: weight, diet, exercise, blood pressure, blood sugar, sleep patterns, and negative symptoms such as headaches. This study required participants to be at least 18 years old, regularly wear a FitBit device, and consent to submitting their FitBit data.

While studies show that the Mturk platform can reach a more diverse sample than other social media platforms (Brinton et al., 2017), the Mturk platform has room for biases that must be addressed. For example, Mturkers are much less diverse than the US populations in areas such as political views, education, age, and religious views, making data less generalizable (Litman, 2020).

Users are ranked based on a reputation mechanism, or the rate at which they are approved by requestors, or sponsors of the HIT. When researchers only choose Mturkers with high reputations, they are methodically reducing their eligible sample. However, Peer, Vosgerau, and Acquisti (2014) demonstrated that this does not reduce the diversity of the sample.

Based on the above data integrity research, this dataset is deemed appropriate to address the business task.

Sources:

[Litman, L. (2020). Strengths and Limitations of Mechanical Turk. CloudResearch. Retrieved October 21, 2022, from https://www.cloudresearch.com/resources/blog/strengths-and-limitations-of-mechanical-turk/](https://www.cloudresearch.com/resources/blog/strengths-and-limitations-of-mechanical-turk/)

[Peer, E., Vosgerau, J. & Acquisti, A. Reputation as a sufficient condition for data quality on Amazon Mechanical Turk. Behav Res 46, 1023--1031 (2014). https://doi.org/10.3758/s13428-013-0434-y](https://link.springer.com/article/10.3758/s13428-013-0434-y#citeas)

### Summary

Thirty-three FitBit users consented to submit personal data using their FitBit trackers, including minute-level physical activity, physiological markers, and monitoring markers.

There are 18 csv files in the [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit). To answer my research questions, I used 4 of those csv files: daily_activity, sleep_logs, weight_logs, and steps_hour.

### Limitations

The sample size is small at 33 participants. The Central Limit Theorem states that a sample size of at least 30 is often sufficient to trust that the sample mean is approximately equal to the population mean. However, the larger the sample, the better the sample mean is representative of the population mean.

This data set does not include demographic data on participants of this study. Bellabeat's target audience is women. We do not know the sex/gender composition of the sample and this may limit the external validity of my findings. This limitation is also compounded by the general demographic bias of Mturk mentioned above. 

Since this data was collected in 2016, there are potentially new developments to the wearable technology industry that cannot be evaluated. For future studies, I believe it would be helpful to aggregate more recent data and compare it to trends from 2016.

# Process Data

-- Checking Number of Rows on daily_activity

```sql
SELECT COUNT (*)
FROM daily_activity;
```

-- Checking for duplicates in daily_activity

```sql
SELECT Id, ActivityDate, TotalSteps, Count(*)
FROM daily_activity
GROUP BY id, ActivityDate, TotalSteps
HAVING Count(*) > 1;
```

-- Modify date format for better understaning in daily_activity

```sql
Update daily_activity
Set ActivityDate = Convert(date, ActivityDate, 21);
```

-- Add day_0f_week column on daily_activities

```sql
Alter Table daily_activity
ADD day_of_week nvarchar(50)
```

--Extract datename from ActivityDate

```sql
Update daily_activity
SET day_of_week = DATENAME(DW, ActivityDate)
```

-- Modify date format for better understaning in sleep_day

```sql
Update sleep_day
Set SleepDay = Convert(date, SleepDay, 21)

-- Add sleep data columns on daily_activity
Alter Table daily_activity
ADD total_minutes_sleep int,
total_time_in_bed int;
```

--Add sleep records into dailyActivity

```sql
UPDATE daily_activity
Set total_minutes_sleep = temp2.TotalMinutesAsleep,
total_time_in_bed = temp2.TotalTimeInBed 
From daily_activity as temp1
Full Outer Join sleep_day as temp2
on temp1.id = temp2.id and temp1.ActivityDate = temp2.SleepDay;
```

--Adding specific date format to daily_activity

```sql
Alter table daily_activity
Add date_new date;
Update daily_activity
Set date_new = CONVERT( date, ActivityDate, 103 )
```

--Split date and time for hourly_calories

```sql
Alter Table hourly_calories
ADD time_new int, date_new DATE;
Update hourly_calories
Set time_new = DATEPART(hh, ActivityHour);
Update hourly_calories
Set date_new = CAST(ActivityHour AS DATE);
```

--Split date and time seperately for hourly_intensities

```sql
Alter Table hourly_intensities
ADD time_new int, date_new DATE;
Update hourly_intensities
Set time_new = DATEPART(hh, ActivityHour);
Update hourly_intensities
Set date_new = CAST(ActivityHour AS DATE);
```

--Split date and time seperately for hourly_steps

```sql
Alter Table hourly_steps
ADD time_new int, date_new DATE;
Update hourly_steps
Set time_new = DATEPART(hh, ActivityHour);
Update hourly_steps
Set date_new = CAST(ActivityHour AS DATE);
```

--Split date and time seperately for minute_METs_narrow

```sql
Alter Table minute_METs_narrow
ADD time_new TIME, date_new DATE
Update minute_METs_narrow
Set time_new = CAST(ActivityMinute as time)
Update minute_METs_narrow
Set time_new = Convert(varchar(5), time_new, 108)
Update minute_METs_narrow
Set date_new = CAST(ActivityMinute AS DATE);
```

--Create new table to merge hourly_calories, hourly_intensities, and hourly_steps

```sql
Create table hourly_data_merge(
id numeric(18,0),
date_new nvarchar(50),
time_new int,
calories numeric(18,0),
total_intensity numeric(18,0),
average_intensity float,
step_total numeric (18,0)
);
--Insert corresponsing data and merge multiple table into one table
Insert Into hourly_data_merge(id, date_new, time_new, calories, total_intensity, average_intensity, step_total)
(SELECT temp1.Id, temp1.date_new, temp1.time_new, temp1.Calories, temp2.TotalIntensity, temp2.AverageIntensity, temp3.StepTotal
From hourly_calories AS temp1
Inner Join hourly_intensities AS temp2
ON temp1.Id = temp2.Id and temp1.date_new = temp2.date_new and temp1.time_new = temp2.time_new 
Inner Join hourly_steps AS temp3
ON temp1.Id = temp3.Id and temp1.date_new = temp3.date_new and temp1.time_new = temp3.time_new);
```

--Checking for duplicates

```sql
SELECT id, time_new, calories, total_intensity, average_intensity, step_total, Count(*) as duplicates
	  FROM hourly_data_merge
	  GROUP BY id, time_new, calories, total_intensity, average_intensity, step_total
	  HAVING Count(*) > 1;
SELECT sum(duplicates) as total_duplicates
FROM (SELECT id, time_new, calories, total_intensity, average_intensity, step_total, Count(*) as duplicates
	  FROM hourly_data_merge
	  GROUP BY id, time_new, calories, total_intensity, average_intensity, step_total
	  HAVING Count(*) > 1) AS temp;
``` 

Interpretations:

* The shapes of the curves are more variant across activity levels
* Within quartiles 2 and 3, the shape of the curves are the same, but shifted over for "time in bed"
* Quartiles 1 and 4 show different shapes for "time asleep" and "time in bed".
  + Because quartile 1 "time asleep" density peak is higher than "time in bed" density peak, it indicates that there were more data points surrounding the mean of "time asleep".
  + Similarly, there were more data points surrounding the "time in bed" peak of quartile 4, resulting in a higher peak than the "time asleep" peak.
* Quartile 4 had the highest sleep delay ratio at almost an hour. Followed by quartile 1, 2, and 3, respectively.
  + Quartile 4 showed the worst sleep quality. This is consistent with the negative relationship between sleep and activity in the previous segment of "sleep trends". 
  + The order of sleep quality is also consistent with the weak nature of the aforementioned relationship.

## Analysis Summary

Key findings:

* Feature usage
  + Step-counting was the most used feature by FitBit consumers. Followed by sleep recording.
  + Weight-logging was seldom used by FitBit consumers.
  + A positive relationship was found between engaging with the FitBit device and steps.
  
* Trends in time
  + More active users log in the most steps around usual break times of a 9-5 job (e.g mid-morning, lunch time, and after work hours)
  + Less active users have less step logging peak times. Quartile 2 had two peaks and quartile 1 had one peak.
  
* Sleep trends
  + As people of this sample logged more steps, they recorded less time asleep.
  + Quartile 4 showed the highest sleep delay. This was followed by quartiles 1,2, and 3, in that order.

# Recommendations

* Encourage engagement with the product as means to encourage fitness goals
  + Point system (Gold’s Gym)
  + Goals and streaks (Duo Lingo)
* Assess for any barriers preventing users from engaging in features like weight logging
  + Adding automated data entry with devices such as Bluetooth scales
  + Cleanliness reminders of the watch
  + Offer interchangeable, fashionable straps/cases for devices
* Personalize notifications to individual fitness habits such as fitness schedules
  + Recommending work out based on intensity trends
  + User inputted schedule with encouragement notifications to “Keep it up!”
* Introduce sleep hygiene recommendations for users
  + Link credible sources for sleep hygiene
  + Notify users of winding down before bedtime (Apple Health)
* Reminders to charge their devices during the day and 
    wear it to sleep

In conclusion, my goal is to help Bellabeat better understand its consumer base and offer practical solutions to help out customers achieve their fitness goals. Following my recommendations will greatly increase engagement with our products and long term success of Bellabeat. I hope this tutorial was clear and useful.
