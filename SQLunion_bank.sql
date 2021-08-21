
-- created a data base with the  name union_bank

-- creating schemas borrower and loan 

create schema borrower;

create schema loan
;

--creating table for borrower 

create table borrower.borrower
(
 borrowerID              int            not null,
 borrowermiddleinitial   char(1)        not null,
 borrowerlastname        nvarchar(255)  not null,
 Dob                     datetime       not null,
 gender                  char(1)        null,
 taxpayerid_ssn          varchar(255)   not null,
 phonenumber             varchar(10)    not null,
 email                   varchar(255)   not null,
 citizenship             varchar(255)   null,
 beneficiaryname         varchar(255)   null,
 isuscitizen             bit            null,
 createdate              datetime       not null
 );


--creating table borroweraddress under the borrower schema

 create table borrower.borroweraddress
 (
  addressid     int          not null,
  borrowerid    int          not null,
  streetaddress varchar(255) not null,
  zip           varchar(5)   not null,
  createdate    datetime     not null
  );


--creating table calender under the dbo(default)schema

 create table calender 
 (
 calenderdate    datetime   null);

 --creating table state  under the dbo(default)schema

 create table [state]
 (
 stateid      char(2)       not null,
 statename    varchar(255)  not null,
 createdate   datetime);

--creating table us_zipcodes  under the dbo(default)schema

 create table US_zipcodes
 (
 IsSurrogatekey    datetime     not null,
 zip               varchar(5)   not null,
 latitude          float        null,
 longitude         float        null,
 city              varchar(255) null,
 state_id          char(5)      null,
 populationtotal   int          null,
 density           decimal(18)  null,
 county_fips       varchar(10)  null,
 county_name       varchar(255) null,
 county_name_all   varchar(255) null,
 county_fip_all    varchar(50)  null,
 timezone          varchar(255) null,
 createdate        datetime     not  null);


 --creating table loansetupinformation under schema loan
 
 create table loan.loansetupinformation
 (
 IsSurrogatekey				int					not null,
 loanNumber					varchar				not null,
 purchaseamount				numeric(18,2)		not null,
 purchasedate				datetime			not null,
 loanterm					int					not null,
 borrowerid					int					not null,
 underwriterid				int					not null,
 productid					char(2)				not null,
 interestRate				decimal(3,2)		not null,
 paymentFrequency			int					not null,
 appraisalValue				numeric(18,2)		not null,
 createDate					datetime			not null,
 ltv						decimal(4,2)		not null,
 firstInterestPaymentDate	datetime			null,
 maturityDate				datetime			not null);

 
 --creating table loan periodic under table loan 

 create table loan.loanperiodic
 (
 IsSurrogatekey					int						not null,
 loanNumber						varchar					not null,
 cycleDate						datetime				not null,
 extraMonthlyPayment			numeric(18,2)			not null,
 Unpaidprincipalbalance			numeric(18,2)			not null,
 Beginningschedulebalance		numeric(18,2)			not null,
 paidinstallment				numeric(18,2)			not null,
 interestportion				numeric(18,2)			not null,
 principalportion				numeric(18,2)			not null,
 EndscheduleBalance				numeric(18,2)			not null,
 Actualendschedulebalance		numeric(18,2)			not null,
 Totalinterestaccrued			numeric(18,2)			not null,
 Totalprincipalaccrued			numeric(18,2)			not null,
 DEFAULTPENALTY					numeric(18,2)			not null,
 delinquencycode				int						not null,
 createdate						numeric(18,2)			not null);


 --creating table LU_delinquency under schema loan

 create table loan.LU_deliquency
 (
 Delinquencycode					int				not null,
 delinquency						varchar(255)	not null,
 paymentfrequency					int				not null,
 paymentismadeEvery					int				not null,
 paymentfrequency_Description		varchar(255)	not null);


 --creating table underwriter under schema loan

  create table loan.underwriter
  (
  underwriterID					int					not null,
  underwriterfirstname			varchar(255)		null,
  underwritermiddleinitial		char(1)				null,
  underwriterlastname			varchar(255)		not null,
  phonenumber					varchar(14)			null,
  email							varchar(255)		not null,
  createdate					datetime			not null);



    create table loan.lu_paymentfrequency
   (
   paymentfrequency                int					not null,
   paymentismadevery               int					not null,
   paymentfrequency_description    varchar(255)			 not null);


---Creating business rules that enhance the tables.
--1) --esuring all borrowers are at least 18 as of the date of entry

 ALTER TABLE BORROWER.BORROWER
 ADD CONSTRAINT CHK_BORROWER_DOB CHECK (DOB=DATEADD(YEAR, +18, GETDATE()));
 

 --2) --ensuring the email contains @ symbolin the inserted value 
  ALTER TABLE BORROWER.BORROWER
 ADD CONSTRAINT CHK_BORROWER_EMAIL CHECK(EMAIL LIKE '% @ %');

-- 3) --ensuring the phone number entered is 10 digit,no less no more 

 ALTER TABLE BORROWER.BORROWER
 ADD CONSTRAINT CHK_BORROWER_PHONENUMBER CHECK (LEN(PHONENUMBER)=10);

-- 4)--ensuring the ssn entered is 9 digit no more no less

 ALTER TABLE BORROWER.BORROWER
 ADD CONSTRAINT CHK_BORROWER_TAXPATERID_SSN CHECK(LEN(TAXPAYERID_SSN)=9);


--5)--assigning a date to the createdate column

 ALTER TABLE BORROWER.BORROWER
 ADD CONSTRAINT DF_BORROWER_CREATEDATE DEFAULT(GETDATE())FOR CREATEDATE;

-- 6)-- adding a unique constraint to borrowerid

 ALTER TABLE BORROWER.BORROWER
 ADD CONSTRAINT UNQ_BORROWER_BORROWERID UNIQUE(BORROWERID);


 --business rule continues on borroweraddress table
--1) --assigning date to createdate column 

 ALTER TABLE BORROWER.BORROWERADDRESS
 ADD CONSTRAINT DF_BORROWERADDRESS_CREATEDATE DEFAULT(GETDATE())FOR CREATEDATE;
 
--2) --creating relatioin between borrower table and borroweraddress table

 ALTER TABLE BORROWER.BORROWERADDRESS
 ADD CONSTRAINT FK_BORROWERADDRESS_BORROWERID FOREIGN KEY(BORROWERID) REFERENCES BORROWER.BORROWER(BORROWERID);


--3)--creating relatioin between borrower table and borroweraddress table
 
 ALTER TABLE DBO.US_ZIPCODES
 ADD CONSTRAINT PK_US_ZIPCODES_ZIP PRIMARY KEY(ZIP);



 ALTER TABLE BORROWER.BORROWERADDRESS
 ADD CONSTRAINT FK_BORROWERADDRESS_ZIP FOREIGN KEY(ZIP) REFERENCES DBO.US_ZIPCODES(ZIP);


-- 4)--uniquely idenftifying a record on this on this table
 

 ALTER TABLE BORROWER.BORROWERADDRESS
 ADD CONSTRAINT CMPK_BORRWERADDRESS_ADDRESSID_BORROWERID PRIMARY KEY(ADDRESSID,BORROWERID);

--5) --leveraging a check constraint 
  
  ALTER TABLE LOAN.LOANPERIODIC
  ADD CONSTRAINT CHK_PERIODIC_INTERESTPORTION_PRINCIPALPORTION_PAIDINSTALLMENT CHECK (INTERESTPORTION +  PRINCIPALPORTION=PAIDINSTALLMENT); 

--6)  
  ALTER TABLE LOAN.LOANPERIODIC
  ADD CONSTRAINT DF_LOANPERIODIC_CREATEDATE DEFAULT(GETDATE())FOR CREATEDATE;

-- i got an error after running this because the datatype in the table is numeric and not datetime.
-- I altered the table and modify the data type.

 ALTER TABLE LOAN.LOANPERIODIC
 ALTER COLUMN CREATEDATE DATETIME;


--7) --setting extramonthly payment to default 

 ALTER TABLE LOAN.LOANPERIODIC
 ADD CONSTRAINT DF_LOANPERIODIC_EXTRAMONTHLYPAYMENT DEFAULT(EXTRAMONTHLYPAYMENT);



--8) --creating relationship between loannumber in loanperiodic and loansetupinformation
   
 ALTER TABLE LOAN.LOANPERIODIC
 ADD CONSTRAINT FK_LOANPERIODIC_LOANNUMBER FOREIGN KEY(LOANNUMBER) REFERENCES LOAN.LOANSETUPINFORMATION(LOANNUMBER);

 --given that laonnumber is a primary key in loanperiodic table.


--9) --creating a relationship between loanperiodic and lu_delinquency table where delinquncy code is foreign key 
  --i'm gonna make delinquencycode in the lu_delinquency a primary key to create a relationship with the foreign key.

  ALTER TABLE LOAN.LU_DELIQUENCY
  ADD CONSTRAINT PK_LU_DELINQUENCY_DELINQUENCYCODE PRIMARY KEY(DELINQUENCYCODE);

  ALTER TABLE LOAN.LOANPERIODIC
  ADD CONSTRAINT PK_LOANPERIODIC_DELINQUENCYCODE FOREIGN KEY(DELINQUENCYCODE)REFERENCES LOAN.LU_DELIQUENCY(DELINQUENCYCODE);

--10) --making two column uniquely identify a record in a table using a composite key

  ALTER TABLE LOAN.LOANPERIODIC
  ADD CONSTRAINT CMP_LOANPERIODIC_LOANNUMBER_CYCLEDATE PRIMARY KEY(LOANNUMBER,CYCLEDATE);
 
 --this gave error at firts because the rquirement dint specify what schema so i checked the schema that has loannumber and cycledate it and ran oit again.


--11)--using check constraint to specify the values this column can  only take 


 ALTER TABLE LOAN.LOANSETUPINFORMATION
 ADD CONSTRAINT CHK_LOANSETUPINFORMATION_LOANTERM CHECK (LOANTERM IN( 35,30,15,10)); 


--12) ---adding interest rate 
  
  ALTER TABLE LOAN.LOANSETUPINFORMATION
  ADD CONSTRAINT CHK_LOANSETUPINFORMATION_INTERESTRATE CHECK(INTERESTRATE BETWEEN 0.01 AND 0.30);

--13) --creating a defualt date 
  
  ALTER TABLE LOAN.LOANSETUPINFORMATION
  ADD CONSTRAINT DF_LOANSETUPINFORMATION_CREATEDATE DEFAULT(GETDATE())FOR CREATEDATE;



--14) --establishing reationship between borrower and loansetupinformation table

  ALTER TABLE BORROWER.BORROWER
  ADD CONSTRAINT PK_BORROWER_BORROWERID PRIMARY KEY(BORROWERID);

  ALTER TABLE LOAN.LOANSETUPINFORMATION
  ADD CONSTRAINT PK_LOANSETUPINFORMATION_BORROWERID FOREIGN KEY(BORROWERID)REFERENCES BORROWER.BORROWER(BORROWERID);

 
--15)--establishing relatoinship between loansetupinformation and lu_paymentfrequency table 

  ALTER TABLE LOAN.LU_PAYMENTFREQUENCY
  ADD CONSTRAINT PK_LU_PAYMENTFREQUENCY_PAYMENTFREQUENCY PRIMARY KEY(PAYMENTFREQUENCY);

  ALTER TABLE LOAN.LOANSETUPINFORMATION
  ADD CONSTRAINT FK_LOANSETUPINFORMATION_PAYMENTFREQUENCY FOREIGN KEY(PAYMENTFREQUENCY)REFERENCES LOAN.LU_PAYMENTFREQUENCY(PAYMENTFREQUENCY);


-- 16) --establishing relatoinship between loansetupinformation and underwriterid table 

   ALTER TABLE LOAN.UNDERWRITER 
   ADD CONSTRAINT PK_UNDERWRITER_UNDERWRITERID PRIMARY KEY(UNDERWRITERID);

   ALTER TABLE LOAN.LOANSETUPINFORMATION
   ADD CONSTRAINT FK_LOANSETUPINFORMATION_UNDERWRITERID FOREIGN KEY(UNDERWRITERID)REFERENCES LOAN.UNDERWRITER(UNDERWRITERID);


-- 17)  ---making column loannumber the unique identifier 
    
	ALTER TABLE LOAN.LOANSETUPINFORMATION
    ADD CONSTRAINT PK_LOANSETUPINFORMATION_LOANNUMBER PRIMARY KEY(LOANNUMBER);

  ALTER TABLE LOAN.LOANSETUPINFORMATION
  DROP CONSTRAINT UNQ_LOANSETUPINFORMATION_LOANNUMBER;

--18)---making column loannumber the unique identifier 

  
  ALTER TABLE LOAN.LU_DELIQUENCY
  ADD CONSTRAINT PK_DELIQUENCY_DELINQUENCYCODE PRIMARY KEY(DELINQUENCYCODE);
   
   ALTER TABLE LOAN.LU_DELIQUENCY
   DROP CONSTRAINT UNQ_DELIQUENCY_DELINQUENCYCODE;



--19)--making column paymentfrequency the unique identifier


  ALTER TABLE LOAN.LU_PAYMENTFREQUENCY
  ADD CONSTRAINT UNQ_LU_PAYMENTFREQUENCY_PAYMENTFREQUENCY UNIQUE(PAYMENTFREQUENCY);


 --20)--assigning date to creatdate 


  ALTER TABLE DBO.[STATE]
  ADD CONSTRAINT DEF_STATE_CREATEDATE DEFAULT(GETDATE()) FOR CREATEDATE; 


--21)-- making column stateid the unique identifier
  

  ALTER TABLE DBO.[STATE]
  ADD CONSTRAINT UNQ_STATE_STATEID UNIQUE(STATEID);

 --22) ---adding unique constraint 
    ALTER TABLE DBO.[STATE]
    ADD CONSTRAINT UNQ_STATE_STATENAME UNIQUE(statename);


 23) --ensuing the email contains the symbol @

   ALTER TABLE LOAN.UNDERWRITER
   ADD CONSTRAINT CHK_UNDERWRITER_EMAIL CHECK(EMAIL LIKE '% @ %');


--24)--assigning date 
  ALTER TABLE LOAN.UNDERWRITER
  ADD CONSTRAINT DEF_UNDERWRITER_CREATEDATE DEFAULT(GETDATE())FOR CREATEDATE;

 --25) --- making underwriterid the unique identifier


  ALTER TABLE LOAN.UNDERWRITER
  ADD CONSTRAINT PK_UNDERWRITER_UNDERWRITERID PRIMARY KEY(UNDERWRITERID);
  
--26)--assiging date 
  ALTER TABLE DBO.US_ZIPCODES
  ADD CONSTRAINT DEF_US_ZIPCODES_CREATEDATE DEFAULT(GETDATE())FOR CREATEDATE;

--27- establishing relationship betweeen us_zipcodes and underwriter
  ALTER TABLE DBO.US_ZIPCODES
  ADD CONSTRAINT FK_US_ZIPCODES_STATE_ID FOREIGN KEY(STATE_ID)REFERENCES LOAN.UNDERWRITER(UNDERWRITERID);  

--- gave error so i had change the datatype and ran it again.

  ALTER TABLE DBO.US_ZIPCODES
  ALTER COLUMN STATE_ID INT;






  