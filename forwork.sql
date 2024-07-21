CREATE OR REPLACE PROCEDURE data.test_object_relation1()
LANGUAGE plpgsql AS $$
DECLARE
    lb_id INT;
    obj_id INT;
    parent_lb_id INT;
    last_inserted_characteristic_id INT;
    last_inserted_logic_block_config_id INT;
    related_identifier_characteristic_id_1 INT;
    related_identifier_characteristic_id_2 INT;
BEGIN
    SET search_path TO systemconfig, data;

    -- Системный объект
    INSERT INTO "system.objects" (code, "name")
    VALUES ('TT1', 'Тест соединения') RETURNING id INTO obj_id;

    -- Логические блоки
    -- можно по сути вытягивать этот ЛБ дальше через select
    SELECT * INTO lb_id FROM insert_logic_block('ts1', 'Test1', 'test1');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO last_inserted_logic_block_config_id;

    CALL add_main_attribute(last_inserted_logic_block_config_id);
    CALL add_system_characteristics(last_inserted_logic_block_config_id);
    CALL add_identifier(last_inserted_logic_block_config_id);
    CALL add_start_end_dates(last_inserted_logic_block_config_id);
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Name', 'Название');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Code', 'Code');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
   
    --соединения
    --parent
    SELECT * INTO lb_id FROM insert_logic_block('ts2', 'Test2', 'test2_parent');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO parent_lb_id;
   
    CALL add_db_ignore_logic_block_attribute(parent_lb_id);
   
    --child 1
    SELECT * INTO lb_id FROM insert_logic_block('ts2_1', 'Test2_1', 'test2_child_1');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO last_inserted_logic_block_config_id;
   
    CALL add_child_to_parent(parent_lb_id, last_inserted_logic_block_config_id);

    CALL add_system_characteristics(last_inserted_logic_block_config_id);
    CALL add_identifier(last_inserted_logic_block_config_id);
    CALL add_start_end_dates(last_inserted_logic_block_config_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'RelationTypeId', 'Вид соединения');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'Number', 'SystemObjectId', 'Тип соединенного объекта');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    -- тут добавлю
    --CALL add_system_object_attribute(last_inserted_characteristic_id, ARRAY['TT2']);

    SELECT * INTO related_identifier_characteristic_id_1 FROM insert_characteristic(last_inserted_logic_block_config_id, 'Number', 'RelatedIdentifier', 'ИД. соединенного объекта');
    CALL add_required_attribute(related_identifier_characteristic_id_1);
    CALL add_display_attribute(related_identifier_characteristic_id_1);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Name1', 'Код');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_db_ignore_attribute(last_inserted_characteristic_id);
    --тут
	--CALL add_relation_attribute(last_inserted_characteristic_id, related_identifier_characteristic_id, 'TT2', 'ts4', 'Name');
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Code2', 'Название');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_db_ignore_attribute(last_inserted_characteristic_id);
    --CALL add_relation_attribute(last_inserted_characteristic_id, related_identifier_characteristic_id, 'TT2', 'ts4', 'Code');
    

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Priority', 'Приоритет');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_max_length_attribute(last_inserted_characteristic_id, 2);
   
   --child 1
    SELECT * INTO lb_id FROM insert_logic_block('ts2_2', 'Test2_2', 'test2_child_2');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO last_inserted_logic_block_config_id;
   
    CALL add_child_to_parent(parent_lb_id, last_inserted_logic_block_config_id);

    CALL add_system_characteristics(last_inserted_logic_block_config_id);
    CALL add_identifier(last_inserted_logic_block_config_id);
    CALL add_start_end_dates(last_inserted_logic_block_config_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'RelationTypeId', 'Вид соединения');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'Number', 'SystemObjectId', 'Тип соединенного объекта');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    -- тут добавлю
    --CALL add_system_object_attribute(last_inserted_characteristic_id, ARRAY['TT3']);

    SELECT * INTO related_identifier_characteristic_id_2 FROM insert_characteristic(last_inserted_logic_block_config_id, 'Number', 'RelatedIdentifier', 'ИД. соединенного объекта');
    CALL add_required_attribute(related_identifier_characteristic_id_2);
    CALL add_display_attribute(related_identifier_characteristic_id_2);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Name1', 'Код');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_db_ignore_attribute(last_inserted_characteristic_id);
    --тут
	--CALL add_relation_attribute(last_inserted_characteristic_id, related_identifier_characteristic_id, 'TT3', 'ts6','Name');
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Code2', 'Название');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_db_ignore_attribute(last_inserted_characteristic_id);
   --CALL add_relation_attribute(last_inserted_characteristic_id, related_identifier_characteristic_id, 'TT3', 'ts6', 'Code');
    

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Priority', 'Приоритет');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_max_length_attribute(last_inserted_characteristic_id, 2);
    
    --ЛБ
    SELECT * INTO lb_id FROM insert_logic_block('ts3', 'Test3', 'test3');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO last_inserted_logic_block_config_id;

    CALL add_main_attribute(last_inserted_logic_block_config_id);
    CALL add_system_characteristics(last_inserted_logic_block_config_id);
    CALL add_identifier(last_inserted_logic_block_config_id);
    CALL add_start_end_dates(last_inserted_logic_block_config_id);
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'inherited1', 'ХК из одной таблицы');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    --CALL add_inheritance_attribute(last_inserted_characteristic_id, 'TT2', 'ShouldBeInherited', related_identifier_characteristic_id_1);
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'inherited2', 'ХК из одной таблицы');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    --CALL add_inheritance_attribute(last_inserted_characteristic_id, 'TT3', 'ShouldBeInherited', related_identifier_characteristic_id_2);

    CALL create_table_if_not_exists(obj_id);
END; $$;

CALL data.test_object_relation1();

SELECT *
FROM "characteristics" c 
INNER JOIN "logic.block.configurations" lbc ON lbc.id = c.logic_block_configuration_id
INNER JOIN "logic.blocks" lb ON lbc.logic_block_id = lb.id
WHERE  c."name" IN ('RelatedIdentifier', 'inherited2')

CALL add_system_object_attribute(119, ARRAY['TT2']);
CALL add_relation_attribute(122, 119, 'TT2', 'ts4', 'Name');
CALL add_relation_attribute(123, 119, 'TT2', 'ts4', 'Code');

CALL add_system_object_attribute(133, ARRAY['TT3']);
CALL add_relation_attribute(136, 133, 'TT3', 'ts6', 'Name');
CALL add_relation_attribute(137, 133, 'TT3', 'ts6', 'Code');

CALL add_inheritance_attribute(147, 'TT2', 'ShouldBeInherited', 119);
CALL add_inheritance_attribute(148, 'TT3', 'ShouldBeInherited', 133);

-- 2 obj

CREATE OR REPLACE PROCEDURE data.test_object_relation2()
LANGUAGE plpgsql AS $$
DECLARE
    lb_id INT;
    obj_id INT;
    parent_lb_id INT;
    last_inserted_characteristic_id INT;
    last_inserted_logic_block_config_id INT;
    related_identifier_characteristic_id INT;
BEGIN
    SET search_path TO systemconfig, data;

    -- Системный объект
    INSERT INTO "system.objects" (code, "name")
    VALUES ('TT2', 'Тест соединения2') RETURNING id INTO obj_id;

    -- Логические блоки
    -- можно по сути вытягивать этот ЛБ дальше через select
    SELECT * INTO lb_id FROM insert_logic_block('ts4', 'Test4', 'test4');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO last_inserted_logic_block_config_id;

    CALL add_main_attribute(last_inserted_logic_block_config_id);
    CALL add_system_characteristics(last_inserted_logic_block_config_id);
    CALL add_identifier(last_inserted_logic_block_config_id);
    CALL add_start_end_dates(last_inserted_logic_block_config_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Name', 'Название');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Code', 'Code');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'ShouldBeInherited', 'Code');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
   
    --соединения
    --parent
    SELECT * INTO lb_id FROM insert_logic_block('ts5', 'Test5', 'test5_parent');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO parent_lb_id;
   
    CALL add_db_ignore_logic_block_attribute(parent_lb_id);
   
    SELECT * INTO lb_id FROM insert_logic_block('ts5_1', 'Test5_1', 'test5_child_1');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO last_inserted_logic_block_config_id;
   
   CALL add_child_to_parent(parent_lb_id, last_inserted_logic_block_config_id);

    CALL add_system_characteristics(last_inserted_logic_block_config_id);
    CALL add_identifier(last_inserted_logic_block_config_id);
    CALL add_start_end_dates(last_inserted_logic_block_config_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'RelationTypeId', 'Вид соединения');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'Number', 'SystemObjectId', 'Тип соединенного объекта');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    --тут
    --CALL add_system_object_attribute(last_inserted_characteristic_id, ARRAY['TT3']);

    SELECT * INTO related_identifier_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'Number', 'RelatedIdentifier', 'ИД. соединенного объекта');
    CALL add_required_attribute(related_identifier_characteristic_id);
    CALL add_display_attribute(related_identifier_characteristic_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Name1', 'Название');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_db_ignore_attribute(last_inserted_characteristic_id);
    --CALL add_relation_attribute(last_inserted_characteristic_id, related_identifier_characteristic_id, 'TT3', 'ts6','Name');

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Code2', 'Code');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_db_ignore_attribute(last_inserted_characteristic_id);
    --CALL add_relation_attribute(last_inserted_characteristic_id, related_identifier_characteristic_id, 'TT3', 'ts6', 'Code');

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Priority', 'Приоритет');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_max_length_attribute(last_inserted_characteristic_id, 2);

    CALL create_table_if_not_exists(obj_id);
END; $$;

CALL data.test_object_relation2()

SELECT *
FROM "characteristics" c 
INNER JOIN "logic.block.configurations" lbc ON lbc.id = c.logic_block_configuration_id
INNER JOIN "logic.blocks" lb ON lbc.logic_block_id = lb.id
WHERE  c."name" IN ('SystemObjectId') AND 

CALL add_system_object_attribute(169, ARRAY['TT3']);
CALL add_relation_attribute(171, 170, 'TT3', 'ts6', 'Name');
CALL add_relation_attribute(172, 170, 'TT3', 'ts6', 'Code');

-- 3 obj
CREATE OR REPLACE PROCEDURE data.test_object_relation3()
LANGUAGE plpgsql AS $$
DECLARE
    lb_id INT;
    obj_id INT;
    parent_lb_id INT;
    last_inserted_characteristic_id INT;
    last_inserted_logic_block_config_id INT;
    related_identifier_characteristic_id INT;
BEGIN
    SET search_path TO systemconfig, data;

    -- Системный объект
    INSERT INTO "system.objects" (code, "name")
    VALUES ('TT3', 'Тест соединения2') RETURNING id INTO obj_id;

    -- Логические блоки
    -- можно по сути вытягивать этот ЛБ дальше через select
    SELECT * INTO lb_id FROM insert_logic_block('ts6', 'Test6', 'test6');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO last_inserted_logic_block_config_id;

    CALL add_main_attribute(last_inserted_logic_block_config_id);
    CALL add_system_characteristics(last_inserted_logic_block_config_id);
    CALL add_identifier(last_inserted_logic_block_config_id);
    CALL add_start_end_dates(last_inserted_logic_block_config_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Name', 'Название');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Code', 'Code');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
   
    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'ShouldBeInherited', 'Code');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
   
    --соединения
    --parent
    SELECT * INTO lb_id FROM insert_logic_block('ts7', 'Test7', 'test7_parent');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO parent_lb_id;
   
    CALL add_db_ignore_logic_block_attribute(parent_lb_id);
   
    SELECT * INTO lb_id FROM insert_logic_block('ts7_1', 'Test7_1', 'test7_child_1');

    INSERT INTO "logic.block.configurations"(logic_block_id, system_object_id)
    VALUES(lb_id, obj_id) RETURNING id INTO last_inserted_logic_block_config_id;
   
   CALL add_child_to_parent(parent_lb_id, last_inserted_logic_block_config_id);

    CALL add_system_characteristics(last_inserted_logic_block_config_id);
    CALL add_identifier(last_inserted_logic_block_config_id);
    CALL add_start_end_dates(last_inserted_logic_block_config_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'RelationTypeId', 'Вид соединения');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'Number', 'SystemObjectId', 'Тип соединенного объекта');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    --тут
    --CALL add_system_object_attribute(last_inserted_characteristic_id, ARRAY['TT2']);

    SELECT * INTO related_identifier_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'Number', 'RelatedIdentifier', 'ИД. соединенного объекта');
    CALL add_required_attribute(related_identifier_characteristic_id);
    CALL add_display_attribute(related_identifier_characteristic_id);

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Name1', 'Код');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_db_ignore_attribute(last_inserted_characteristic_id);
    --CALL add_relation_attribute(last_inserted_characteristic_id, related_identifier_characteristic_id, 'TT2', 'ts4', 'Name');

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Code2', 'Название');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_db_ignore_attribute(last_inserted_characteristic_id);
    --CALL add_relation_attribute(last_inserted_characteristic_id, related_identifier_characteristic_id, 'TT2', 'ts4', 'Code');

    SELECT * INTO last_inserted_characteristic_id FROM insert_characteristic(last_inserted_logic_block_config_id, 'STRING', 'Priority', 'Приоритет');
    CALL add_required_attribute(last_inserted_characteristic_id);
    CALL add_display_attribute(last_inserted_characteristic_id);
    CALL add_max_length_attribute(last_inserted_characteristic_id, 2);

    CALL create_table_if_not_exists(obj_id);
END; $$;

CALL DATA.test_object_relation3()

SELECT *
FROM "characteristics" c 
INNER JOIN "logic.block.configurations" lbc ON lbc.id = c.logic_block_configuration_id
INNER JOIN "logic.blocks" lb ON lbc.logic_block_id = lb.id
WHERE  c."name" IN ('SystemObjectId')

CALL add_system_object_attribute(194, ARRAY['TT2']);
CALL add_relation_attribute(196, 195, 'TT2', 'ts4', 'Name');
CALL add_relation_attribute(197, 195, 'TT2', 'ts4', 'Code');

--procedures
CREATE OR REPLACE PROCEDURE systemconfig.add_inheritance_attribute(
	char_id INT, 
	sys_object_code TEXT, 
	source_char_name TEXT, 
	data_id_char_id INT)
LANGUAGE plpgsql AS $$
DECLARE 
	source_char_id INT;
	attribute_id INT;
BEGIN
    SET search_path TO systemconfig;
   
    SELECT c.id
    INTO source_char_id
    FROM "logic.block.configurations" lbc
    INNER JOIN "characteristics" c ON c.logic_block_configuration_id = lbc.id
    INNER JOIN "system.objects" so ON so.id = lbc.system_object_id 
    WHERE c."name" ILIKE source_char_name
      AND so.code ILIKE sys_object_code
    LIMIT 1;

    INSERT INTO "characteristic.attributes" (characteristic_attribute_type_id, characteristic_id)
    VALUES (22, char_id) RETURNING id INTO attribute_id;
   
    INSERT INTO "characteristic.attribute.inheritance"(id, data_characteristic_id, source_characteristic_id)
    VALUES (attribute_id, data_id_char_id, source_char_id);
END; $$;

CREATE OR REPLACE PROCEDURE systemconfig.add_child_to_parent(
	lb_parent_id INT, 
	lb_child_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    SET search_path TO systemconfig;
   
    UPDATE "logic.block.configurations" 
    SET parent_id = lb_parent_id
    WHERE id = lb_child_id;
END; $$;

CREATE OR REPLACE PROCEDURE systemconfig.add_db_ignore_logic_block_attribute(lbc_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    SET search_path TO systemconfig;
   
    INSERT INTO "logic.block.attributes"(logic_block_attribute_type_id, logic_block_configuration_id)
    VALUES (10, lbc_id);
END; $$;

CREATE OR REPLACE PROCEDURE systemconfig.create_table_if_not_exists(system_obj_id INT)
LANGUAGE plpgsql AS $$
DECLARE
    r RECORD;
BEGIN
    SET search_path TO systemconfig;

    FOR r IN SELECT lbc.id AS lbc_id, 
                    lb.table_name, 
                    so.code
             FROM "logic.block.configurations" lbc
             INNER JOIN "logic.blocks" lb ON lb.id = lbc.logic_block_id
             INNER JOIN "system.objects" so ON so.id = lbc.system_object_id
             WHERE lbc.system_object_id = system_obj_id
               AND lbc.id NOT IN (SELECT logic_block_configuration_id FROM "logic.block.attributes" WHERE logic_block_attribute_type_id = 10)
    LOOP
        CALL create_table(r.lbc_id, r.table_name, r.code);
    END LOOP;

    --если надо, потом добавим лог таблицы
END; $$;

SELECT * 
FROM "logic.blocks" lb 
INNER JOIN "logic.block.configurations" lbc ON lb.id = lbc.logic_block_id
INNER JOIN "logic.block.attributes" lba ON lba.logic_block_configuration_id  = lbc.id 
WHERE table_name ILIKE '%child%'


INSERT INTO "logic.block.attributes"(logic_block_attribute_type_id, logic_block_configuration_id)
VALUES (9, 13),(9, 14),(9, 18),(9, 21)

-- time constraint
CREATE OR REPLACE PROCEDURE systemconfig.test_generic_time_constraint(lb_config_id int, rec_id int)
AS $$
DECLARE
    need_to_devide_id int;
    r RECORD;
    full_table_name TEXT;
    required_char_number INT;
    update_columns_names TEXT;
BEGIN
    SET search_path TO DATA, systemconfig;
   
    -- получаем имя таблицы
   	SELECT so.code || '.' || lb.table_name 
   	INTO full_table_name
   	FROM systemconfig."logic.block.configurations" lbc
   	INNER JOIN systemconfig."logic.blocks" lb ON lbc.logic_block_id = lb.id
   	INNER JOIN systemconfig."system.objects" so ON lbc.system_object_id  = so.id
   	WHERE lbc.id = lb_config_id;
   
    -- проверяем есть ли необходимые хар-ки
    SELECT COUNT(*)
    INTO required_char_number
    FROM systemconfig."characteristics" c 
    WHERE c.logic_block_configuration_id = lb_config_id
      AND LOWER(c."name") IN ('id', 'startdate', 'enddate', 'identifier');
   
     IF required_char_number != 4 THEN
     	RAISE EXCEPTION 'Не хватает необходимых характеристик (id, identifier, startdate, enddate)';
     END IF;
   
    EXECUTE format('SELECT * FROM data.%I WHERE id = $1 LIMIT 1;', full_table_name)
    INTO r
    USING rec_id;
   
    EXECUTE 
     format('SELECT id '                ||
            'FROM data.%I t1 '          ||
            'WHERE t1.id != $1 '        ||
            '  AND t1.startdate < $2 '  ||
            '  AND t1.enddate > $3 '    ||
            '  AND t1.identifier = $4 ' ||
            'LIMIT 1;',
            full_table_name)
    INTO need_to_devide_id
    USING r.id, r.startdate, r.enddate, r.identifier;
   
    IF need_to_devide_id IS NOT NULL THEN
    
    	SELECT string_agg(ca.name, ', ') 
    	INTO update_columns_names
    	FROM systemconfig."characteristics" ca
    	WHERE ca.logic_block_configuration_id = lb_config_id
    	  AND LOWER(ca.name) NOT IN ('id', 'startdate') 
          AND ca.id NOT IN (SELECT characteristic_id FROM systemconfig."characteristic.attributes" WHERE characteristic_attribute_type_id = 21);
       
        EXECUTE 
         format('INSERT INTO data.%I (%s, startdate) ' ||
                'SELECT %s, $1 '                       ||
                'FROM data.%I t1 '                     ||
                'WHERE t1.id = $2;',
                full_table_name, update_columns_names, update_columns_names,full_table_name)
        USING r.enddate + INTERVAL '1 day', need_to_devide_id;
		
       	EXECUTE 
       	 format('UPDATE data.%I '   ||
       	        'SET enddate = $1 ' ||
       	        'WHERE id = $2;',
       	        full_table_name)
       	USING r.startdate - INTERVAL '1 day', need_to_devide_id;
    ELSE
    	EXECUTE 
    	 format('DELETE FROM data.%I t1 '   ||
    	        'WHERE t1.identifier = $1 ' ||
    	        '  AND t1.startdate >= $2 ' ||
    	        '  AND t1.enddate <= $3 '   ||
    	        '  AND t1.id != $4;',
    	        full_table_name)
    	USING r.identifier, r.startdate, r.enddate, r.id;
    
        EXECUTE 
         format('UPDATE data.%I t1 '                                          ||
                'SET startdate = '                                            ||
                'CASE '                                                       ||
                '   WHEN t1.startdate > $1 AND t1.startdate < $2 THEN $3 '    ||
                '   ELSE t1.startdate '                                       ||
                'END, '                                                       ||
                'enddate = '                                                  ||
                'CASE '                                                       ||
                '   WHEN t1.enddate < $1 OR t1.enddate > $2 THEN t1.enddate ' ||
                '   ELSE $4 '                                                 ||
                'END '                                                        ||
                'WHERE t1.identifier = $5'                                    ||
                '  AND t1.id != $6 '                                          ||
                '  AND t1.startdate <= $2 '                                   ||
                '  AND t1.enddate >= $1;',
                full_table_name)
        USING r.startdate, r.enddate, r.enddate + INTERVAL '1 day', r.startdate - INTERVAL '1 day', r.identifier, r.id;
    END IF;
END;
$$ LANGUAGE plpgsql;


CALL systemconfig.test_generic_time_constraint(19, 5)