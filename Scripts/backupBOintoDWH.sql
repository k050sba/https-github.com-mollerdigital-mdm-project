	DECLARE @boTableList CURSOR;
	DECLARE @tbl varchar(100);
	DECLARE @backup_table varchar(100);
BEGIN
	SET NOCOUNT ON;

    SET @boTableList = CURSOR FOR
    select table_name from mdm_cm..C_REPOS_TABLE where TYPE_IND=1 and TABLE_NAME not like 'C_RBO%'

    OPEN @boTableList 
    FETCH NEXT FROM @boTableList 
    INTO @tbl

	WHILE @@FETCH_STATUS = 0
    BEGIN
	print(@tbl)
		IF EXISTS(SELECT TABLE_NAME,TABLE_TYPE
			FROM MDM_DWH.INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME=@tbl)
		BEGIN
			EXEC('drop table MDM_DWH..' +  @tbl)
			print 'drop'
			print  @tbl
		END;
		SET @backup_table=concat('MDM_DWH..',@tbl)
		print @backup_table
		EXEC('SELECT * INTO ' + @backup_table + ' from mdm_cm..' + @tbl)
		print('SELECT * INTO ' + @backup_table + ' from mdm_cm..' + @tbl)
		FETCH NEXT FROM @boTableList 
		INTO @tbl
	END;
END