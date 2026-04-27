# SQL Murder Mystery: Full Investigation Report

This document outlines the step-by-step SQL investigation used to identify the murderer and the mastermind behind the crime in SQL City.

## ![Mystery Image](174092-clue-illustration.png)

## 1. People who checked in on the date of the murder

### Insight: This query identifies all members who checked into the "Get Fit Now" gym on the date of the murder (January 15, 2018). This information is crucial for establishing a list of individuals who were active in the vicinity or potentially involved in the events of that day.

SQL Query:

```sql
-- Here I can see all the people who checked in the date of the murder
select ci.check_in_date, m.name
from get_fit_now_check_in as ci
join get_fit_now_member as m on ci.membership_id = m.id
where ci.check_in_date = 20180115

```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>check_in_date</th>
      <th>name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>20180115</td>
      <td>Joline Hollering</td>
    </tr>
    <tr>
      <td>20180115</td>
      <td>Armando Huie</td>
    </tr>
    <tr>
      <td>20180115</td>
      <td>Taylor Skyes</td>
    </tr>
    <tr>
      <td>20180115</td>
      <td>Edgar Bamba</td>
    </tr>
  </tbody>
</table>

## 2. Retrieve the crime report

### Insight: This query retrieves the crime scene report for the murder. It provides a crucial lead by describing two witnesses: the first witness lives at the last house on "Northwestern Dr," and the second witness, named Annabel, lives somewhere on "Franklin Ave." This information narrows down the search for people to interview.

SQL Query:

```sql
--Retrieve the crime report
select *
from crime_scene_report
where date = 20180115
AND city = 'SQL City'
AND type = 'murder'
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>date</th>
      <th>type</th>
      <th>description</th>
      <th>city</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>20180115</td>
      <td>murder</td>
      <td>Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".</td>
      <td>SQL City</td>
    </tr>
  </tbody>
</table>

## 3. Identifying first suspect

### Insight: By filtering for the name "Annabel" and the streets mentioned in the crime report, we have successfully identified "Annabel Miller" as one of the witnesses. She lives at 103 Franklin Ave. This gives us her specific person_id (16371), which we can use to find her witness statement.

SQL Query:

```sql
--Identifying supect 1
select *
from person
where (address_street_name like '%Northwestern Dr%'
or address_street_name like '%Franklin Ave%')
AND name like '%Annabel%'
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>id</th>
      <th>name</th>
      <th>license_id</th>
      <th>address_number</th>
      <th>address_street_name</th>
      <th>ssn</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>16371</td>
      <td>Annabel Miller</td>
      <td>490173</td>
      <td>103</td>
      <td>Franklin Ave</td>
      <td>318771143</td>
    </tr>
  </tbody>
</table>

## 4. Retrieving first suspect interview

### Insight: This query retrieves the interview transcript for Annabel Miller. Her statement provides a major breakthrough: she witnessed the murder and recognized the killer as someone she saw at the gym on January 9th. This allows us to narrow our search to individuals who checked into the gym on that specific date.

SQL Query:

```sql
--Retrieving suspect 1 interview
select *
from interview
where person_id IN (
select id
from person
where (address_street_name like '%Northwestern Dr%'
or address_street_name like '%Franklin Ave%')
AND name like '%Annabel%')
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>person_id</th>
      <th>transcript</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>16371</td>
      <td>I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.</td>
    </tr>
  </tbody>
</table>

## 5. Checking the people who came in the same date Annabel identified the murderer

### Insight: Following Annabel Miller's lead, this query identifies every person who was at the gym on January 9, 2018. This list of 10 individuals includes the potential murderer. Notably, Annabel Miller herself appears on this list, along with other individuals like Jeremy Bowers and Joe Germuska, who will be scrutinized further based on subsequent clues.

SQL Query:

```sql
--Checking the people who came in the same date Annabel identified the murderer
select *
from person
where id IN (
select m.person_id
from get_fit_now_check_in as ci
join get_fit_now_member as m on ci.membership_id = m.id
where ci.check_in_date = 20180109
)
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>id</th>
      <th>name</th>
      <th>license_id</th>
      <th>address_number</th>
      <th>address_street_name</th>
      <th>ssn</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>10815</td>
      <td>Adriane Pelligra</td>
      <td>952073</td>
      <td>948</td>
      <td>Emba Ave</td>
      <td>243639527</td>
    </tr>
    <tr>
      <td>15247</td>
      <td>Shondra Ledlow</td>
      <td>108978</td>
      <td>2906</td>
      <td>Chuck Dr</td>
      <td>492143109</td>
    </tr>
    <tr>
      <td>16371</td>
      <td>Annabel Miller</td>
      <td>490173</td>
      <td>103</td>
      <td>Franklin Ave</td>
      <td>318771143</td>
    </tr>
    <tr>
      <td>28073</td>
      <td>Zackary Cabotage</td>
      <td>402017</td>
      <td>3823</td>
      <td>S Winthrop Ave</td>
      <td>367741547</td>
    </tr>
    <tr>
      <td>28819</td>
      <td>Joe Germuska</td>
      <td>173289</td>
      <td>111</td>
      <td>Fisk Rd</td>
      <td>138909730</td>
    </tr>
    <tr>
      <td>31523</td>
      <td>Blossom Crescenzo</td>
      <td>737886</td>
      <td>1245</td>
      <td>Ruxshire St</td>
      <td>753962462</td>
    </tr>
    <tr>
      <td>55662</td>
      <td>Sarita Bartosh</td>
      <td>556026</td>
      <td>1031</td>
      <td>Legacy Pointe Blvd</td>
      <td>564780417</td>
    </tr>
    <tr>
      <td>67318</td>
      <td>Jeremy Bowers</td>
      <td>423327</td>
      <td>530</td>
      <td>Washington Pl, Apt 3A</td>
      <td>871539279</td>
    </tr>
    <tr>
      <td>83186</td>
      <td>Burton Grippe</td>
      <td>915564</td>
      <td>484</td>
      <td>Lemcrow Way</td>
      <td>426280783</td>
    </tr>
    <tr>
      <td>92736</td>
      <td>Carmen Dimick</td>
      <td>890722</td>
      <td>2965</td>
      <td>Kilmaine Circle</td>
      <td>622279052</td>
    </tr>
  </tbody>
</table>

## 6. Identifying second suspect

### Insight: This query retrieves all interviews from residents of "Northwestern Dr". Among many irrelevant entries, we find the testimony of the second witness (person_id 14887). This witness provides vital specific details: the killer had a "Get Fit Now Gym" bag with a membership number starting with "48Z," is a "gold" member, and drove a car with a license plate containing "H42W."

SQL Query:

```sql
--Identifying second suspect
select *
from interview
where person_id IN (
select id
from person
where address_street_name like '%Northwestern Dr%')
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>person_id</th>
      <th>transcript</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>88423</td>
      <td>sea, some children digging in the sand with wooden spades, then a row\n</td>
    </tr>
    <tr>
      <td>34352</td>
      <td>Poor Alice! It was as much as she could do, lying down on one side, to\n</td>
    </tr>
    <tr>
      <td>15171</td>
      <td>the verses to himself: ‘“WE KNOW IT TO BE TRUE--” that’s the jury, of\n</td>
    </tr>
    <tr>
      <td>96595</td>
      <td>head in the lap of her sister, who was gently brushing away some dead\n</td>
    </tr>
    <tr>
      <td>72076</td>
      <td>see: four times five is twelve, and four times six is thirteen, and\n</td>
    </tr>
    <tr>
      <td>28360</td>
      <td>for apples, yer honour!’\n</td>
    </tr>
    <tr>
      <td>75484</td>
      <td>‘We had the best of educations--in fact, we went to school every day--’\n</td>
    </tr>
    <tr>
      <td>25615</td>
      <td>when I learn music.’\n</td>
    </tr>
    <tr>
      <td>26758</td>
      <td>Will you, won’t you, will you, won’t you, won’t you join the dance?\n</td>
    </tr>
    <tr>
      <td>39688</td>
      <td>‘Hold your tongue!’ said the Queen, turning purple.\n</td>
    </tr>
    <tr>
      <td>80921</td>
      <td>\n</td>
    </tr>
    <tr>
      <td>68690</td>
      <td>\n</td>
    </tr>
    <tr>
      <td>51114</td>
      <td>‘So you did, old fellow!’ said the others.\n</td>
    </tr>
    <tr>
      <td>12711</td>
      <td>\n</td>
    </tr>
    <tr>
      <td>23960</td>
      <td>This was quite a new idea to Alice, and she thought it over a little\n</td>
    </tr>
    <tr>
      <td>40336</td>
      <td>stretched her arms round it as far as they would go, and broke off a bit\n</td>
    </tr>
    <tr>
      <td>85280</td>
      <td>verse.’\n</td>
    </tr>
    <tr>
      <td>71924</td>
      <td>interrupted: ‘UNimportant, your Majesty means, of course,’ he said in a\n</td>
    </tr>
    <tr>
      <td>73368</td>
      <td>doesn’t suit my throat!’ and a Canary called out in a trembling voice to\n</td>
    </tr>
    <tr>
      <td>14887</td>
      <td>I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".</td>
    </tr>
  </tbody>
</table>

## 7. Identifying possible murderers based on second suspect's description

### Insight: Based on the second witness's description of a "gold" membership and a member ID starting with "48Z," this query narrows the list of suspects down to two individuals: Joe Germuska and Jeremy Bowers. Both were also present at the gym on the date identified by the first witness, making them the primary suspects.

SQL Query:

```sql
--Identifying possible murderers based on suspect 2's description
select *
from get_fit_now_member
where id like '48Z%'
AND membership_status = 'gold'
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>id</th>
      <th>person_id</th>
      <th>name</th>
      <th>membership_start_date</th>
      <th>membership_status</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>48Z7A</td>
      <td>28819</td>
      <td>Joe Germuska</td>
      <td>20160305</td>
      <td>gold</td>
    </tr>
    <tr>
      <td>48Z55</td>
      <td>67318</td>
      <td>Jeremy Bowers</td>
      <td>20160101</td>
      <td>gold</td>
    </tr>
  </tbody>
</table>

## 8. Drivers license check

### Insight: This query searches the driver's license database for the partial plate number "H42W" provided by the second witness. It returns three possible vehicles and their owners' physical descriptions. Among these, we see a license ID (423327) belonging to a male, which aligns with the witness's description of a man running out.

SQL Query:

```sql
select *
from drivers_license
where plate_number like '%H42W%'
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>id</th>
      <th>age</th>
      <th>height</th>
      <th>eye_color</th>
      <th>hair_color</th>
      <th>gender</th>
      <th>plate_number</th>
      <th>car_make</th>
      <th>car_model</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>183779</td>
      <td>21</td>
      <td>65</td>
      <td>blue</td>
      <td>blonde</td>
      <td>female</td>
      <td>H42W0X</td>
      <td>Toyota</td>
      <td>Prius</td>
    </tr>
    <tr>
      <td>423327</td>
      <td>30</td>
      <td>70</td>
      <td>brown</td>
      <td>brown</td>
      <td>male</td>
      <td>0H42W2</td>
      <td>Chevrolet</td>
      <td>Spark LS</td>
    </tr>
    <tr>
      <td>664760</td>
      <td>21</td>
      <td>71</td>
      <td>black</td>
      <td>black</td>
      <td>male</td>
      <td>4H42WR</td>
      <td>Nissan</td>
      <td>Altima</td>
    </tr>
  </tbody>
</table>

## 9. Identifying the murderer based on testimonies description

### Insight: This query links the physical car data (license plates) back to specific individuals in the person database. We now have three names associated with the "H42W" plate fragment: Tushar Chandra, Jeremy Bowers, and Maxine Whitely. Jeremy Bowers continues to be a recurring name in our investigation.

SQL Query:

```sql
select *
from person
where license_id in (
select id
from drivers_license
where plate_number like '%H42W%')
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>id</th>
      <th>name</th>
      <th>license_id</th>
      <th>address_number</th>
      <th>address_street_name</th>
      <th>ssn</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>51739</td>
      <td>Tushar Chandra</td>
      <td>664760</td>
      <td>312</td>
      <td>Phi St</td>
      <td>137882671</td>
    </tr>
    <tr>
      <td>67318</td>
      <td>Jeremy Bowers</td>
      <td>423327</td>
      <td>530</td>
      <td>Washington Pl, Apt 3A</td>
      <td>871539279</td>
    </tr>
    <tr>
      <td>78193</td>
      <td>Maxine Whitely</td>
      <td>183779</td>
      <td>110</td>
      <td>Fisk Rd</td>
      <td>137882671</td>
    </tr>
  </tbody>
</table>

## 10. Verifying the Solution

### Insight: By combining the gym membership data (gold status, ID starting with '48Z') and the vehicle data (plate including 'H42W'), we have pinpointed the murderer: Jeremy Bowers. Inserting this name into the solution table confirms he is the killer, but also reveals a deeper mystery—there is a mastermind behind the crime that we still need to uncover.

SQL Query:

```sql
--Identifying the murderer based on testimonies description
select *
from person
where license_id in (
select id
from drivers_license
where plate_number like '%H42W%')
AND id in (
select person_id
from get_fit_now_member
where id like '48Z%'
AND membership_status = 'gold');
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>id</th>
      <th>name</th>
      <th>license_id</th>
      <th>address_number</th>
      <th>address_street_name</th>
      <th>ssn</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>67318</td>
      <td>Jeremy Bowers</td>
      <td>423327</td>
      <td>530</td>
      <td>Washington Pl, Apt 3A</td>
      <td>871539279</td>
    </tr>
  </tbody>
</table>

```sql
INSERT INTO solution VALUES (1, "Jeremy Bowers");

SELECT value FROM solution;
```

<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.</td>
    </tr>
  </tbody>
</table>

## 11. Retrieving murderer interview

### Insight: Jeremy’s interview provides the physical description and lifestyle habits of the person who hired him.

SQL Query:

```sql
select *
from interview
where person_id = '67318'
```

<table style="width: 100%; border-collapse: collapse; background-color: #0d1117; color: #c9d1d9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; border: 1px solid #30363d;">
    <thead>
        <tr style="background-color: #161b22;">
            <th style="padding: 12px; border: 1px solid #30363d; text-align: left; font-weight: 600;">Person ID</th>
            <th style="padding: 12px; border: 1px solid #30363d; text-align: left; font-weight: 600;">Transcript</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="padding: 12px; border: 1px solid #30363d;">67318</td>
            <td style="padding: 12px; border: 1px solid #30363d; line-height: 1.5;">I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.</td>
        </tr>
    </tbody>
</table>

## 12. Identifying the mastermind based on the murderer description

### Insights: This final query filters for a woman with red hair, a Tesla Model S, and three concert check-ins, identifying Miranda Priestly as the mastermind.

SQL Query:

```sql
select p.name, dl.height, dl.hair_color, dl.car_make, dl.car_model
from person as p
join drivers_license as dl
on p.license_id = dl.id
join facebook_event_checkin as fb
on p.id = fb.person_id
where (dl.height >= 65 AND dl.height <= 67)
AND dl.hair_color = 'red'
AND dl.car_make = 'Tesla'
AND dl.car_model = 'Model S'
AND p.id IN (
select person_id
from facebook_event_checkin
where event_name = 'SQL Symphony Concert'
AND date > 20171201
group by person_id
having COUNT(person_id) >=3)
```

<table style="width: 100%; border-collapse: collapse; background-color: #0d1117; color: #c9d1d9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; border: 1px solid #30363d;">
    <thead>
        <tr style="background-color: #161b22;">
            <th style="padding: 12px; border: 1px solid #30363d; text-align: left; font-weight: 600;">Name</th>
            <th style="padding: 12px; border: 1px solid #30363d; text-align: left; font-weight: 600;">Height</th>
            <th style="padding: 12px; border: 1px solid #30363d; text-align: left; font-weight: 600;">Hair Color</th>
            <th style="padding: 12px; border: 1px solid #30363d; text-align: left; font-weight: 600;">Car Make</th>
            <th style="padding: 12px; border: 1px solid #30363d; text-align: left; font-weight: 600;">Car Model</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="padding: 12px; border: 1px solid #30363d;">Miranda Priestly</td>
            <td style="padding: 12px; border: 1px solid #30363d;">66</td>
            <td style="padding: 12px; border: 1px solid #30363d;">red</td>
            <td style="padding: 12px; border: 1px solid #30363d;">Tesla</td>
            <td style="padding: 12px; border: 1px solid #30363d;">Model S</td>
        </tr>
    </tbody>
</table>

## 13. Final Solution

### Insight: The investigation concludes with the identification of Miranda Priestly as the architect of the crime.

SQL Query:

```sql
INSERT INTO solution VALUES (1, "Miranda Priestly");
SELECT value FROM solution;
```

<table style="width: 100%; border-collapse: collapse; background-color: #0d1117; color: #c9d1d9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; border: 1px solid #30363d;">
    <thead>
        <tr style="background-color: #161b22;">
            <th style="padding: 12px; border: 1px solid #30363d; text-align: left; font-weight: 600;">Value</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td style="padding: 12px; border: 1px solid #30363d; line-height: 1.5;">Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time.</td>
        </tr>
    </tbody>
</table>

## Credits

This project utilizes the **SQL Murder Mystery**, created by **Joon Park** and **Cathy He** at the **Northwestern University Knight Lab**.

- **Original Repository:** [NUKnightLab/sql-mysteries](https://github.com/NUKnightLab/sql-mysteries)
- **License:** [MIT License](https://github.com/NUKnightLab/sql-mysteries/blob/master/LICENSE) (Code) and [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) (Content).
- **Inspiration:** Inspired by Noah Veltman's command-line mystery.
