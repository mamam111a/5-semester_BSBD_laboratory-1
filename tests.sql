SET ROLE app_reader;
DO $$
BEGIN
    RAISE NOTICE '== ПРОВЕРКА РОЛИ app_reader ==';
BEGIN
    PERFORM * FROM app.Employee LIMIT 1;
    RAISE NOTICE '✅ SELECT app.Employee: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ SELECT app.Employee: нет прав';
END;

BEGIN
    INSERT INTO app.Employee (first_name, last_name, phone_number, email, post, hire_date, fire_station_id)
    VALUES ('Test', 'Reader', '000', 'reader@test', 'None', CURRENT_DATE, 1);
    RAISE NOTICE '✅ INSERT app.Employee: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ INSERT app.Employee: нет прав';
END;

BEGIN
    UPDATE app.Employee SET first_name = 'Updated' WHERE id = 1;
    RAISE NOTICE '✅ UPDATE app.Employee: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ UPDATE app.Employee: нет прав';
END;

BEGIN
    DELETE FROM app.Employee WHERE id = 1;
    RAISE NOTICE '✅ DELETE app.Employee: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ DELETE app.Employee: нет прав';
END;

BEGIN
    PERFORM * FROM ref.IncidentType LIMIT 1;
    RAISE NOTICE '✅ SELECT ref.IncidentType: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ SELECT ref.IncidentType: нет прав';
END;

BEGIN
    INSERT INTO ref.IncidentType (name, description)
    VALUES ('TestIncident', 'Test description');
    RAISE NOTICE '✅ INSERT ref.IncidentType: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ INSERT ref.IncidentType: нет прав';
END;
BEGIN
    PERFORM * FROM audit.EventLog LIMIT 1;
    RAISE NOTICE '✅ SELECT audit.EventLog: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ SELECT audit.EventLog: нет прав';
END;

BEGIN
    INSERT INTO audit.EventLog (actor_id, target_table, target_id, action, details)
    VALUES (1, 'app.Employee', 1, 'INSERT', 'Test audit insert');
    RAISE NOTICE '✅ INSERT audit.EventLog: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ INSERT audit.EventLog: нет прав';
END;

END $$;

RESET ROLE;



SET ROLE app_writer;

DO $$
BEGIN
    RAISE NOTICE '== ПРОВЕРКА РОЛИ app_writer ==';

    BEGIN
        PERFORM * FROM app.Employee LIMIT 1;
        RAISE NOTICE '✅ SELECT app.Employee: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ SELECT app.Employee: нет прав';
    END;

    BEGIN
        INSERT INTO app.Employee (first_name, last_name, phone_number, email, post, hire_date, fire_station_id)
        VALUES ('Test', 'Writer', '111', 'writer@test', 'Tester', CURRENT_DATE, 1);
        RAISE NOTICE '✅ INSERT app.Employee: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ INSERT app.Employee: нет прав';
    END;

    BEGIN
        UPDATE app.Employee SET first_name = 'Changed' WHERE id = 1;
        RAISE NOTICE '✅ UPDATE app.Employee: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ UPDATE app.Employee: нет прав';
    END;

    BEGIN
        DELETE FROM app.Employee WHERE id = 1;
        RAISE NOTICE '✅ DELETE app.Employee: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ DELETE app.Employee: нет прав';
    END;

    BEGIN
        PERFORM * FROM ref.IncidentType LIMIT 1;
        RAISE NOTICE '✅ SELECT ref.IncidentType: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ SELECT ref.IncidentType: нет прав';
    END;

    BEGIN
        INSERT INTO ref.IncidentType (name, description)
        VALUES ('WriterIncident', 'Writer test');
        RAISE NOTICE '✅ INSERT ref.IncidentType: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ INSERT ref.IncidentType: нет прав';
    END;

    BEGIN
        UPDATE ref.IncidentType SET description = 'Updated' WHERE id = 1;
        RAISE NOTICE '✅ UPDATE ref.IncidentType: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ UPDATE ref.IncidentType: нет прав';
    END;

    BEGIN
        DELETE FROM ref.IncidentType WHERE id = 1;
        RAISE NOTICE '✅ DELETE ref.IncidentType: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ DELETE ref.IncidentType: нет прав';
    END;

    BEGIN
        PERFORM * FROM audit.EventLog LIMIT 1;
        RAISE NOTICE '✅ SELECT audit.EventLog: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ SELECT audit.EventLog: нет прав';
    END;

    BEGIN
        INSERT INTO audit.EventLog (actor_id, target_table, target_id, action, details)
        VALUES (1, 'app.Employee', 1, 'INSERT', 'Writer test');
        RAISE NOTICE '✅ INSERT audit.EventLog: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ INSERT audit.EventLog: нет прав';
    END;

END $$;

RESET ROLE;





SET ROLE app_owner;

DO $$
BEGIN
    RAISE NOTICE '== ПРОВЕРКА РОЛИ app_owner ==';

    BEGIN
        PERFORM * FROM app.Employee LIMIT 1;
        RAISE NOTICE '✅ SELECT app.Employee: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ SELECT app.Employee: нет прав';
    END;

    BEGIN
        INSERT INTO app.Employee (first_name, last_name, phone_number, email, post, hire_date, fire_station_id)
        VALUES ('Test', 'Owner', '111', 'owner@test', 'Tester', CURRENT_DATE, 1);
        RAISE NOTICE '✅ INSERT app.Employee: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ INSERT app.Employee: нет прав';
    END;

    BEGIN
        UPDATE app.Employee SET first_name = 'ChangedOwner' WHERE id = 1;
        RAISE NOTICE '✅ UPDATE app.Employee: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ UPDATE app.Employee: нет прав';
    END;

    BEGIN
        DELETE FROM app.Employee WHERE first_name = 'Test';
        RAISE NOTICE '✅ DELETE app.Employee: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ DELETE app.Employee: нет прав';
    END;

    BEGIN
        PERFORM * FROM app.Equipment LIMIT 1;
        RAISE NOTICE '✅ SELECT app.Equipment: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ SELECT app.Equipment: нет прав';
    END;

    BEGIN
        INSERT INTO app.Equipment (name, type, status, last_maintenance, fire_station_id)
        VALUES ('EquipmentOwner', 'Type', 'Не используется', CURRENT_DATE, 1);
        RAISE NOTICE '✅ INSERT app.Equipment: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ INSERT app.Equipment: нет прав';
    END;

    BEGIN
        UPDATE app.Equipment SET status = 'Используется' WHERE id = 1;
        RAISE NOTICE '✅ UPDATE app.Equipment: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ UPDATE app.Equipment: нет прав';
    END;

    BEGIN
        DELETE FROM app.Equipment WHERE name = 'EquipmentOwner';
        RAISE NOTICE '✅ DELETE app.Equipment: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ DELETE app.Equipment: нет прав';
    END;

    BEGIN
        PERFORM * FROM ref.IncidentType LIMIT 1;
        RAISE NOTICE '✅ SELECT ref.IncidentType: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ SELECT ref.IncidentType: нет прав';
    END;

    BEGIN
        INSERT INTO ref.IncidentType (name, description)
        VALUES ('OwnerIncident', 'Owner test');
        RAISE NOTICE '✅ INSERT ref.IncidentType: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ INSERT ref.IncidentType: нет прав';
    END;

    BEGIN
        UPDATE ref.IncidentType SET description = 'UpdatedOwner' WHERE id = 1;
        RAISE NOTICE '✅ UPDATE ref.IncidentType: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ UPDATE ref.IncidentType: нет прав';
    END;

    BEGIN
        DELETE FROM ref.IncidentType WHERE name = 'OwnerIncident';
        RAISE NOTICE '✅ DELETE ref.IncidentType: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ DELETE ref.IncidentType: нет прав';
    END;

    BEGIN
        PERFORM * FROM audit.EventLog LIMIT 1;
        RAISE NOTICE '✅ SELECT audit.EventLog: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ SELECT audit.EventLog: нет прав';
    END;

    BEGIN
        INSERT INTO audit.EventLog (actor_id, target_table, target_id, action, details)
        VALUES (1, 'app.Employee', 1, 'INSERT', 'Owner test');
        RAISE NOTICE '✅ INSERT audit.EventLog: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ INSERT audit.EventLog: нет прав';
    END;

END $$;

RESET ROLE;





SET ROLE auditor;

DO $$
BEGIN

RAISE NOTICE '== ПРОВЕРКА РОЛИ auditor ==';

BEGIN
    PERFORM * FROM audit.EventLog LIMIT 1;
    RAISE NOTICE '✅ SELECT audit.EventLog: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ SELECT audit.EventLog: нет прав';
END;

BEGIN
    INSERT INTO audit.EventLog (actor_id, target_table, target_id, action, details)
    VALUES (1, 'app.Employee', 1, 'TestAction', 'TestDetails');
    RAISE NOTICE '✅ INSERT audit.EventLog: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ INSERT audit.EventLog: нет прав';
END;

BEGIN
    UPDATE audit.EventLog SET details = 'Changed' WHERE id = 1;
    RAISE NOTICE '✅ UPDATE audit.EventLog: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ UPDATE audit.EventLog: нет прав';
END;

BEGIN
    DELETE FROM audit.EventLog WHERE id = 1;
    RAISE NOTICE '✅ DELETE audit.EventLog: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ DELETE audit.EventLog: нет прав';
END;
END $$;
RESET ROLE;





SET ROLE ddl_admin;
DO $$
BEGIN
RAISE NOTICE '== ПРОВЕРКА РОЛИ ddl_admin ==';
BEGIN
    CREATE TABLE app.test_ddl_admin (
        id SERIAL PRIMARY KEY,
        name VARCHAR(50)
    );
    RAISE NOTICE '✅ CREATE TABLE: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ CREATE TABLE: нет прав';
END;

BEGIN
    ALTER TABLE app.test_ddl_admin ADD COLUMN description VARCHAR(100);
    RAISE NOTICE '✅ ALTER TABLE: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ ALTER TABLE: нет прав';
END;

BEGIN
    DROP TABLE app.test_ddl_admin;
    RAISE NOTICE '✅ DROP TABLE: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ DROP TABLE: нет прав';
END;

BEGIN
    CREATE SEQUENCE app.seq_ddl_admin;
    RAISE NOTICE '✅ CREATE SEQUENCE: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ CREATE SEQUENCE: нет прав';
END;

BEGIN
    ALTER SEQUENCE app.seq_ddl_admin RESTART WITH 10;
    RAISE NOTICE '✅ ALTER SEQUENCE: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ ALTER SEQUENCE: нет прав';
END;

BEGIN
    DROP SEQUENCE app.seq_ddl_admin;
    RAISE NOTICE '✅ DROP SEQUENCE: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ DROP SEQUENCE: нет прав';
END;

BEGIN
    CREATE SCHEMA test_schema_ddl;
    RAISE NOTICE '✅ CREATE SCHEMA: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ CREATE SCHEMA: нет прав';
END;

BEGIN
    DROP SCHEMA test_schema_ddl;
    RAISE NOTICE '✅ DROP SCHEMA: OK';
EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ DROP SCHEMA: нет прав';
END;

BEGIN
        PERFORM * FROM app.EmergencyCall LIMIT 1;
        RAISE NOTICE '✅ SELECT: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ SELECT: нет прав';
    END;

    RAISE NOTICE 'Проверка INSERT в audit.EventLog';
    BEGIN
        INSERT INTO audit.EventLog (actor_id, target_table, target_id, action, details)
        VALUES (1, 'app.EmergencyCall', 1, 'Тест', 'Ошибка должна произойти');
        RAISE NOTICE '✅ INSERT: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ INSERT: нет прав';
    END;

    RAISE NOTICE 'Проверка DELETE из audit.EventLog';
    BEGIN
        DELETE FROM audit.EventLog WHERE id = 1;
        RAISE NOTICE '✅ DELETE: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ DELETE: нет прав';
    END;

END $$;

RESET ROLE;





SET ROLE dml_admin;

DO $$
BEGIN
    RAISE NOTICE '== ПРОВЕРКА РОЛИ dml_admin ==';

    BEGIN
        PERFORM * FROM app.EmergencyCall LIMIT 1;
        RAISE NOTICE '✅ SELECT: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ SELECT: нет прав';
    END;

    BEGIN
        INSERT INTO app.EmergencyCall (call_time, address, type_id, description, reported_by)
        VALUES (NOW(), 'Test address', 1, 'Test call', 'Tester');
        RAISE NOTICE '✅ INSERT: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ INSERT: нет прав';
    END;

    BEGIN
        UPDATE app.EmergencyCall SET description = 'Updated' WHERE address = 'Test address';
        RAISE NOTICE '✅ UPDATE: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ UPDATE: нет прав';
    END;

    BEGIN
        DELETE FROM app.EmergencyCall WHERE address = 'Test address';
        RAISE NOTICE '✅ DELETE: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ DELETE: нет прав';
    END;

    BEGIN
    CREATE TABLE app.test_dml_admin (
        id SERIAL PRIMARY KEY,
        name VARCHAR(50)
    );
    RAISE NOTICE '✅ CREATE TABLE: OK';
    EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '❌ CREATE TABLE: нет прав';
    END;


END $$;

RESET ROLE;




SET ROLE security_admin;

DO $$
BEGIN
    RAISE NOTICE '== ПРОВЕРКА security_admin ==';

    BEGIN
        CREATE ROLE test_role_1;
        RAISE NOTICE '✅ CREATE ROLE: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ CREATE ROLE: нет прав';
    END;

    BEGIN
        GRANT CONNECT ON DATABASE lab1 TO test_role_1;
        RAISE NOTICE '✅ GRANT CONNECT: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ GRANT CONNECT: нет прав';
    END;

    BEGIN
        REVOKE CONNECT ON DATABASE lab1 FROM test_role_1;
        RAISE NOTICE '✅ REVOKE CONNECT: OK';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ REVOKE CONNECT: нет прав';
    END;

    BEGIN
    ALTER DEFAULT PRIVILEGES FOR ROLE security_admin IN SCHEMA app REVOKE ALL ON TABLES FROM test_role_1;
    RAISE NOTICE '✅ DEFAULT PRIVILEGES сняты с test_role_1';
    EXCEPTION WHEN insufficient_privilege THEN
        RAISE NOTICE '❌ Невозможно снять DEFAULT PRIVILEGES с test_role_1';
    END;

END $$;

RESET ROLE;

DROP ROLE test_role_1;
