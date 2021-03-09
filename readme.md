## Framework/Libraries
* [Grape](https://github.com/ruby-grape/grape) for handling the REST api functionality. Went with grape rather than Rails since grape was more lightweight and it provides support for handling errors as well as versioning
* SQLite3 For handling db connections. SQLite3 is good enough for small to medium projects and can also be setup without much overhead unlike PostgreSQL or MySQL.


## Setup
Ruby Version: 2.7.2
To setup and run the api server please run the following commands
1. Installing dependencies: `bundle install`
2. Setting up the sqlite3 db: `bundle exec rake db_setup`
3. Starting the API server: `bundle exec rackup`

Step 1 is not need run everytime unless a new depedency is to be added. 
Step 2 is useful for droping the booking table to start from scratch

To run the automation test cases, run `bundle exec rspec`

## API Reference
There are two REST api endpoints provided for usage by the front end developers.
### Fetch Mentor Agenda Given Schedule
#### Sample Request
```
curl --request GET \
  --url 'http://localhost:9292/api/v1/mentor_agenda?agenda_date=2021-03-06'
```
#### Inputs

| Field        | Type   | Description            |
|:-------------|:------:|:----------------------:|
| agenda_date  | String | Date clicked by user   |


#### Sample Response
```
[
  {
    "slot_start_time": "2021-03-06 00:00",
    "slot_end_time": "2021-03-06 00:59",
    "free": true,
    "reason": null
  },
  {
    "slot_start_time": "2021-03-06 01:00",
    "slot_end_time": "2021-03-06 01:59",
    "free": true,
    "reason": null
  },
  ...
  {
    "slot_start_time": "2021-03-06 23:00",
    "slot_end_time": "2021-03-06 23:59",
    "free": true,
    "reason": null
  }
]
```
#### Sample Response (Failure)
```
{ 
  "success": false,
  "error": "Slot has been already filled by event."
}
```
#### Response Fields
Response will be an array of objects each with the below described fields unless the api for fetching mentor information fails.
| Field        | Type   | Description            |
|:-------------|:------:|:----------------------:|
| slot_start_time  | DateTime | Start Datetime of the slot   |
| slot_end_time  | DateTime | End Datetime of the slot   |
| free  | Boolean | Indicates if the slot if free   |
| reason  | String | Provides a reason if slot if busy else is null  |

### Book a slot on Mentor's Agenda
### Sample Request
```
curl --request POST \
  --url http://localhost:9292/api/v1/book_slot \
  --header 'Content-Type: application/json' \
  --data '{
	"meeting_datetime": "2021-03-05 06:00:00",
	"reason": "To clear doubts on Typescript Generics"
}'
```
#### Inputs

| Field        | Type   | Description            |
|:-------------|:------:|:----------------------:|
| meeting_datetime  | DateTime | Start time of the slot along with the date   |
| reason | String | Reason for scheduling the meeting |

#### Sample Response (Succesful)
```
{
  "success": true,
  "slot_info": {
    "slot_start_time": "2021-03-05 06:00",
    "slot_end_time": "2021-03-05 06:59",
    "free": false,
    "reason": "To clear doubts on Typescript Generics"
  }
}
```
#### Sample Response (Failure)
```
{ 
  "success": false,
  "error": "Slot has been already filled by another event."
}
```
#### Response Fields
Will contain a field with key as `success` with a boolean value to indicate if slot has been booked.  
| Field        | Type   | Description            |
|:-------------|:------:|:----------------------:|
| slot_start_time  | DateTime | Start Datetime of the slot   |
| slot_end_time  | DateTime | End Datetime of the slot   |
| free  | Boolean | Indicates if the slot if free   |
| reason  | String | Provides a reason if slot if busy else is null  |


#### Errors that are raised
* Slot has been already filled by another event.
* Unable to fetch mentor schedule.
