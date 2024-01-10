USE MDM_CM;

TRUNCATE TABLE MDM_CUSTOM..REPUSH_MERGE_DAILY;

-- Select all merges from last day.
INSERT INTO
   MDM_CUSTOM..REPUSH_MERGE_DAILY 
   SELECT DISTINCT
      B.ORIG_ROWID_OBJECT,
      C.ROWID_OBJECT,
      C.TYPE,
      C.COUNTRY_CODE 
   FROM
      C_B_PARTY_HMRG A 
      INNER JOIN
         C_B_PARTY_XREF B 
         ON A.SRC_ROWID_OBJECT = B.ORIG_ROWID_OBJECT 
      INNER JOIN
         C_B_PARTY C 
         ON (B.ROWID_OBJECT = C.ROWID_OBJECT 
         AND C.HUB_STATE_IND = '1' 
         AND C.TYPE IN 
         (
            'P',
            'O'
         )
         AND C.COUNTRY_CODE IS NOT NULL ) 
   WHERE
      MERGE_DATE > GETDATE() - 1 
      AND UNMERGE_DATE IS NULL 
   ORDER BY
      C.ROWID_OBJECT;
	  

	  
-- Select all merges where losing party still in MNET and insert in Merge Re-push Hist table.
INSERT INTO MDM_CUSTOM..REPUSH_MERGE_DAILY_HIST
SELECT
   *,'0',NULL 
FROM
   MDM_CUSTOM..REPUSH_MERGE_DAILY C 
WHERE
   C.COUNTRY_CODE = 'NO' 
   AND EXISTS 
   (
      SELECT
         1 
      FROM
         MNET_COPY..TKB006 T6 
      WHERE
         EXISTS 
         (
            SELECT
               1 
            FROM
               MNET_COPY..TKB001 T1 
            WHERE
               T6.FELLESID = T1.FELLESID
         )
         AND C.ORIG_ROWID_OBJECT = T6.PARTYID
   )
UNION
SELECT
   *,'0',NULL
FROM
   MDM_CUSTOM..REPUSH_MERGE_DAILY C 
WHERE
   C.COUNTRY_CODE = 'EE' 
   AND EXISTS 
   (
      SELECT
         1 
      FROM
         MNET_COPY..TKB006_ES T6 
      WHERE
         EXISTS 
         (
            SELECT
               1 
            FROM
               MNET_COPY..TKB001_ES T1 
            WHERE
               T6.FELLESID = T1.FELLESID
         )
         AND C.ORIG_ROWID_OBJECT = T6.PARTYID
   )
UNION
SELECT
   *,'0',NULL 
FROM
   MDM_CUSTOM..REPUSH_MERGE_DAILY C 
WHERE
   C.COUNTRY_CODE = 'LV' 
   AND EXISTS 
   (
      SELECT
         1 
      FROM
         MNET_COPY..TKB006_LA T6 
      WHERE
         EXISTS 
         (
            SELECT
               1 
            FROM
               MNET_COPY..TKB001_LA T1 
            WHERE
               T6.FELLESID = T1.FELLESID
         )
         AND C.ORIG_ROWID_OBJECT = T6.PARTYID
   )
UNION
SELECT
   *,'0',NULL
FROM
   MDM_CUSTOM..REPUSH_MERGE_DAILY C 
WHERE
   C.COUNTRY_CODE = 'LT' 
   AND EXISTS 
   (
      SELECT
         1 
      FROM
         MNET_COPY..TKB006_LI T6 
      WHERE
         EXISTS 
         (
            SELECT
               1 
            FROM
               MNET_COPY..TKB001_LI T1 
            WHERE
               T6.FELLESID = T1.FELLESID
         )
         AND C.ORIG_ROWID_OBJECT = T6.PARTYID
   )
 ;
 
 
 -- Re-push Merge message.
 
update top(500) MDM_CUSTOM..REPUSH_MERGE_DAILY_HIST
set Processed='2'
where Processed='0';

insert into
   C_REPOS_MQ_DATA_CHANGE(ROWID_MQ_DATA_CHANGE, ROWID_MQ_RULE, ROWID_TABLE, ROWID_OBJECT, SENT_STATE_ID, CREATOR, CREATE_DATE, UPDATED_BY, LAST_UPDATE_DATE, CHANGE_TYPE, PKEY_SRC_OBJECT, SRC_ROWID_SYSTEM, SRC_PKEY_SRC_OBJECT, TGT_ROWID_SYSTEM, MERGE_SRC_ROWID_OBJECT) 
   select
      NEXT VALUE FOR MDM_Custom..ROWID_MQ_DATA_CHANGE AS ROWID_MQ_DATA_CHANGE,
      (
         select
            ROWID_MQ_RULE 
         from
            C_REPOS_MQ_RULE 
         where
            ROWID_TABLE = 'SVR1.1NNK     ' 
            and RULE_NAME = 'Delta on Party'
      )
,
      'SVR1.1NNK     ',
      ROWID_OBJECT,
      '0',
      'admin',
      CURRENT_TIMESTAMP,
      'CMX',
      CURRENT_TIMESTAMP,
      '4',
      CONCAT('MDM|', RTRIM(ROWID_OBJECT)),
      'MDM',
      CONCAT('MDM|', RTRIM(ROWID_OBJECT)),
      'MDM',
      ORIG_ROWID_OBJECT 
   from
     MDM_CUstom..REPUSH_MERGE_DAILY_HIST
    where
            Processed = '2'
     ;
 
 
update MDM_CUSTOM..REPUSH_MERGE_DAILY_HIST
set Processed='1',processed_date=CURRENT_TIMESTAMP
where Processed='2';