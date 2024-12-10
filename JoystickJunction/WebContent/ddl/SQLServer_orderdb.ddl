CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review; 
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(64),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    Maturity            VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO category(categoryName) VALUES ('Action');
INSERT INTO category(categoryName) VALUES ('Adventure');
INSERT INTO category(categoryName) VALUES ('RPG');
INSERT INTO category(categoryName) VALUES ('Sport');
INSERT INTO category(categoryName) VALUES ('Strategy');

INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('God of War Ragnarök', 1, 'Embark on an epic journey with Kratos and Atreus in this action-packed game, combining fast-paced combat and an emotional narrative through the world of Norse mythology.', 69.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Elden Ring', 2, 'A vast open-world action RPG that blends intricate lore, exploration, and strategic combat, set in a dark fantasy world full of mysterious characters and challenging enemies.', 59.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Cyberpunk 2077', 2, 'Set in a neon-lit future, this open-world RPG features deep storytelling, diverse characters, and choices that shape the fate of a dystopian society.', 49.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Starfield', 2, 'Explore the uncharted vastness of space in this space exploration RPG, where you can create your own character and engage in a deep narrative-driven journey across the cosmos.', 69.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Hogwarts Legacy', 3, 'Live your dream as a wizard in this open-world adventure set in the Harry Potter universe, with magic, exploration, and a branching narrative that lets you shape your path at Hogwarts.', 69.99, 'Teen');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Call of Duty: Modern Warfare II', 4, 'A modern tactical first-person shooter that puts you in the middle of intense, fast-paced combat scenarios across global hotspots, offering both single-player and multiplayer modes.', 59.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Assassin''s Creed Mirage', 2, 'Set in the vibrant world of ninth-century Baghdad, this historical action-adventure game allows players to experience stealth and combat through the eyes of a young assassin.', 49.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Baldur''s Gate 3', 3, 'A richly detailed fantasy RPG that lets you create your own character and experience a story full of choices, consequences, and turn-based combat in a richly imagined world.', 69.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Spider-Man 2', 1, 'Swing through the streets of New York in this superhero action game, featuring fast-paced combat, acrobatic moves, and an engaging story with beloved Marvel characters.', 69.99, 'Teen');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Diablo IV', 3, 'A dark fantasy action RPG that brings players on a journey to stop the forces of Hell, with immersive lore, deep character customization, and thrilling dungeon crawling.', 59.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Final Fantasy XVI', 3, 'A grand fantasy RPG that combines epic battles, emotional storytelling, and immersive world-building in a tale of war, magic, and destiny.', 69.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Resident Evil 4 Remake', 2, 'This survival horror classic has been remastered for modern consoles, featuring intense combat, terrifying enemies, and a gripping narrative set in a haunted rural village.', 59.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Forza Horizon 5', 4, 'The latest entry in the open-world racing series, Forza Horizon 5 lets players explore the beautiful landscapes of Mexico while competing in thrilling races and challenges.', 59.99, 'Everyone');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('The Last of Us Part I', 3, 'This post-apocalyptic adventure follows Joel and Ellie as they navigate a world devastated by the Cordyceps fungus, blending survival, exploration, and emotionally-driven storytelling.', 59.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Red Dead Redemption 2', 1, 'An open-world western action game that lets players live the life of Arthur Morgan, a member of a gang on the run, filled with exploration, intense combat, and a deeply emotional narrative.', 39.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Horizon Forbidden West', 1, 'Follow Aloy as she ventures into the Forbidden West to uncover the mysteries of a post-apocalyptic Earth, with a mix of exploration, combat, and puzzle-solving mechanics.', 69.99, 'Teen');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('FC 24', 4, 'The latest installment in the EA Soccer Sports series, offering realistic soccer gameplay with new mechanics, updated teams, and a variety of modes for both casual and competitive players.', 69.99, 'Everyone');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('NBA 2K24', 4, 'A realistic basketball simulation game that features all the excitement of the NBA with lifelike gameplay, diverse modes, and competitive online play.', 69.99, 'Everyone');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Mortal Kombat 1', 1, 'A reboot of the classic fighting game, Mortal Kombat 1 brings back iconic characters and introduces cinematic story-driven battles with brutal fatalities and unique gameplay mechanics.', 59.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Street Fighter 6', 1, 'The next chapter in the legendary fighting series, Street Fighter 6 introduces new characters, moves, and a fresh story mode, all with a focus on competitive play and global online tournaments.', 59.99, 'Teen');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Super Mario Bros. Wonder', 1, 'A return to the classic platformer series, Super Mario Bros. Wonder brings fresh mechanics, vibrant worlds, and exciting new power-ups in this fun and fast-paced adventure for the Nintendo Switch.', 59.99, 'Everyone');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Gotham Knights', 2, 'Join the Bat-family as you fight crime in Gotham City in this action-adventure game, where you can play as Batgirl, Nightwing, Robin, or Red Hood to uncover dark secrets.', 49.99, 'Teen');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Star Wars Jedi: Survivor', 2, 'A thrilling action-adventure game that continues the story of Cal Kestis, set in the Star Wars universe, where you’ll engage in lightsaber combat and exploration through the galaxy.', 59.99, 'Teen');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Pokemon Scarlet and Violet', 1, 'Embark on an open-world adventure in the latest Pokémon game, where you can explore a new region, catch Pokémon, and experience a dynamic, evolving world with new gameplay mechanics.', 59.99, 'Everyone');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Dead Space Remake', 6, 'This survival horror game takes place in space, where players must survive an alien infestation aboard a derelict ship, facing terrifying enemies and intense moments of dread.', 59.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Alan Wake 2', 3, 'A psychological thriller that combines horror and action, Alan Wake 2 follows the writer Alan as he battles against the darkness that consumes his world, blending storytelling with intense gameplay.', 59.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Dying Light 2', 2, 'A parkour-infused zombie survival game set in a sprawling open world, Dying Light 2 challenges players to survive in a brutal environment with fast-paced combat and important moral choices.', 49.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('The Witcher 3: Wild Hunt', 5, 'This critically acclaimed RPG follows Geralt of Rivia on a quest to find his adopted daughter, with deep storytelling, engaging combat, and a vast open world full of monsters and intrigue.', 29.99, 'Mature');
INSERT product(productName, categoryId, productDesc, productPrice, Maturity) VALUES ('Mass Effect Legendary Edition', 5, 'The remastered trilogy of the epic sci-fi RPG series, Mass Effect, lets players guide Commander Shepard through a galaxy at war with rich characters, strategic combat, and story-driven gameplay.', 49.99, 'Mature');




INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 69.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 59.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 49.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 69.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 69.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 59.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 49.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 69.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 69.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 3, 59.99);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);

-- New SQL DDL for lab 8
UPDATE Product SET productImageURL = 'img/1.jpg' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/2.jpg' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/3.jpg' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/4.jpg' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/5.jpg' WHERE ProductId = 5;

ALTER TABLE product ADD imagePath NVARCHAR(255);

ALTER TABLE orderproduct
DROP CONSTRAINT FK__orderprod__produ__17C286CF;

ALTER TABLE orderproduct
ADD CONSTRAINT FK__orderprod__produ__17C286CF
FOREIGN KEY (productId) REFERENCES product(productId)
ON DELETE CASCADE;

ALTER TABLE orderproduct
ADD CONSTRAINT FK__orderprod__produ__17C286CF
FOREIGN KEY (productId) REFERENCES product(productId)
ON DELETE CASCADE;

ALTER TABLE productinventory
ADD CONSTRAINT FK__productin__produ__43A1090D
FOREIGN KEY (productId) REFERENCES product(productId)
ON DELETE CASCADE;