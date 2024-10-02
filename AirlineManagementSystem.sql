create database airline;
use airline;
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique identifier for each flight
    flight_number VARCHAR(10) NOT NULL,        -- Unique flight number
    departure_location VARCHAR(50) NOT NULL,               -- Origin city or airport
	arrival_location VARCHAR(50) NOT NULL,          -- Destination city or airport
    departure_time DATETIME NOT NULL,          -- Scheduled departure time
    arrival_time DATETIME NOT NULL,            -- Scheduled arrival time
    duration INT,                              -- Flight duration in minutes
    aircraft_id INT,                           -- Foreign key referencing Aircraft table
    status VARCHAR(20) DEFAULT 'Scheduled',    -- Status of the flight (Scheduled, Delayed, Cancelled, etc.)
    no_of_passengers int,
    airport_id int,
    CONSTRAINT fk_aircraft FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id),
    CONSTRAINT fk_airport FOREIGN KEY (airport_id) REFERENCES Airport(airport_id)
);
CREATE TABLE PILOTS (
    pilot_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique ID for each pilot
    first_name VARCHAR(50) NOT NULL,          -- Pilot's first name
    middle_name VARCHAR(50),                  -- Pilot's middle name
    last_name VARCHAR(50) NOT NULL,           -- Pilot's last name
    date_of_birth DATE,                       -- Date of birth
    license_no VARCHAR(50) NOT NULL,          -- Pilot's license number
    flight_id INT,                            -- foreign key
    country varchar(50),
    state varchar(50),
    city varchar(50),
    pincode int,
    street varchar(100),
    CONSTRAINT fk_flights FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);
CREATE TABLE PILOT_MOBILE_NO (
    pilot_id INT,                          -- Foreign key referencing PILOTS
    mobile_no VARCHAR(15),                 -- Mobile number
    PRIMARY KEY (pilot_id, mobile_no),     -- Composite primary key
    FOREIGN KEY (pilot_id) REFERENCES PILOTS(pilot_id) ON DELETE CASCADE
);
CREATE TABLE PILOT_EMAIL (
    pilot_id INT,                          -- Foreign key referencing PILOTS
    email VARCHAR(100),                    -- Email address
    PRIMARY KEY (pilot_id, email),         -- Composite primary key
    FOREIGN KEY (pilot_id) REFERENCES PILOTS(pilot_id) ON DELETE CASCADE
);
CREATE TABLE CREW_MEMBERS (
    crew_member_id INT PRIMARY KEY,        -- Unique ID for each crew member
    flight_id int,                       -- foreign key
    first_name VARCHAR(50),         -- Composite attribute: first name
    middle_name VARCHAR(50),        -- Composite attribute: middle name
    last_name VARCHAR(50),          -- Composite attribute: last name
    role VARCHAR(50),               -- Role of the crew member (e.g., Pilot, Flight Attendant, etc.)
    date_of_birth date,
	country VARCHAR(50),                  -- Part of composite address: Country
    city VARCHAR(50),                     -- Part of composite address: City
    state VARCHAR(50),                    -- Part of composite address: State
    street varchar(100),
    pin_code int,
   CONSTRAINT fk_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id) 
);
CREATE TABLE CREW_MOBILE_NO (
    crew_member_id int,        -- Foreign key to reference crew members
    mobile_no VARCHAR(15),             -- Multivalued attribute: mobile number
    PRIMARY KEY (crew_member_id, mobile_no),
    FOREIGN KEY (crew_member_id) REFERENCES CREW_MEMBERS(crew_member_id) ON DELETE CASCADE
);
CREATE TABLE CREW_EMAIL (
    crew_member_id INT,                       -- Foreign key to reference crew members
    email VARCHAR(100),                -- Multivalued attribute: email
    PRIMARY KEY (crew_member_id, email),      -- Composite primary key (crew_id + email)
    FOREIGN KEY (crew_member_id) REFERENCES CREW_MEMBERS(crew_member_id) ON DELETE CASCADE
);
CREATE TABLE AIRPORT (
    airport_id INT PRIMARY KEY,           -- Unique identifier for each airport
	airport_name VARCHAR(100) NOT NULL,   -- Name of the airport
    IATA_code CHAR(3) UNIQUE,             -- IATA code (3-character airport code)
    country VARCHAR(50) NOT NULL,         -- Country where the airport is located
    city VARCHAR(50) NOT NULL,            -- City where the airport is located
    no_of_runways int not null
);
CREATE TABLE AIRCRAFT (
    aircraft_id INT PRIMARY KEY,          -- Primary key for aircraft
    registration_no VARCHAR(20) UNIQUE,   -- Unique registration number of the aircraft
    manufacturer VARCHAR(50),             -- Manufacturer of the aircraft (e.g., Boeing, Airbus)
    model VARCHAR(50),                    -- Model of the aircraft (e.g., A320, 737 Max)
    capacity INT                        -- Seating capacity of the aircraft
);
CREATE TABLE BOOKING (
    booking_id INT PRIMARY KEY,            -- Primary key for the booking
    booking_date DATE,                     -- Date when the booking was made
    seat_number VARCHAR(10),                   -- Seat number assigned for the booking
    status VARCHAR(20),                    -- Status of the booking (e.g., confirmed, canceled)
    payment_status varchar(50),
    user_id INT,                           -- Foreign key referencing USER table
    flight_id INT,                         -- Foreign key referencing FLIGHT table
    class_id INT,                          -- Foreign key referencing CLASS table
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES FLIGHTS(flight_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES CLASS(class_id) ON DELETE CASCADE
);
CREATE TABLE CLASS (
    class_id INT PRIMARY KEY,            -- Primary key for class (unique identifier)
    class_type varchar(50),         -- Name of the class (e.g., Economy, Business, First Class)
    description VARCHAR(255),            -- Description of the class (optional)
    price DECIMAL(10, 2),                -- Base price for the class
    amenities VARCHAR(255),              -- Amenities provided in the class (optional)
    seat_availability varchar(50)
);
CREATE TABLE PASSENGER (
    passenger_id INT PRIMARY KEY,          -- Primary key for passenger
    first_name VARCHAR(50),                -- First name of the passenger
    middle_name VARCHAR(50),               -- Middle name of the passenger (optional)
    last_name VARCHAR(50),                 -- Last name of the passenger
    gender VARCHAR(10),                    -- Gender of the passenger
    date_of_birth DATE,                    -- Date of birth of the passenger
    passport_no int,
    -- Foreign Key
    booking_id INT,                        -- Foreign key referencing the BOOKING table
    FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id) ON DELETE CASCADE
);
CREATE TABLE PASSENGER_EMAIL (
    passenger_id INT,                       -- Foreign key referencing PASSENGER table
    email VARCHAR(100),                     -- Email address of the passenger
    PRIMARY KEY (passenger_id, email),      -- Composite primary key to allow multiple emails
    FOREIGN KEY (passenger_id) REFERENCES PASSENGER(passenger_id) ON DELETE CASCADE
);
CREATE TABLE PASSENGER_PHONE (
    passenger_id INT,                       -- Foreign key referencing PASSENGER table
    phone_no VARCHAR(15),                   -- Phone number of the passenger
    PRIMARY KEY (passenger_id, phone_no),   -- Composite primary key to allow multiple phone numbers
    FOREIGN KEY (passenger_id) REFERENCES PASSENGER(passenger_id) ON DELETE CASCADE
);
CREATE TABLE USERS (
    user_id INT PRIMARY KEY,              -- Primary key for users
    first_name VARCHAR(50),               -- First name of the user
    middle_name VARCHAR(50),              -- Middle name of the user (optional)
    last_name VARCHAR(50),                -- Last name of the user
    password VARCHAR(255) not null,              -- Password of the user (should be hashed in practice)
    date_of_birth date,
    street VARCHAR(100),          -- Street address of the user
    city VARCHAR(50),                     -- City of the user
    state VARCHAR(50),                    -- State of the user
    country VARCHAR(50),                  -- Country of the user
    pin_code VARCHAR(10)                  -- pin code of the user
);
CREATE TABLE USER_EMAIL (
    user_id INT,                          -- Foreign key referencing USERS table
    email VARCHAR(100),                   -- Email address of the user
    PRIMARY KEY (user_id, email),         -- Composite primary key to allow multiple emails
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);
CREATE TABLE USER_PHONE (
    user_id INT,                          -- Foreign key referencing USERS table
    phone_no VARCHAR(15),                 -- Phone number of the user
    PRIMARY KEY (user_id, phone_no),      -- Composite primary key to allow multiple phone numbers
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);
CREATE TABLE CANCELLATIONS (
    user_id INT,                            -- Foreign key referencing USERS table
    booking_id INT,                         -- Foreign key referencing BOOKING table
    cancellation_date DATE,                 -- Date when the cancellation occurred
    reason VARCHAR(255),                    -- Reason for the cancellation (optional)
    refund_amount DECIMAL(10, 2),           -- Amount refunded for the cancellation (optional)
	cancellation_status varchar(50),
    -- Composite Primary Key
    PRIMARY KEY (user_id, booking_id),

    -- Foreign Key Constraints
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id) ON DELETE CASCADE
);
CREATE TABLE DELAYS (
    flight_id INT,                           -- Foreign key referencing FLIGHTS table
    delay_id INT,                            -- Unique identifier for each delay record
    delay_duration INT,                      -- Duration of the delay in minutes
    delay_reason VARCHAR(255),               -- Reason for the delay
    delay_date DATE,                         -- Date when the delay occurred

    -- Composite Primary Key (flight_id + delay_id)
    PRIMARY KEY (flight_id, delay_id),

    -- Foreign Key Constraint
    FOREIGN KEY (flight_id) REFERENCES FLIGHTS(flight_id) ON DELETE CASCADE
);
CREATE TABLE TRANSACTIONS (
    transaction_id INT PRIMARY KEY,          -- Primary key for each transaction
    user_id INT,                             -- Foreign key referencing USERS table
    transaction_date DATE,                   -- Date of the transaction
    amount DECIMAL(10, 2),                   -- Amount paid in the transaction
    payment_method VARCHAR(50),              -- Payment method used (e.g., Credit Card, PayPal)
    status VARCHAR(20),                      -- Status of the transaction (e.g., Completed, Pending, Failed)

    -- Foreign Key Constraint
    FOREIGN KEY (user_id) REFERENCES USERS(user_id) ON DELETE CASCADE
);






