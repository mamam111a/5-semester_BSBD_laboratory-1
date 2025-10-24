CREATE SCHEMA app;
CREATE SCHEMA ref;
CREATE SCHEMA audit;
CREATE SCHEMA stg;

CREATE TABLE ref.ResponsePlan (
    id SERIAL PRIMARY KEY,
    plan_name VARCHAR(100) UNIQUE NOT NULL,
    incident_type_id INT REFERENCES ref.IncidentType(id) NOT NULL,
    description VARCHAR(300) NOT NULL,
    last_updated TIMESTAMP 
);
CREATE TABLE ref.IncidentType (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,  
    description VARCHAR(300)                  
);

CREATE TABLE app.EmergencyCall ( 
    id SERIAL PRIMARY KEY,
    call_time TIMESTAMP NOT NULL,
    address VARCHAR(100) NOT NULL,
    type_id INT REFERENCES ref.IncidentType(id) NOT NULL,
    description VARCHAR(300),
    reported_by VARCHAR(100)
);
CREATE TABLE app.CallAssignment (
    call_id INT REFERENCES app.EmergencyCall(id) NOT NULL,
    employee_id INT REFERENCES app.Employee(id) NOT NULL,
    PRIMARY KEY (call_id, employee_id)
);
CREATE TABLE app.EquipmentAssignment (
    call_id INT REFERENCES app.EmergencyCall(id) NOT NULL,
    equipment_id INT REFERENCES app.Equipment(id) NOT NULL,
    PRIMARY KEY (call_id, equipment_id)
);

CREATE TABLE app.Equipment (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    status VARCHAR(15) NOT NULL CHECK (status IN ('Используется', 'Не используется')),
    last_maintenance DATE,
    fire_station_id INT REFERENCES app.FireStation(id) NOT NULL
);

CREATE TABLE app.Employee (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    post VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    fire_station_id INT REFERENCES FireStation(id) NOT NULL
);

CREATE TABLE audit.EventLog (
    id SERIAL PRIMARY KEY,
    event_time TIMESTAMP NOT NULL DEFAULT NOW(),
    actor_id INT REFERENCES app.Employee(id) NOT NULL,
   target_table VARCHAR(50) NOT NULL,
target_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    details VARCHAR(300) 
);

CREATE TABLE app.FireStation (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL,
    adress VARCHAR(200) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

INSERT INTO "FireStation" (code, address, phone_number) VALUES
('FS01', 'ул. Ленина, 10', '+7 495 111-11-11'),
('FS02', 'ул. Пушкина, 5', '+7 495 222-22-22'),
('FS03', 'пр. Мира, 12', '+7 495 333-33-33'),
('FS04', 'ул. Гагарина, 8', '+7 495 444-44-44'),
('FS05', 'ул. Чехова, 15', '+7 495 555-55-55'),
('FS06', 'пр. Славы, 20', '+7 495 666-66-66'),
('FS07', 'ул. Победы, 7', '+7 495 777-77-77'),
('FS08', 'ул. Кутузова, 3', '+7 495 888-88-88'),
('FS09', 'пр. Ломоносова, 14', '+7 495 999-99-99'),
('FS10', 'ул. Толстого, 11', '+7 495 101-01-01');

INSERT INTO "Employee" (first_name, last_name, middle_name, phone_number, email, post, hire_date, fire_station_id) VALUES
('Иван', 'Иванов', 'Иванович', '+7 900 111-11-11', 'ivanov@example.com', 'Пожарный', '2015-05-10', 1),
('Пётр', 'Петров', 'Петрович', '+7 900 222-22-22', 'petrov@example.com', 'Пожарный', '2016-03-15', 1),
('Сергей', 'Сергеев', NULL, '+7 900 333-33-33', 'sergeev@example.com', 'Диспетчер', '2017-07-20', 2),
('Алексей', 'Алексеев', 'Алексеевич', '+7 900 444-44-44', 'alekseev@example.com', 'Пожарный', '2018-01-12', 2),
('Дмитрий', 'Дмитриев', 'Дмитриевич', '+7 900 555-55-55', 'dmitriev@example.com', 'Диспетчер', '2019-09-09', 3),
('Николай', 'Николаев', NULL, '+7 900 666-66-66', 'nikolaev@example.com', 'Пожарный', '2020-02-20', 3),
('Владимир', 'Владимиров', 'Владимирович', '+7 900 777-77-77', 'vladimirov@example.com', 'Пожарный', '2014-12-12', 1),
('Евгений', 'Евгеньев', NULL, '+7 900 888-88-88', 'evgenev@example.com', 'Диспетчер', '2013-06-06', 2),
('Михаил', 'Михайлов', 'Михайлович', '+7 900 999-99-99', 'mikhailov@example.com', 'Пожарный', '2012-08-08', 3),
('Анатолий', 'Анатольев', NULL, '+7 900 101-01-01', 'anatolyev@example.com', 'Пожарный', '2011-11-11', 1);

INSERT INTO "IncidentType" (name, description) VALUES
('Пожар', 'Обычный пожар'),
('Загазованность', 'Присутствие токсичных газов'),
('Наводнение', 'Затопление территории'),
('ДТП', 'Дорожно-транспортное происшествие'),
('Обрушение', 'Обрушение здания или конструкции'),
('Взрыв', 'Взрывные происшествия'),
('Химическая авария', 'Разлив химических веществ'),
('Электропроблемы', 'Пожары и аварии с электросетями'),
('Медицинская помощь', 'Неотложная медицинская помощь'),
('Прочее', 'Другие виды инцидентов');

INSERT INTO "ResponsePlan" (plan_name, incident_type_id, description, last_updated) VALUES
('План пожар', 1, 'План действий при пожаре', NOW()),
('План газа', 2, 'План действий при загазованности', NOW()),
('План наводнения', 3, 'План действий при наводнении', NOW()),
('План ДТП', 4, 'План действий при ДТП', NOW()),
('План обрушения', 5, 'План действий при обрушении', NOW()),
('План взрыва', 6, 'План действий при взрыве', NOW()),
('План хим. аварии', 7, 'План действий при химической аварии', NOW()),
('План эл. аварии', 8, 'План действий при авариях с электричеством', NOW()),
('План мед. помощи', 9, 'План действий при оказании медпомощи', NOW()),
('План прочее', 10, 'План действий при прочих инцидентах', NOW());

INSERT INTO "Equipment" (name, type, status, last_maintenance, fire_station_id) VALUES
('Пожарная машина 1', 'Техника', 'Используется', '2024-01-10', 1),
('Пожарная машина 2', 'Техника', 'Не используется', '2024-02-10', 1),
('Рукав 1', 'Инвентарь', 'Используется', '2024-01-15', 2),
('Рукав 2', 'Инвентарь', 'Используется', '2024-01-20', 2),
('Насос 1', 'Техника', 'Используется', '2024-03-01', 3),
('Насос 2', 'Техника', 'Не используется', '2024-03-05', 3),
('Щит пожарного', 'Экипировка', 'Используется', '2024-02-28', 1),
('Шлем', 'Экипировка', 'Используется', '2024-02-25', 2),
('Костюм', 'Экипировка', 'Используется', '2024-02-26', 3),
('Аптечка', 'Экипировка', 'Используется', '2024-03-01', 1);

INSERT INTO "EmergencyCall" (call_time, address, type_id, description, reported_by) VALUES
('2025-10-01 08:00', 'ул. Ленина, 15', 1, 'Пожар в квартире', 'Иван Иванов'),
('2025-10-01 09:00', 'ул. Пушкина, 7', 2, 'Запах газа', 'Пётр Петров'),
('2025-10-01 10:00', 'пр. Мира, 20', 3, 'Затопление подвала', 'Сергей Сергеев'),
('2025-10-01 11:00', 'ул. Ленина, 12', 4, 'ДТП с пострадавшими', 'Алексей Алексеев'),
('2025-10-01 12:00', 'ул. Пушкина, 9', 5, 'Обрушение стены', 'Дмитрий Дмитриев'),
('2025-10-01 13:00', 'пр. Мира, 22', 6, 'Взрыв газа', 'Николай Николаев'),
('2025-10-01 14:00', 'ул. Ленина, 18', 7, 'Разлив хим. веществ', 'Владимир Владимиров'),
('2025-10-01 15:00', 'ул. Пушкина, 11', 8, 'Короткое замыкание', 'Евгений Евгеньев'),
('2025-10-01 16:00', 'пр. Мира, 24', 9, 'Травма на работе', 'Михаил Михайлов'),
('2025-10-01 17:00', 'ул. Ленина, 20', 10, 'Прочие происшествия', 'Анатолий Анатольев');

INSERT INTO "CallAssignment" (call_id, employee_id) VALUES
(1,1),(1,2),(2,3),(2,4),(3,5),(3,6),(4,7),(4,8),(5,9),(5,10);
INSERT INTO "EquipmentAssignment" (call_id, equipment_id) VALUES
(1,1),(1,7),(2,2),(2,8),(3,3),(3,4),(4,5),(4,6),(5,9),(5,10);

INSERT INTO "EventLog" (event_time, actor_id, target_table, target_id, action, details) VALUES
(NOW(), 1, 'EmergencyCall', 1, 'Создание вызова', 'Первый тестовый вызов'),
(NOW(), 2, 'EmergencyCall', 2, 'Создание вызова', 'Второй тестовый вызов'),
(NOW(), 3, 'Employee', 3, 'Обновление данных', 'Обновлен телефон'),
(NOW(), 4, 'Equipment', 4, 'Проверка', 'Проверка состояния оборудования'),
(NOW(), 5, 'ResponsePlan', 5, 'Редактирование', 'Изменён план реагирования'),
(NOW(), 6, 'IncidentType', 6, 'Создание', 'Добавлен новый тип инцидента'),
(NOW(), 7, 'EmergencyCall', 7, 'Закрытие вызова', 'Вызов обработан'),
(NOW(), 8, 'CallAssignment', 8, 'Назначение', 'Сотрудник назначен на вызов'),
(NOW(), 9, 'EquipmentAssignment', 9, 'Назначение', 'Оборудование назначено'),
(NOW(), 10, 'FireStation', 1, 'Обновление', 'Изменён адрес станции');


CREATE ROLE app_reader NOINHERIT;
CREATE ROLE app_writer NOINHERIT;
CREATE ROLE app_owner NOINHERIT;
CREATE ROLE auditor NOINHERIT;

CREATE ROLE ddl_admin NOINHERIT;
CREATE ROLE dml_admin NOINHERIT;
CREATE ROLE security_admin NOINHERIT;

REVOKE ALL ON SCHEMA app FROM PUBLIC;
REVOKE ALL ON SCHEMA ref FROM PUBLIC;
REVOKE ALL ON SCHEMA audit FROM PUBLIC;

REVOKE ALL ON ALL TABLES IN SCHEMA app FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA ref FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA audit FROM PUBLIC;

REVOKE ALL ON ALL SEQUENCES IN SCHEMA app FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA ref FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA audit FROM PUBLIC;

GRANT USAGE ON SCHEMA app TO app_reader;
GRANT USAGE ON SCHEMA ref TO app_reader;

GRANT USAGE ON SCHEMA app TO app_writer;

GRANT USAGE, CREATE ON SCHEMA app TO app_owner;
GRANT USAGE, CREATE ON SCHEMA ref TO app_owner;

GRANT USAGE ON SCHEMA audit TO auditor;
GRANT SELECT ON ALL TABLES IN SCHEMA app TO app_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA ref TO app_reader;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA app TO app_writer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA app TO app_owner;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ref TO app_owner;
GRANT SELECT ON ALL TABLES IN SCHEMA audit TO auditor;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA app TO app_reader;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA ref TO app_reader;

GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA app TO app_writer;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA app TO app_owner;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA ref TO app_owner;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA audit TO auditor;


ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT SELECT ON TABLES TO app_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA ref GRANT SELECT ON TABLES TO app_reader;



ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT USAGE, SELECT ON SEQUENCES TO app_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA ref GRANT USAGE, SELECT ON SEQUENCES TO app_reader;



ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT SELECT, INSERT, UPDATE ON TABLES TO app_writer;
ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO app_writer;



ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT ALL PRIVILEGES ON TABLES TO app_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA ref GRANT ALL PRIVILEGES ON TABLES TO app_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT ALL PRIVILEGES ON SEQUENCES TO app_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA ref GRANT ALL PRIVILEGES ON SEQUENCES TO app_owner;



ALTER DEFAULT PRIVILEGES IN SCHEMA audit GRANT SELECT ON TABLES TO auditor;
ALTER DEFAULT PRIVILEGES IN SCHEMA audit GRANT USAGE, SELECT ON SEQUENCES TO auditor;



GRANT USAGE ON SCHEMA app, public, ref, stg, audit TO ddl_admin;
GRANT CREATE ON SCHEMA app, public, ref, stg, audit TO ddl_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddl_admin IN SCHEMA app, public, ref, stg, audit 
GRANT REFERENCES, TRIGGER ON TABLES TO ddl_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE ddl_admin IN SCHEMA app, public, ref, stg, audit 
GRANT USAGE ON SEQUENCES TO ddl_admin;
ALTER ROLE ddl_admin CREATEDB;
GRANT CREATE ON DATABASE lab1 TO ddl_admin;


GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA app TO dml_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ref TO dml_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA audit TO dml_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA app TO dml_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA ref TO dml_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA audit TO dml_admin;
GRANT USAGE ON SCHEMA app TO dml_admin;
GRANT USAGE ON SCHEMA ref TO dml_admin;
GRANT USAGE ON SCHEMA audit TO dml_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO dml_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA ref GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO dml_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA audit GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO dml_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA app GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO dml_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA ref GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO dml_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA audit GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO dml_admin;


CREATE ROLE security_admin NOINHERIT CREATEROLE; 

CREATE INDEX index_responseplan_incident_type ON ResponsePlan(incident_type_id);
CREATE INDEX index_eventlog_actor ON EventLog(actor_id);




CREATE FUNCTION audit.log_change()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_actor_id INT;
BEGIN
    SET LOCAL search_path = 'app, public';
    SELECT id INTO v_actor_id
    FROM app.Employee
    WHERE username = current_user;
    IF v_actor_id IS NULL THEN
        RAISE EXCEPTION 'Сотрудник для текущего пользователя не найден: %', current_user;
    END IF;
    INSERT INTO audit.EventLog(
        actor_id,
        target_table,
        target_id,
        action,
        details
    )
    VALUES (
        v_actor_id,              
        TG_TABLE_NAME,         
        COALESCE(NEW.id, OLD.id),  
        TG_OP,               
        'Автоматическая запись через триггер'
    );

    RETURN NEW;
END;