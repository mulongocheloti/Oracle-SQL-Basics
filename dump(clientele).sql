--ServiceMatch Database System


DROP TABLE CLIENT cascade constraints;
DROP TABLE CORPORATE_CLIENT cascade constraints;
DROP TABLE INDIVIDUAL_CLIENT cascade constraints;
DROP TABLE BUSINESS cascade constraints;
DROP TABLE FREELANCER_BUSINESS cascade constraints;
DROP TABLE CORPORATE_BUSINESS cascade constraints;
DROP TABLE JOB cascade constraints;
DROP TABLE CONTRACT_JOB cascade constraints;
DROP TABLE CASUAL_JOB cascade constraints;
DROP TABLE INDUSTRY cascade constraints;
DROP TABLE TRADE_UNION cascade constraints;
DROP TABLE SUBURB cascade constraints;
DROP TABLE INVOICE cascade constraints;
DROP TABLE SEMINAR cascade constraints;
DROP TABLE QUOTATION cascade constraints;
DROP TABLE BUSINESS_INDUSTRY cascade constraints;
DROP TABLE ADJACENT_SUBURB cascade constraints;
DROP TABLE ELITE_MEMBER cascade constraints;
DROP TABLE SEMINAR_ATTENDIES cascade constraints;


-- PURGE RECYCLEBIN


----- CREATE TABLE STATEMENTS -----


-- CLIENT (ClientNo, ClientName, ClientAddress, ClientPhone, ClientEmail)
CREATE TABLE CLIENT(
ClientNo      VARCHAR2(10)  NOT NULL,
ClientName                 VARCHAR2(20),
ClientAddress VARCHAR2(50),
ClientPhone                VARCHAR2(20),
ClientEmail   VARCHAR2(50),
PRIMARY KEY(ClientNo));


--CORPORATE_CLIENT (ClientNo, CorporationName, BusinessAddress)
CREATE TABLE CORPORATE_CLIENT(
ClientNo          VARCHAR2(10)  NOT NULL,
CorporationName   VARCHAR2(50),
BusinessAddress   VARCHAR2(50),
PRIMARY KEY(ClientNo),
FOREIGN KEY (ClientNo) REFERENCES CLIENT (ClientNo));


--INDIVIDUAL_CLIENT (ClientNo, PropertyOwner)
CREATE TABLE INDIVIDUAL_CLIENT(
ClientNo          VARCHAR2(10)  NOT NULL,
PropertyOwner     CHAR(1) CHECK(PropertyOwner IN ('Y', 'y', 'N', 'n')),
PRIMARY KEY(ClientNo),
FOREIGN KEY (ClientNo) REFERENCES CLIENT (ClientNo));


--BUSINESS (ABNNumber, BusinessName, ContactName, ContactNumber, ContactEmail, BusinessAddress, BusinessPostcode)
CREATE TABLE BUSINESS(
ABNNumber       VARCHAR2(11)  NOT NULL, --ABN Number is always 11 digits
BusinessName                 VARCHAR2(50),
ContactName     VARCHAR2(20),
ContactNumber                VARCHAR2(20),
ContactEmail    VARCHAR2(50),
BusinessAddress VARCHAR2(50),
BusinessPostcode NUMBER(4),
PRIMARY KEY(ABNNumber));


--ELITE_MEMBER (EliteMemberID)
CREATE TABLE ELITE_MEMBER(
EliteMemberID   VARCHAR2(10) NOT NULL,
PRIMARY KEY(EliteMemberID));


--FREELANCER_BUSINESS (ABNNumber, EliteMemberID)
CREATE TABLE FREELANCER_BUSINESS(
ABNNumber       VARCHAR2(11)  NOT NULL, --ABN Number is always 11 digits
EliteMemberID   VARCHAR2(10),
PRIMARY KEY(ABNNumber),
FOREIGN KEY (ABNNumber) REFERENCES BUSINESS (ABNNumber),
FOREIGN KEY (EliteMemberID) REFERENCES ELITE_MEMBER(EliteMemberID));


--CORPORATE_BUSINESS (ABNNumber)
CREATE TABLE CORPORATE_BUSINESS(
ABNNumber       VARCHAR2(11)  NOT NULL, --ABN Number is always 11 digits
PRIMARY KEY(ABNNumber),
FOREIGN KEY (ABNNumber) REFERENCES BUSINESS (ABNNumber));


--SUBURB (Postcode, SuburbName)
CREATE TABLE SUBURB(
Postcode        NUMBER(4)  NOT NULL,
SuburbName                   VARCHAR2(20),
PRIMARY KEY(Postcode));


--ADJACENT_SUBURB (PostCode, AdjacentPostCode)
CREATE TABLE ADJACENT_SUBURB(
Postcode          NUMBER(4)  NOT NULL,
AdjacentPostCode  NUMBER(4)  NOT NULL,
PRIMARY KEY(Postcode, AdjacentPostCode),
FOREIGN KEY (Postcode) REFERENCES SUBURB(Postcode),
FOREIGN KEY (AdjacentPostCode) REFERENCES SUBURB(Postcode));


--TRADE_UNION (UnionID, UnionContactName, UnionContactNumber, UnionEmail, UnionAddress, EliteMemberID)
CREATE TABLE TRADE_UNION(
UnionID             VARCHAR2(10)  NOT NULL,
UnionTitle          VARCHAR2(50),
UnionContactName                 VARCHAR2(20),
UnionContactNumber        VARCHAR2(20),
UnionEmail          VARCHAR2(50),
UnionAddress        VARCHAR2(50),
EliteMemberID       VARCHAR2(10),
PRIMARY KEY(UnionID),
FOREIGN KEY (EliteMemberID) REFERENCES ELITE_MEMBER (EliteMemberID));


--INDUSTRY (IndustryID, IndustryTitle, UnionID)
CREATE TABLE INDUSTRY(
IndustryID          VARCHAR2(10)  NOT NULL,
IndustryTitle                   VARCHAR2(50),
UnionID             VARCHAR2(10),
PRIMARY KEY(IndustryID),
FOREIGN KEY (UnionID) REFERENCES TRADE_UNION (UnionID));


--JOB (JobID, JobDescription, UrgencyLevel, JobAddress, Postcode, IndustryID, SelectedBusinessABNNumber)
CREATE TABLE JOB(
JobID               VARCHAR2(10)  NOT NULL,
JobDescription                   VARCHAR2(50),
UrgencyLevel        VARCHAR2(10) CHECK(UrgencyLevel IN('Low', 'Normal', 'Immediate')),
JobAddress          VARCHAR2(50),
Postcode            NUMBER(4),
IndustryID          VARCHAR2(10),
SelectedBusinessABNNumber VARCHAR2(11),
PRIMARY KEY(JobID),
FOREIGN KEY (Postcode) REFERENCES SUBURB(Postcode),
FOREIGN KEY (SelectedBusinessABNNumber) REFERENCES BUSINESS(ABNNumber),
FOREIGN KEY (IndustryID) REFERENCES INDUSTRY(IndustryID));


--CONTRACT_JOB (JobID, StartDate, EndDate, CorporateClientNo)
CREATE TABLE CONTRACT_JOB(
JobID               VARCHAR2(10)  NOT NULL,
StartDate           DATE,
EndDate             DATE,
CorporateClientNo   VARCHAR2(10)  NOT NULL,
PRIMARY KEY(JobID),
FOREIGN KEY (JobID) REFERENCES JOB(JobID),
FOREIGN KEY (CorporateClientNo) REFERENCES CORPORATE_CLIENT(ClientNo));


--CASUAL_JOB (JobID, IndividualClientNo)
CREATE TABLE CASUAL_JOB(
JobID               VARCHAR2(10)  NOT NULL,
IndividualClientNo  VARCHAR2(10)  NOT NULL,
PRIMARY KEY(JobID),
FOREIGN KEY (JobID) REFERENCES JOB(JobID),
FOREIGN KEY (IndividualClientNo) REFERENCES INDIVIDUAL_CLIENT(ClientNo));


--INVOICE (InvoiceNo, Amount, JobID)
CREATE TABLE INVOICE(
InvoiceNo   VARCHAR2(10)  NOT NULL,
Amount      NUMBER(7,2),
JobID       VARCHAR2(10)  NOT NULL,
PRIMARY KEY(InvoiceNo),
FOREIGN KEY(JobID) REFERENCES JOB(JobID));


--SEMINAR (SeminarID, SeminarTitle, SeminarDataTime, SeminarVenue)
CREATE TABLE SEMINAR(
SeminarID         VARCHAR2(10)  NOT NULL,
SeminarTitle      VARCHAR2(50),
SeminarDateTime  TIMESTAMP,
SeminarVenue      VARCHAR2(50),
PRIMARY KEY(SeminarID));


--QUOTATION (JobID, ABNNumber, QuoteAmount, QuoteStatus)
CREATE TABLE QUOTATION(
JobID            VARCHAR2(10)  NOT NULL,
ABNNumber        VARCHAR2(11)  NOT NULL,
QuoteAmount      NUMBER(7,2)   NOT NULL,
PRIMARY KEY(JobID, ABNNumber),
FOREIGN KEY (JobID) REFERENCES JOB(JobID),
FOREIGN KEY (ABNNumber) REFERENCES BUSINESS(ABNNumber));


--BUSINESS_INDUSTRY (ABNNumber, IndustryID)
CREATE TABLE BUSINESS_INDUSTRY(
ABNNumber     VARCHAR2(11)  NOT NULL,
IndustryID    VARCHAR2(10)  NOT NULL,
PRIMARY KEY(ABNNumber, IndustryID),
FOREIGN KEY(ABNNumber) REFERENCES BUSINESS(ABNNumber),
FOREIGN KEY(IndustryID) REFERENCES INDUSTRY(IndustryID));


--SEMINAR_ATTENDIES (EliteMemberID, SeminarID)
CREATE TABLE SEMINAR_ATTENDIES(
EliteMemberID   VARCHAR2(10)  NOT NULL,
SeminarID       VARCHAR2(10)  NOT NULL,
PRIMARY KEY(EliteMemberID, SeminarID),
FOREIGN KEY(EliteMemberID) REFERENCES ELITE_MEMBER(EliteMemberID),
FOREIGN KEY(SeminarID) REFERENCES SEMINAR(SeminarID));


----DUMMY DATA INSERTION COMMANDS-----------------
-- CLIENT (ClientNo, ClientName, ClientAddress, ClientPhone, ClientEmail)
INSERT INTO CLIENT VALUES('1','Rachel Green', '63 Rosebery Avenue, Preston', '0540677455', 'rachel.green@gmail.com');
INSERT INTO CLIENT VALUES('2','Kazi Gellar', '57 Rosebery Rd, Preston', '0450677456', 'kazi.gellar@gmail.com');
INSERT INTO CLIENT VALUES('3','Syed Ahmed', '123 Waratah St, Thomastown', '0450672446', 'syed.ahmed@gmail.com');
INSERT INTO CLIENT VALUES('4','Esrar Mahbub', '3 Kingsburry Dr, Bundoora', '044576823', 'esrar.mahbub@gmail.com');
INSERT INTO CLIENT VALUES('5','Samira Sadmin', '1053 Kingsburry Dr, Bundoora', '0411077455', 'samira.sadmin@gmail.com');
INSERT INTO CLIENT VALUES('6','Adam Lever', '11 Cheddar Rd, Reservoir', '0440677455', 'adam.lever@gmail.com');
INSERT INTO CLIENT VALUES('7','Kazi Nipu', '12 Belah St, Thomastown', '0123477455', 'kazi.nipu@gmail.com');
INSERT INTO CLIENT VALUES('8','Arefin Islam', '32 Grace St, Laverton', '0390677455', 'arefin.islam@gmail.com');
INSERT INTO CLIENT VALUES('9','Roger Federer', '11 Alps Rd, Melbourne', '0455577455', 'roger.federer@gmail.com');
INSERT INTO CLIENT VALUES('10','Andy Marray', '13 Kings Rd, Melbourne', '0555577456', 'andy.marray@gmail.com');
INSERT INTO CLIENT VALUES('11','Joe Santrini', '56 Dunne St, Bundoora', '0540677467', 'joe.santrini@gmail.com');
INSERT INTO CLIENT VALUES('12','David Packman', '11 St Kilda Rd, Melbourne', '0540677411', 'david.packman@gmail.com');
INSERT INTO CLIENT VALUES('13','Cristopher Nolan', '15 Lonsdale St, Melbourne', '0540677477', 'c.nolan@gmail.com');
INSERT INTO CLIENT VALUES('14','Bruse Wayne', '10 Batcave Aveneu, Epping', '0111111455', 'bruce.wayne@gmail.com');
INSERT INTO CLIENT VALUES('15','Chandler Bing', '2/80 Friends Rd, Altona', '0540677222', 'chandler.bing@gmail.com');
INSERT INTO CLIENT VALUES('16','Ross Geller', '33 Waratah St, Altona', '0540444455', 'ross.geller@gmail.com');
INSERT INTO CLIENT VALUES('17','Joe Tribiany', '3/80 Friends Rd, Altona', '0540677221', 'joe.tribiany@gmail.com');
INSERT INTO CLIENT VALUES('18','Jack Roland', '41 Alexander Avenue, Thomastown', '0540677999', 'jack.roland@gmail.com');
INSERT INTO CLIENT VALUES('19','Henry Steven', '2 Queens St, Melbourne', '0450872449', 'henry.steven@gmail.com');
INSERT INTO CLIENT VALUES('20','Ragibul Hasan', '13 Swanston St, Melbourne', '0540687878', 'ragibul.hasan@gmail.com');


--CORPORATE_CLIENT (ClientNo, CorporationName, BusinessAddress)
INSERT INTO CORPORATE_CLIENT VALUES('1', 'Apple Inc', '10 Southbank, Melbourne');
INSERT INTO CORPORATE_CLIENT VALUES('2', 'Microsoft', '15 Southbank, Melbourne');
INSERT INTO CORPORATE_CLIENT VALUES('3', 'Dell', '23 High St, Preston');
INSERT INTO CORPORATE_CLIENT VALUES('4', 'IBM', '628 Victoria St, Epping');
INSERT INTO CORPORATE_CLIENT VALUES('5', 'Grocon', '180 Swanston St, Melbourne');
INSERT INTO CORPORATE_CLIENT VALUES('6', 'La Trobe University', 'Plenty Road and Kingsburry Drive, Bundoora');
INSERT INTO CORPORATE_CLIENT VALUES('7', 'Public Transport Victoria', '750 Collins St, Melbourne');
INSERT INTO CORPORATE_CLIENT VALUES('8', 'RACV', '105 Grimshaw St, Greensborough');
INSERT INTO CORPORATE_CLIENT VALUES('9', 'Woolworths', '1 Bell St, Preston');
INSERT INTO CORPORATE_CLIENT VALUES('10', 'Coles', '71 May Rd, Lalor');


--INDIVIDUAL_CLIENT (ClientNo, PropertyOwner)
INSERT INTO INDIVIDUAL_CLIENT VALUES('11', 'Y');
INSERT INTO INDIVIDUAL_CLIENT VALUES('12', 'Y');
INSERT INTO INDIVIDUAL_CLIENT VALUES('13', 'N');
INSERT INTO INDIVIDUAL_CLIENT VALUES('14', 'N');
INSERT INTO INDIVIDUAL_CLIENT VALUES('15', 'Y');
INSERT INTO INDIVIDUAL_CLIENT VALUES('16', 'N');
INSERT INTO INDIVIDUAL_CLIENT VALUES('17', 'Y');
INSERT INTO INDIVIDUAL_CLIENT VALUES('18', 'N');
INSERT INTO INDIVIDUAL_CLIENT VALUES('19', 'N');
INSERT INTO INDIVIDUAL_CLIENT VALUES('20', 'N');


--BUSINESS (ABNNumber, BusinessName, ContactName, ContactNumber, ContactEmail, BusinessAddress, BusinessPostcode)
INSERT INTO BUSINESS VALUES('12345678911', 'James Mowers and Landscape', 'James Handerson', '038122354', 'james@yahoo.com', '2 Davidson st, Epping', 3076);
INSERT INTO BUSINESS VALUES('12345678912', 'Consolidated Proerty Services', 'Monica Rashid', '039342354', 'hrashid@cps.com', 'Cr Lonsdale St and Russel St, Melbourne', 3000);
INSERT INTO BUSINESS VALUES('12345678913', 'Kohlan Movers', 'Vicky Kohlan', '039342355', 'moversk@gmail.com', '4/3 Grace St, Laverton', 3028);
INSERT INTO BUSINESS VALUES('12345678914', 'Pumbers Delivered', 'Harry Tradil', '039342344', 'harryt@hotmail.com', '3 Station St, Reservoir', 3073);
INSERT INTO BUSINESS VALUES('12345678915', 'Anytime Plumbers', 'Joseph Green', '039342322', 'jgreen@hotmail.com', '11 Station St, Reservoir', 3073);
INSERT INTO BUSINESS VALUES('12345678916', 'Change the Fuse Electricals', 'Brian Adams', '039342311', 'adamsb@yahoo.com.au', '12 Laimar St, Sunbury', 3429);
INSERT INTO BUSINESS VALUES('12345678917', 'Vicky Electricals', 'Vicky Hasan', '039342300', 'vickyh@gmail.com', '12 Wood St, North Melbourne', 3051);
INSERT INTO BUSINESS VALUES('12345678918', 'Leak and Roof Repair', 'David Bongiorno', '039342400', 'davidb@yahoo.com', '101 Swanston St, Melbourne', 3000);
INSERT INTO BUSINESS VALUES('12345678919', 'Construction Solutions', 'Garry Hobart', '039342399', 'garryh@hotmail.com', '21 Albundy Gr, St Kilda', 3182);
INSERT INTO BUSINESS VALUES('12345678920', 'Build a House', 'Jason Staham', '039342388', 'jasons@hotmail.com', '1055 Plenty Rd, Bundoora', 3083);
INSERT INTO BUSINESS VALUES('12345678921', 'Hire a Wire', 'David Sully', '039341188', 'davids@yourmail.com', '67 Cramer St, Preston', 3072);
INSERT INTO BUSINESS VALUES('12345678922', 'Joe''s Rubbish Removal', 'Joseph Mahmud', '039342001', 'joseph@openmail.com', '108 Bell St, Preston', 3072);
INSERT INTO BUSINESS VALUES('12345678923', 'Do it Right Mowers', 'Abdullah Mamun', '038122333', 'mamun@yahoo.com', '31 Stephen St, Epping', 3076);
INSERT INTO BUSINESS VALUES('12345678924', 'Shine Cleaning', 'Cyn Jones', '038128989', 'jonesc@gmail.com', '17 Husband St, Eltham', 3095);
INSERT INTO BUSINESS VALUES('12345678925', 'Moveit', 'Sunny Joe', '038000033', 'sunny@hotmail.com', '90 Russel St, Melbourne', 3000);
INSERT INTO BUSINESS VALUES('12345678926', 'Home Cleaning Services', 'Omid Rostami', '038002333', 'omid@hotmail.com', '40 Statino St, North Melbourne', 3051);
INSERT INTO BUSINESS VALUES('12345678927', '24X7 Plumbing Service', 'Hayden Jones', '045002333', 'hjones@yahoo.com', '12 Rathdown Rd, Melbourne', 3000);
INSERT INTO BUSINESS VALUES('12345678928', 'Muscle Rubbish Removals', 'Alex Sanders', '045067633', 'alex@mrr.com.au', '57 Leeds St, Thomastown', 3074);


--CORPORATE_BUSINESS (ABNNumber)
INSERT INTO CORPORATE_BUSINESS VALUES('12345678911');
INSERT INTO CORPORATE_BUSINESS VALUES('12345678912');
INSERT INTO CORPORATE_BUSINESS VALUES('12345678914');
INSERT INTO CORPORATE_BUSINESS VALUES('12345678915');
INSERT INTO CORPORATE_BUSINESS VALUES('12345678916');
INSERT INTO CORPORATE_BUSINESS VALUES('12345678918');
INSERT INTO CORPORATE_BUSINESS VALUES('12345678919');
INSERT INTO CORPORATE_BUSINESS VALUES('12345678920');
INSERT INTO CORPORATE_BUSINESS VALUES('12345678921');
INSERT INTO CORPORATE_BUSINESS VALUES('12345678928');


--ELITE_MEMBER (EliteMemberID)
INSERT INTO ELITE_MEMBER VALUES('1');
INSERT INTO ELITE_MEMBER VALUES('2');
INSERT INTO ELITE_MEMBER VALUES('3');
INSERT INTO ELITE_MEMBER VALUES('4');
INSERT INTO ELITE_MEMBER VALUES('5');
INSERT INTO ELITE_MEMBER VALUES('6');
INSERT INTO ELITE_MEMBER VALUES('7');
INSERT INTO ELITE_MEMBER VALUES('8');
INSERT INTO ELITE_MEMBER VALUES('9');
INSERT INTO ELITE_MEMBER VALUES('10');
INSERT INTO ELITE_MEMBER VALUES('11');
INSERT INTO ELITE_MEMBER VALUES('12');
INSERT INTO ELITE_MEMBER VALUES('13');


--FREELANCER_BUSINESS (ABNNumber, EliteMemberID)
INSERT INTO FREELANCER_BUSINESS VALUES('12345678913', '1');
INSERT INTO FREELANCER_BUSINESS VALUES('12345678917', '2');
INSERT INTO FREELANCER_BUSINESS VALUES('12345678922', '3');
INSERT INTO FREELANCER_BUSINESS VALUES('12345678923', '4');
INSERT INTO FREELANCER_BUSINESS VALUES('12345678924', '5');
INSERT INTO FREELANCER_BUSINESS VALUES('12345678925', null);
INSERT INTO FREELANCER_BUSINESS VALUES('12345678926', '13');
INSERT INTO FREELANCER_BUSINESS VALUES('12345678927', '6');


--SUBURB (Postcode, SuburbName)
INSERT INTO SUBURB VALUES(3083, 'Bundoora');
INSERT INTO SUBURB VALUES(3000, 'Melbourne');
INSERT INTO SUBURB VALUES(3076, 'Epping');
INSERT INTO SUBURB VALUES(3028, 'Laverton');
INSERT INTO SUBURB VALUES(3073, 'Reservoir');
INSERT INTO SUBURB VALUES(3074, 'Thomastown');
INSERT INTO SUBURB VALUES(3429, 'Sunbury');
INSERT INTO SUBURB VALUES(3182, 'St Kilda');
INSERT INTO SUBURB VALUES(3051, 'North Melbourne');
INSERT INTO SUBURB VALUES(3072, 'Preston');
INSERT INTO SUBURB VALUES(3095, 'Eltham');
INSERT INTO SUBURB VALUES(3018, 'Altona');
INSERT INTO SUBURB VALUES(3088, 'Greensborough');
INSERT INTO SUBURB VALUES(3075, 'Lalor');


--ADJACENT_SUBURB (PostCode, AdjacentPostCode)
INSERT INTO ADJACENT_SUBURB VALUES(3083, 3072);
INSERT INTO ADJACENT_SUBURB VALUES(3072, 3083);
INSERT INTO ADJACENT_SUBURB VALUES(3072, 3074);
INSERT INTO ADJACENT_SUBURB VALUES(3074, 3072);
INSERT INTO ADJACENT_SUBURB VALUES(3072, 3073);
INSERT INTO ADJACENT_SUBURB VALUES(3073, 3072);
INSERT INTO ADJACENT_SUBURB VALUES(3083, 3074);
INSERT INTO ADJACENT_SUBURB VALUES(3074, 3083);
INSERT INTO ADJACENT_SUBURB VALUES(3073, 3083);
INSERT INTO ADJACENT_SUBURB VALUES(3083, 3073);
INSERT INTO ADJACENT_SUBURB VALUES(3028, 3018);
INSERT INTO ADJACENT_SUBURB VALUES(3018, 3028);
INSERT INTO ADJACENT_SUBURB VALUES(3075, 3074);
INSERT INTO ADJACENT_SUBURB VALUES(3074, 3075);
INSERT INTO ADJACENT_SUBURB VALUES(3072, 3075);
INSERT INTO ADJACENT_SUBURB VALUES(3075, 3072);
INSERT INTO ADJACENT_SUBURB VALUES(3083, 3088);
INSERT INTO ADJACENT_SUBURB VALUES(3088, 3083);
INSERT INTO ADJACENT_SUBURB VALUES(3095, 3088);
INSERT INTO ADJACENT_SUBURB VALUES(3088, 3095);
INSERT INTO ADJACENT_SUBURB VALUES(3182, 3000);
INSERT INTO ADJACENT_SUBURB VALUES(3000, 3182);
INSERT INTO ADJACENT_SUBURB VALUES(3000, 3051);
INSERT INTO ADJACENT_SUBURB VALUES(3051, 3000);
INSERT INTO ADJACENT_SUBURB VALUES(3083, 3076);
INSERT INTO ADJACENT_SUBURB VALUES(3076, 3083);
INSERT INTO ADJACENT_SUBURB VALUES(3072, 3076);
INSERT INTO ADJACENT_SUBURB VALUES(3076, 3072);
INSERT INTO ADJACENT_SUBURB VALUES(3076, 3075);
INSERT INTO ADJACENT_SUBURB VALUES(3075, 3076);




--TRADE_UNION (UnionID, UnionTitle, UnionContactName, UnionContactNumber, UnionEmail, UnionAddress, EliteMemberID)
INSERT INTO TRADE_UNION VALUES('1', 'Mowers'' Union', 'John Doe', '0460782331','mowers.union@gmail.com', '15 Flinders St, Melbourne', '7');
INSERT INTO TRADE_UNION VALUES('2', 'Cleaners'' Union', 'Jane Joe', '0460782332','cleaners.union@gmail.com', '11 Bourke St, Melbourne', '8');
INSERT INTO TRADE_UNION VALUES('3', 'Movers'' Union', 'Jack Hammer', '0460782333','movers.union@gmail.com', '9 La Trobe St, Melbourne','9');
INSERT INTO TRADE_UNION VALUES('4', 'Electricians'' Union', 'John Board', '0460782334','electricians.union@gmail.com', '19 Collins St, Melbourne', '10');
INSERT INTO TRADE_UNION VALUES('5', 'Plumbers'' Union', 'Loren Daniels', '0460782335','plumbers.union@gmail.com', '2/34 Little Lonsdale St, Melbourne', '11');
INSERT INTO TRADE_UNION VALUES('6', 'Construction Workers'' Union', 'Harvey Dent', '0460782336','constructionworkers.union@gmail.com', 'Lonsdale St and Russel St, Melbourne', '12');


--INDUSTRY (IndustryID, IndustryTitle, UnionID)
INSERT INTO INDUSTRY VALUES('1', 'Cleaning', '2');
INSERT INTO INDUSTRY VALUES('2', 'Heavy Goods Transport', '3');
INSERT INTO INDUSTRY VALUES('3', 'Landscape', '1');
INSERT INTO INDUSTRY VALUES('4', 'Lawn and Backyard Mowing', '1');
INSERT INTO INDUSTRY VALUES('5', 'Plumbing', '5');
INSERT INTO INDUSTRY VALUES('6', 'Electrical Works', '4');
INSERT INTO INDUSTRY VALUES('7', 'Roof Restoration', '6');
INSERT INTO INDUSTRY VALUES('8', 'General Construction', '6');
INSERT INTO INDUSTRY VALUES('9', 'Demolition and Rubbish Removal', '6');




--JOB (JobID, JobDescription, UrgencyLevel, JobAddress, Postcode, IndustryID, SelectedBusinessABNNumber)
INSERT INTO JOB VALUES('1', 'I need my lawn mowed', 'Immediate', '56 Dunne St, Bundoora', 3083, '4', NULL);
INSERT INTO JOB VALUES('2', 'Backyard mowing job', 'Normal', '11 St Kilda Rd, Melbourne', 3000, '4', NULL);
INSERT INTO JOB VALUES('3', 'Need help to move to a new house', 'Immediate', '15 Lonsdale St, Melbourne', 3000, '2', NULL);
INSERT INTO JOB VALUES('4', 'Movers needed to change house', 'Immediate', '10 Batcave Aveneu, Epping', 3076, '2', NULL);
INSERT INTO JOB VALUES('5', 'Leake in the roof needs fixing', 'Immediate', '2/80 Friends Rd, Altona', 3018, '7', NULL);
INSERT INTO JOB VALUES('6', 'Roof needs a paint', 'Low', '33 Waratah St, Altona', 3018, '7', NULL);
INSERT INTO JOB VALUES('7', 'Need my house cleaned after a party', 'Normal', '3/80 Friends Rd, Altona', 3018, '1', NULL);
INSERT INTO JOB VALUES('8', 'Need a new landscape design', 'Normal', '41 Alexander Avenue, Thomastown', 3074, '3', NULL);
INSERT INTO JOB VALUES('9', 'Backyard garbage needs to be removed', 'Immediate', '2 Queens St, Melbourne', 3000, '9', NULL);
INSERT INTO JOB VALUES('10', 'Leak in the basin bottom', 'Immediate', '13 Swanston St, Melbourne', 3000, '5', NULL);
INSERT INTO JOB VALUES('11', 'Need a contractual cleaner', 'Low', '10 Southbank, Melbourne', 3000, '1', NULL);
INSERT INTO JOB VALUES('12', 'Contractual electrical wiring job', 'Immediate', '15 Southbank, Melbourne', 3000, '6', NULL);
INSERT INTO JOB VALUES('13', 'Electrician needed for 3 months period', 'Normal', '23 High St, Preston', 3072, '6', NULL);
INSERT INTO JOB VALUES('14', 'New office space extension', 'Low', '628 Victoria St, Epping', 3076, '8', NULL);
INSERT INTO JOB VALUES('15', 'Plumbing line inspection and maintenance', 'Immediate', '180 Swanston St, Melbourne', 3000, '5', NULL);
INSERT INTO JOB VALUES('16', 'New courtyard construction: Thomas Cherry Building', 'Normal', 'Plenty Road and Kingsburry Drive', 3083, '8', NULL);
INSERT INTO JOB VALUES('17', 'Structural crack repair', 'Immediate', '750 Collins St, Melbourne', 3000, '8', NULL);
INSERT INTO JOB VALUES('18', 'Carpark construction', 'Low', '105 Grimshaw St, Greensborough', 3088, '8', NULL);
INSERT INTO JOB VALUES('19', 'Commercial cleaners needed', 'Immediate', '1 Bell St, Preston', 3072, '1', NULL);
INSERT INTO JOB VALUES('20', 'Nightly stock-rubbish removal', 'Immediate', '71 May Rd, Lalor', 3075, '9', NULL);




--CONTRACT_JOB (JobID, StartDate, EndDate, CorporateClientNo)
INSERT INTO CONTRACT_JOB VALUES('11', NULL, NULL, '1');
INSERT INTO CONTRACT_JOB VALUES('12', TO_DATE('03-MAR-2020', 'DD-MON-YYYY'), TO_DATE('02-MAR-2021', 'DD-MON-YYYY'), '2');
INSERT INTO CONTRACT_JOB VALUES('13', TO_DATE('27-FEB-2020', 'DD-MON-YYYY'), TO_DATE('26-AUG-2020', 'DD-MON-YYYY'), '3');
INSERT INTO CONTRACT_JOB VALUES('14', TO_DATE('15-MAR-2020', 'DD-MON-YYYY'), TO_DATE('14-MAR-2022', 'DD-MON-YYYY'), '4');
INSERT INTO CONTRACT_JOB VALUES('15', NULL, NULL, '5');
INSERT INTO CONTRACT_JOB VALUES('16', TO_DATE('25-FEB-2015', 'DD-MON-YYYY'), TO_DATE('24-FEB-2017', 'DD-MON-YYYY'), '6');
INSERT INTO CONTRACT_JOB VALUES('17', TO_DATE('01-JAN-2018', 'DD-MON-YYYY'), TO_DATE('31-DEC-2020', 'DD-MON-YYYY'), '7');
INSERT INTO CONTRACT_JOB VALUES('18', TO_DATE('06-JUN-2018', 'DD-MON-YYYY'), TO_DATE('05-DEC-2018', 'DD-MON-YYYY'), '8');
INSERT INTO CONTRACT_JOB VALUES('19', TO_DATE('02-MAR-2019', 'DD-MON-YYYY'), TO_DATE('01-MAY-2019', 'DD-MON-YYYY'), '9');
INSERT INTO CONTRACT_JOB VALUES('20', NULL, NULL, '10');


--CASUAL_JOB (JobID, IndividualClientNo)
INSERT INTO CASUAL_JOB VALUES('1', '11');
INSERT INTO CASUAL_JOB VALUES('2', '12');
INSERT INTO CASUAL_JOB VALUES('3', '13');
INSERT INTO CASUAL_JOB VALUES('4', '14');
INSERT INTO CASUAL_JOB VALUES('5', '15');
INSERT INTO CASUAL_JOB VALUES('6', '16');
INSERT INTO CASUAL_JOB VALUES('7', '17');
INSERT INTO CASUAL_JOB VALUES('8', '18');
INSERT INTO CASUAL_JOB VALUES('9', '19');
INSERT INTO CASUAL_JOB VALUES('10', '20');


--QUOTATION (JobID, ABNNumber, QuoteAmount)
INSERT INTO QUOTATION VALUES('1', '12345678923', 100.00);
INSERT INTO QUOTATION VALUES('2', '12345678923', 80.00);
INSERT INTO QUOTATION VALUES('3', '12345678913', 300.00);
INSERT INTO QUOTATION VALUES('3', '12345678925', 280.00);
INSERT INTO QUOTATION VALUES('4', '12345678913', 250.00);
INSERT INTO QUOTATION VALUES('7', '12345678926', 100.00);
INSERT INTO QUOTATION VALUES('8', '12345678923', 400.00);
INSERT INTO QUOTATION VALUES('9', '12345678922', 150.00);
INSERT INTO QUOTATION VALUES('10', '12345678927', 700.00);
INSERT INTO QUOTATION VALUES('11', '12345678912', 3000.00);
INSERT INTO QUOTATION VALUES('12', '12345678916', 10000.00);
INSERT INTO QUOTATION VALUES('12', '12345678921', 12000.00);
INSERT INTO QUOTATION VALUES('13', '12345678916', 15000.00);
INSERT INTO QUOTATION VALUES('14', '12345678919', 7000.00);
INSERT INTO QUOTATION VALUES('14', '12345678920', 7500.00);
INSERT INTO QUOTATION VALUES('15', '12345678914', 20000.00);
INSERT INTO QUOTATION VALUES('15', '12345678915', 22500.00);
INSERT INTO QUOTATION VALUES('16', '12345678919', 12000.00);
INSERT INTO QUOTATION VALUES('16', '12345678920', 13000.00);
INSERT INTO QUOTATION VALUES('17', '12345678919', 33000.00);
INSERT INTO QUOTATION VALUES('17', '12345678920', 31500.00);
INSERT INTO QUOTATION VALUES('18', '12345678919', 7800.00);
INSERT INTO QUOTATION VALUES('19', '12345678912', 2800.00);
INSERT INTO QUOTATION VALUES('20', '12345678928', 4500.00);


--Update statemtns for Job table to hold reference to the selected businesses for each Job
UPDATE JOB SET SelectedBusinessABNNumber = '12345678923' WHERE JobID = 1;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678925' WHERE JobID = 3;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678926' WHERE JobID = 7;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678923' WHERE JobID = 8;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678927' WHERE JobID = 10;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678921' WHERE JobID = 12;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678916' WHERE JobID = 13;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678919' WHERE JobID = 14;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678914' WHERE JobID = 15;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678920' WHERE JobID = 16;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678920' WHERE JobID = 17;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678919' WHERE JobID = 18;
UPDATE JOB SET SelectedBusinessABNNumber = '12345678912' WHERE JobID = 19;


--BUSINESS_INDUSTRY (ABNNumber, IndustryID)
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678911', '4');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678912', '1');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678913', '2');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678914', '5');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678915', '5');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678916', '6');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678917', '6');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678918', '7');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678919', '8');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678920', '8');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678921', '6');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678922', '9');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678923', '4');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678924', '1');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678925', '2');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678926', '1');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678927', '5');
INSERT INTO BUSINESS_INDUSTRY VALUES('12345678928', '9');


----INVOICE (InvoiceNo, Amount, JobID)
INSERT INTO INVOICE VALUES('1', 100, '1');
INSERT INTO INVOICE VALUES('2', 280, '3');
INSERT INTO INVOICE VALUES('3', 100, '7');
INSERT INTO INVOICE VALUES('4', 400, '8');
INSERT INTO INVOICE VALUES('5', 700, '10');
INSERT INTO INVOICE VALUES('6', 1000, '12');
INSERT INTO INVOICE VALUES('7', 2000, '12');
INSERT INTO INVOICE VALUES('8', 5000, '13');
INSERT INTO INVOICE VALUES('9', 1500, '14');
INSERT INTO INVOICE VALUES('10', 2000, '15');
INSERT INTO INVOICE VALUES('11', 3000, '15');
INSERT INTO INVOICE VALUES('12', 1000, '16');
INSERT INTO INVOICE VALUES('13', 3000, '16');
INSERT INTO INVOICE VALUES('14', 4800, '17');
INSERT INTO INVOICE VALUES('15', 800, '19');


--SEMINAR (SeminarID, SeminarTitle, SeminarDateTime, SeminarVenue)
INSERT INTO SEMINAR VALUES('1', 'Career Development for Construction Workers.', TO_TIMESTAMP('12-AUG-2020 10:00', 'DD-MON-YYYY HH24:MI'), 'Convention Hall, Bundoora, 3083');
INSERT INTO SEMINAR VALUES('2', 'Ray White Career Seminar for Construction Workers', TO_TIMESTAMP('28-SEP-2020 11:00', 'DD-MON-YYYY HH24:MI'), 'Convention Hall, Bundoora, 3083');
INSERT INTO SEMINAR VALUES('3', 'Career Fair for Plumbing Workers', TO_TIMESTAMP('05-AUG-2020 14:00', 'DD-MON-YYYY HH24:MI'), 'Local Counsil Office, Epping, 3076');
INSERT INTO SEMINAR VALUES('4', 'Cleaners Counsil Seminar', TO_TIMESTAMP('15-SEP-2020 13:00', 'DD-MON-YYYY HH24:MI'), 'CLT, Melbourne Polytechnic, Preston, 3072');


--SEMINAR_ATTENDIES (EliteMemberID, SeminarID)
INSERT INTO SEMINAR_ATTENDIES VALUES('12','1');
INSERT INTO SEMINAR_ATTENDIES VALUES('12','2');
INSERT INTO SEMINAR_ATTENDIES VALUES('11','3');
INSERT INTO SEMINAR_ATTENDIES VALUES('6','3');
INSERT INTO SEMINAR_ATTENDIES VALUES('5','4');
INSERT INTO SEMINAR_ATTENDIES VALUES('13','4');
INSERT INTO SEMINAR_ATTENDIES VALUES('8','4');


commit;