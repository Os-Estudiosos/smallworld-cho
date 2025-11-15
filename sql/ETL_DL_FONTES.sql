CREATE TABLE fontes.world_cities (
    city VARCHAR(255),
    city_ascii VARCHAR(255),
    lat NUMERIC(10, 4),
    lng NUMERIC(10, 4),
    country VARCHAR(255),
    iso2 CHAR(2),
    iso3 CHAR(3),
    admin_name VARCHAR(255),
    capital VARCHAR(50),
    population NUMERIC,
    id BIGINT
);

-- \copy fontes.world_cities FROM 'files/world_cities.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', FORCE_NULL (population, lat, lng, id));


CREATE TABLE fontes.bloodtypes_per_country (
    Country VARCHAR(255),
    Population BIGINT,
    "O+" NUMERIC(5, 2),
    "A+" NUMERIC(5, 2),
    "B+" NUMERIC(5, 2),
    "AB+" NUMERIC(5, 2),
    "O-" NUMERIC(5, 2),
    "A-" NUMERIC(5, 2),
    "B-" NUMERIC(5, 2),
    "AB-" NUMERIC(5, 2)
);

-- \copy fontes.bloodtypes_per_country FROM 'files/bloodtypes_per_country.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');


CREATE TABLE fontes.top_ranking_street_foods (
    "Food Name" VARCHAR(255),
    "Country/Region" VARCHAR(255),
    "Description" TEXT,
    "Calories" INTEGER,
    "Serving Type" VARCHAR(50),
    "Main Ingredients" VARCHAR(255),
    "Category" VARCHAR(100),
    "Preparation Time" INTEGER,
    "Popularity Rank" INTEGER
);

-- \copy fontes.top_ranking_street_foods FROM 'files/top_ranking_street_foods.csv' WITH (FORMAT csv, HEADER true, ENCODING 'LATIN1');


CREATE TABLE fontes.restaurants_per_country (
    "Restaurant ID" BIGINT,
    "Restaurant Name" VARCHAR(255),
    "City" VARCHAR(255),
    "Address" TEXT,
    "Locality" VARCHAR(255),
    "Longitude" NUMERIC(10, 6),
    "Latitude" NUMERIC(10, 6),
    "Cuisines" TEXT,
    "Average Cost for two" INTEGER,
    "Currency" VARCHAR(100),
    "Has Table booking" VARCHAR(10),
    "Has Online delivery" VARCHAR(10),
    "Is delivering now" VARCHAR(10),
    "Price range" INTEGER,
    "Aggregate rating" NUMERIC(3, 2),
    "Rating color" VARCHAR(50),
    "Rating text" VARCHAR(50),
    "Votes" INTEGER
);

-- \copy fontes.restaurants_per_country FROM 'files/restaurants_per_country.csv' WITH (FORMAT csv, HEADER true, ENCODING 'LATIN1', FORCE_NULL ("Restaurant ID", "Longitude", "Latitude", "Average Cost for two", "Price range", "Aggregate rating", "Votes"));
