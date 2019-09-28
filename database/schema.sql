CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "email" varchar(255) UNIQUE NOT NULL
);

CREATE TABLE "teams" (
  "id" SERIAL PRIMARY KEY,
  "team_name" varchar(255) NOT NULL,
  "description" text
);

CREATE TABLE "teams_users" (
  "id" SERIAL PRIMARY KEY,
  "user_id" int NOT NULL,
  "team_id" int NOT NULL
);

ALTER TABLE "teams_users" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "teams_users" ADD FOREIGN KEY ("team_id") REFERENCES "teams" ("id");
