/*  a. List all the clients and their assiciated total job expenses. If there is a client who did not post any job, 
or no invoice was generated for the posted jobs, the total expense should appear as zero for that client. 
Your query should list the details in three columns, 'Client Number', 'Client Name', 'Total Job Expense'. 
(Hint: the invoice table lists the expenses for the jobs). */

SELECT cl.CLIENTNO AS "Client Number", CLIENTNAME AS "Client Name",
    CASE 
        WHEN INVOICENO IS NULL OR AMOUNT IS NULL THEN 0 
        ELSE AMOUNT
    END AS "Total Job Expense"
    FROM CLIENT cl
    LEFT JOIN INDIVIDUAL_CLIENT ic ON cl.CLIENTNO = ic.CLIENTNO
    LEFT JOIN CASUAL_JOB cas ON ic.CLIENTNO = cas.INDIVIDUALCLIENTNO
    LEFT JOIN JOB ON cas.JOBID = JOB.JOBID
    LEFT JOIN CORPORATE_CLIENT cc ON cl.CLIENTNO = cc.CLIENTNO
    LEFT JOIN CONTRACT_JOB con ON cc.CLIENTNO = con.CORPORATECLIENTNO
    LEFT JOIN JOB ON con.JOBID = JOB.JOBID
    LEFT JOIN INVOICE ON JOB.JOBID = INVOICE.JOBID;

 /*   List the seminar titles, and date on which they were held, along with the number of participants, 
for the seminars arranged during the afternoon part of the day (between 12 PM and 3 PM). 
Count 1 participation for each elite member even if the elite member is a trade union. 
*/

   
SELECT SEMINARTITLE "Seminar Title", SEMINARDATETIME AS "Date Held", SUM("Participants")AS "Number of participants"
    FROM    (   -- Business As a member
                SELECT SEMINARTITLE, SEMINARDATETIME,  COUNT(*) AS "Participants" FROM SEMINAR
                LEFT JOIN SEMINAR_ATTENDIES ON SEMINAR.SEMINARID = SEMINAR_ATTENDIES.SEMINARID
                LEFT JOIN ELITE_MEMBER ON SEMINAR_ATTENDIES.ELITEMEMBERID = ELITE_MEMBER.ELITEMEMBERID
                INNER JOIN FREELANCER_BUSINESS ON ELITE_MEMBER.ELITEMEMBERID = FREELANCER_BUSINESS.ELITEMEMBERID
                WHERE EXTRACT(HOUR FROM SEMINARDATETIME) BETWEEN 12 AND 15
                GROUP BY SEMINARTITLE, SEMINARDATETIME
                
                UNION ALL
                
                -- Trade Union As a member
                SELECT SEMINARTITLE, SEMINARDATETIME, COUNT(*) AS "Participants" FROM SEMINAR SR
                LEFT JOIN SEMINAR_ATTENDIES SR_A ON SR.SEMINARID = SR_A.SEMINARID
                LEFT JOIN ELITE_MEMBER EM ON SR_A.ELITEMEMBERID = EM.ELITEMEMBERID
                INNER JOIN TRADE_UNION TRD ON EM.ELITEMEMBERID = TRD.ELITEMEMBERID
                WHERE EXTRACT(HOUR FROM SEMINARDATETIME) BETWEEN 12 AND 15
                GROUP BY SEMINARTITLE, SEMINARDATETIME
            )
    GROUP BY SEMINARTITLE, SEMINARDATETIME;
