
CREATE TABLE Users(
	userID INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(20) NOT NULL,
	hashed_password BINARY(20) NOT NULL,
	email VARCHAR(50) NOT NULL,
	title VARCHAR(10),
	verified BINARY(1) NOT NULL,
	PRIMARY KEY (userID),
	UNIQUE KEY username (username),
	UNIQUE KEY hashed_password (hashed_password)
);

CREATE TABLE Articles(
	articleID INT NOT NULL AUTO_INCREMENT,
	article_name VARCHAR(60) NOT NULL,
	verify_status BINARY(1) NOT NULL,
	post_date DATETIME NOT NULL,
	author VARCHAR(20) NOT NULL,
	content TEXT NOT NULL,
	PRIMARY KEY (articleID)
);

CREATE TABLE Pets(
	petID INT NOT NULL AUTO_INCREMENT,
	rehome BINARY(1) NOT NULL,
	PRIMARY KEY (petID)
);

CREATE TABLE Species(
	scientific_name VARCHAR(60) NOT NULL,
	common_name VARCHAR(30) NOT NULL,
	animal_type VARCHAR(30) NOT NULL,
	coloration TEXT,
	PRIMARY KEY(scientific_name, animal_type)
);

CREATE TABLE PetPages(
	pet_name VARCHAR(30) NOT NULL,
	picture BLOB,
	info TEXT,
	breed_name VARCHAR(40),
	petID INT NOT NULL,
	PRIMARY KEY(petID)
);

CREATE TABLE Profiles(
	name VARCHAR(30) NOT NULL,
	location VARCHAR(40),
	bio TEXT,
	visible_email BINARY(1),
	userID INT NOT NULL,
	PRIMARY KEY(userID)
);

CREATE TABLE Owners(
	userID INT NOT NULL,
	petID INT NOT NULL,
	PRIMARY KEY(userID, petID)
);


--Password hashing function--
CREATE FUNCTION saltedHash(username VARCHAR(20), user_password VARCHAR(20))
RETURNS BINARY(20) DETERMINISTIC
RETURN UNHEX(SHA1(CONCAT(username, user_password)));

--Procedure to create an article
CREATE PROCEDURE createArticle(IN inUsername VARCHAR(20), IN inPassword VARCHAR(20), IN inArticleName VARCHAR(60), IN inContent TEXT)
BEGIN
	DECLARE UserID INT;
	DECLARE result VARCHAR(225);

	SELECT userID
	FROM Users
	WHERE username = inUsername
	AND hashed_password  = saltedHash(inUsername, inPassword)
	LIMIT 1
	INTO UserID;

	IF UserID IS NULL THEN
		SET result = 'Invalid credentials';
	ELSE
		INSERT
			INTO Articles(article_name, verify_status, post_date, content, author)
			VALUES (inArticleName, NO, NOW(), inContent, inUsername);
			SET result = 'Post created!';
	END IF;

	SELECT result;
END

--Add foreign keys to the tables--
ALTER TABLE Articles
    ADD CONSTRAINT author_user_fk
	FOREIGN KEY (author) REFERENCES Users(username);

ALTER TABLE PetPages
    ADD CONSTRAINT pet_petPage_fk
	FOREIGN KEY(petID) REFERENCES Pets(petID);

ALTER TABLE Profiles
    ADD CONSTRAINT user_profile_fk
	FOREIGN KEY(userID) REFERENCES Users(userID);

ALTER TABLE Owners
    ADD CONSTRAINT owner_valid_fk
	FOREIGN KEY(userID) REFERENCES Users(userID);
ALTER TABLE Owners
    ADD CONSTRAINT pet_valid_fk
	FOREIGN KEY(petID) REFERENCES Pets(petID);

--Procedure to create a profile page
CREATE PROCEDURE createProfile(IN inUsername VARCHAR(20), IN inPassword VARCHAR(20), IN inName VARCHAR(30), IN inLocation VARCHAR(40), IN inBio TEXT, IN inVisibleEmail BINARY(1))
BEGIN
	DECLARE UserID INT;
	DECLARE result VARCHAR(225);

	SELECT userID
	FROM Users
	WHERE username = inUsername
	AND hashed_password  = saltedHash(inUsername, inPassword)
	LIMIT 1
	INTO UserID;

	IF UserID IS NULL THEN
		SET result = 'Invalid credentials';
	ELSE
		INSERT
			INTO Profiles(name, location, bio, visible_email, userID)
			VALUES (inName, inLocation, inBio, inVisibleEmail, UserID);
			SET result = 'Profile Created!';
	END IF;

	SELECT result;
END

--Procedure to create a pet
CREATE PROCEDURE createPet(IN inUsername VARCHAR(20), IN inPassword VARCHAR(20), IN inPetName VARCHAR(30), IN inPicture BLOB, IN inInfo TEXT, IN inBreedName VARCHAR(40), IN inRehome BINARY(1))
BEGIN
	DECLARE UserID INT;
	DECLARE PetID INT;
	DECLARE result VARCHAR(225);

	SELECT userID
	FROM Users
	WHERE username = inUsername
	AND hashed_password  = saltedHash(inUsername, inPassword)
	LIMIT 1
	INTO UserID;

	IF UserID IS NULL THEN
		SET result = 'Invalid credentials';
	ELSE
		INSERT
			INTO Pets(rehome)
			VALUES (inRehome);
			
		SELECT LAST_INSERT_ID()
		INTO PetID;
			
		INSERT
			INTO Owners(userID, petID)
			VALUES (UserID, PetID);
	
		INSERT
			INTO PetPages(pet_name, picture, info, breed_name, petID)
			VALUES (inPetName, inPicture, inInfo, inBreedName, PetID);
			SET result = 'Pet Created!';
	END IF;
	SELECT result;
END

--Procedure to update a profile page
CREATE PROCEDURE updateProfile(IN inUsername VARCHAR(20), IN inPassword VARCHAR(20), IN inName VARCHAR(30), IN inLocation VARCHAR(40), IN inBio TEXT, IN inVisibleEmail BINARY(1))
BEGIN
	DECLARE UserID INT;
	DECLARE result VARCHAR(225);

	SELECT userID
	FROM Users
	WHERE username = inUsername
	AND hashed_password  = saltedHash(inUsername, inPassword)
	LIMIT 1
	INTO UserID;

	IF UserID IS NULL THEN
		SET result = 'Invalid credentials';
	ELSE
		UPDATE Profiles
			SET name = inName, location = inLocation, bio = inBio, visible_email = inVisibleEmail
			WHERE userID = UserID;
			SET result = 'Profile Updated!';
	END IF;

	SELECT result;
END

--Procedure to update a pet
CREATE PROCEDURE updatePet(IN inUsername VARCHAR(20), IN inPassword VARCHAR(20), IN inPetName VARCHAR(30), IN inPicture BLOB, IN inInfo TEXT, IN inBreedName VARCHAR(40), IN inRehome BINARY(1), IN inPetID INT)
BEGIN
	DECLARE UserID INT;
	DECLARE result VARCHAR(225);

	SELECT userID
	FROM Users
	WHERE username = inUsername
	AND hashed_password  = saltedHash(inUsername, inPassword)
	LIMIT 1
	INTO UserID;

	IF UserID IS NULL THEN
		SET result = 'Invalid credentials';
	ELSE
		UPDATE Pets
			SET rehome = inRehome
			WHERE petID = inPetID;
	
		UPDATE PetPages
			SET pet_name = inPetName, picture = inPicture, info = inInfo, breed_name = inBreedName
			WHERE inPetID;
		SET result = 'Pet Updated!';
	END IF;
	
	SELECT result;
END

--Procedure to verify an Article
CREATE PROCEDURE verifyArticle(IN inUsername VARCHAR(20), IN inPassword VARCHAR(20), IN inVerify BINARY(1), IN inArticleID INT)
BEGIN
	DECLARE UserID INT;
	DECLARE result VARCHAR(225);

	SELECT userID
	FROM Users
	WHERE username = inUsername
	AND hashed_password  = saltedHash(inUsername, inPassword)
	AND title = 'ADMIN'
	LIMIT 1
	INTO UserID;

	IF UserID IS NULL THEN
		SET result = 'Invalid credentials';
	ELSE
		UPDATE Articles
			SET verified = inVerify
			WHERE articleID = inArticleID;
			SET result = 'Article Verified!';
	END IF;

	SELECT result;
END