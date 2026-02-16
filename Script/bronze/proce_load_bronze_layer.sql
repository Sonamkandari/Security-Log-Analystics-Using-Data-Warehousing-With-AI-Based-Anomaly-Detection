
use SecurityLogsDW;
go
CREATE OR ALTER PROCEDURE bronze.usp_load_login_attempts
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        PRINT '=========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=========================================';

        PRINT '-----------------------------------------';
        PRINT 'Loading login_attempts table';
        PRINT '-----------------------------------------';

        PRINT '>> Truncating table: bronze.login_attempts';
        TRUNCATE TABLE bronze.login_attempts;

        PRINT '>> Inserting data into: bronze.login_attempts';
        BULK INSERT bronze.login_attempts
        FROM 'C:\data\rba-dataset.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            DATAFILETYPE = 'char',
            CODEPAGE = '65001',
            TABLOCK
        );

        PRINT '-----------------------------------------';
        PRINT 'Loading intrution_events table';
        PRINT '-----------------------------------------';

        PRINT '>> Truncating table: bronze.intrution_events';
        TRUNCATE TABLE bronze.intrusion_events;

        PRINT '>> Inserting data into: bronze.intrution_events';
        BULK INSERT bronze.intrusion_events
        FROM 'C:\data\cybersecurity_intrusion_data.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            DATAFILETYPE = 'char',
            CODEPAGE = '65001',
            TABLOCK
        );




        PRINT 'Load completed successfully';
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while loading bronze.login_attempts';
        PRINT ERROR_MESSAGE();
        THROW;
    END CATCH
END
GO



TRUNCATE TABLE bronze.login_attempts;
EXEC bronze.usp_load_login_attempts;


SELECT COUNT(*) FROM bronze.login_attempts;

Select * from  bronze.login_attempts;
Select * from bronze.intrusion_events;
