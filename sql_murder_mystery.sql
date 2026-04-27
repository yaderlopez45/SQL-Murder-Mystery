-- Here I can see all the people who checked in the date of the murder
select ci.check_in_date, m.name
from get_fit_now_check_in as ci
join get_fit_now_member as m on ci.membership_id = m.id
where ci.check_in_date = 20180115

--Retrieve the crime report
select *
from crime_scene_report
where date = 20180115
AND city = 'SQL City'
AND type = 'murder'

--Identifying supect 1
select *
from person
where (address_street_name like '%Northwestern Dr%"'
or address_street_name like '%Franklin Ave%')
AND name like '%Annabel%'

--Retrieving suspect 1 interview
select *
from interview
where person_id IN (
select id
from person
where (address_street_name like '%Northwestern Dr%"'
or address_street_name like '%Franklin Ave%')
AND name like '%Annabel%')

--Checking the people who came in the same date Annabel identified the murderer
select *
from person
where id IN (
select m.person_id
from get_fit_now_check_in as ci
join get_fit_now_member as m on ci.membership_id = m.id
where ci.check_in_date = 20180109
)

--Identifying second suspect
select *
from interview
where person_id IN (
select id
from person
where address_street_name like '%Northwestern Dr%')

--Identifying possible murderers based on suspect 2's description
select *
from get_fit_now_member
where id like '48Z%'
AND membership_status = 'gold'

select *
from drivers_license
where plate_number like '%H42W%'

select *
from person
where license_id in (
select id
from drivers_license
where plate_number like '%H42W%')

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
AND membership_status = 'gold')

INSERT INTO solution VALUES (1, "Jeremy Bowers");

SELECT value FROM solution;

--Second mystery
--Retrieving murderer interview
select *
from interview 
where person_id = '67318'

select *
from drivers_license

select *
from facebook_event_checkin

--Identifying the mastermind based on the murderer description
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

INSERT INTO solution VALUES (1, "Miranda Priestly");

SELECT value FROM solution;





