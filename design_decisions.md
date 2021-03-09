1. All incoming api requests are handled via the `Calendar` class. The class is then mounted in the Root class which handles any common functionality that needs to be shared.
2. The logic for each request is maintained in `CalendarService`. This allows for writing unit tests rather integration tests and allows functionality to be resused. `CalendarService` creates instances of the following classes,

    * `CalendarApiService` to interact with the CF api, pull in mentor schedule and provide information based on the data.
    * `BookingService` to fetch bookings present in the database for the selected date, provide information based on the data pulled and to insert new booking slots into the database.

3. Rather than adding a ORM library I went with the `sqlite3` library for simplicity and am using plain SQL queries for read/write operations. The `Database::Booking` class handles this rather than `BookingService` because it is easier to replace the type of database without having it change the business logic.

4. The similar reasoning is also why the `CfApi` class exists. In case the api provider or the route changes in the future, I would only need to change it in one file.

5. The `Slot` class exists so as to not pollute the `CalendarService` class with methods on how each slot should be represented.