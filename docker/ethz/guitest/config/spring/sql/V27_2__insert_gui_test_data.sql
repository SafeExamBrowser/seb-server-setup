UPDATE lms_setup SET active=0 WHERE id=2;
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution1', 'inst1', 0);
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution2', 'inst2', 0);
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution3', 'inst3', 0);
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution4', 'inst4', 0);
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution5', 'inst5', 0);
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution6', 'inst6', 1);
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution7', 'inst7', 1);
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution8', 'inst8', 1);
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution9', 'inst9', 1);
INSERT INTO institution (name, url_suffix, active) VALUES ('Institution10', 'inst10', 1);

INSERT INTO user (institution_id, uuid, creation_date, name, surname, username, password, email, language, timeZone, active) VALUES
(7, 'institutional-admin1', '2019-01-01', 'institutional-admin1', 'institutional-admin1', 'institutional-admin1','$2a$08$c2GKYEYoUVXH1Yb8GXVXVu66ltPvbZgLMcVSXRH.LgZNF/YeaYB8m', 'inst-admin1@nomail.nomail', 'en', 'UTC', 1 );
INSERT INTO user_role(user_id, role_name) VALUES (2, 'INSTITUTIONAL_ADMIN');

INSERT INTO user (institution_id, uuid, creation_date, name, surname, username, password, email, language, timeZone, active) VALUES
(8, 'institutional-admin2', '2019-01-01', 'institutional-admin2', 'institutional-admin2', 'institutional-admin2','$2a$08$c2GKYEYoUVXH1Yb8GXVXVu66ltPvbZgLMcVSXRH.LgZNF/YeaYB8m', 'inst-admin2@nomail.nomail', 'en', 'UTC', 1 );
INSERT INTO user_role(user_id, role_name) VALUES (3, 'INSTITUTIONAL_ADMIN');

INSERT INTO user (institution_id, uuid, creation_date, name, surname, username, password, email, language, timeZone, active) VALUES
(7, 'testuser1', '2019-01-01', 'testuser1-name', 'testuser1-surname', 'testuser1-username','$2a$08$c2GKYEYoUVXH1Yb8GXVXVu66ltPvbZgLMcVSXRH.LgZNF/YeaYB8m', 'testuser1@nomail.nomail', 'en', 'UTC', 1 );
INSERT INTO user_role(user_id, role_name) VALUES (4, 'EXAM_SUPPORTER');

INSERT INTO user (institution_id, uuid, creation_date, name, surname, username, password, email, language, timeZone, active) VALUES
(8, 'testuser2', '2019-01-01', 'testuser2-name', 'testuser2-surname', 'testuser2-username','$2a$08$c2GKYEYoUVXH1Yb8GXVXVu66ltPvbZgLMcVSXRH.LgZNF/YeaYB8m', 'testuser2@nomail.nomail', 'en', 'UTC', 1 );
INSERT INTO user_role(user_id, role_name) VALUES (5, 'EXAM_SUPPORTER');

INSERT INTO user (institution_id, uuid, creation_date, name, surname, username, password, email, language, timeZone, active) VALUES
(7, 'exam-admin1', '2019-01-01', 'exam-admin1-name', 'exam-admin1-surname', 'exam-admin1-username','$2a$08$c2GKYEYoUVXH1Yb8GXVXVu66ltPvbZgLMcVSXRH.LgZNF/YeaYB8m', 'exam-admin1@nomail.nomail', 'en', 'UTC', 1 );
INSERT INTO user_role(user_id, role_name) VALUES (6, 'EXAM_ADMIN');

INSERT INTO user (institution_id, uuid, creation_date, name, surname, username, password, email, language, timeZone, active) VALUES
(7, 'exam-admin2', '2019-01-01', 'exam-admin2-name', 'exam-admin2-surname', 'exam-admin2-username','$2a$08$c2GKYEYoUVXH1Yb8GXVXVu66ltPvbZgLMcVSXRH.LgZNF/YeaYB8m', 'exam-admin2@nomail.nomail', 'en', 'UTC', 1 );
INSERT INTO user_role(user_id, role_name) VALUES (7, 'EXAM_ADMIN');

INSERT INTO user (institution_id, uuid, creation_date, name, surname, username, password, email, language, timeZone, active) VALUES
(7, 'exam-admin3', '2019-01-01', 'exam-admin3-name', 'exam-admin3-surname', 'exam-admin3-username','$2a$08$c2GKYEYoUVXH1Yb8GXVXVu66ltPvbZgLMcVSXRH.LgZNF/YeaYB8m', 'exam-admin3@nomail.nomail', 'en', 'UTC', 1 );
INSERT INTO user_role(user_id, role_name) VALUES (8, 'EXAM_ADMIN');

INSERT INTO user (institution_id, uuid, creation_date, name, surname, username, password, email, language, timeZone, active) VALUES
(7, 'exam-admin4', '2019-01-01', 'exam-admin4-name', 'exam-admin4-surname', 'exam-admin4-username','$2a$08$c2GKYEYoUVXH1Yb8GXVXVu66ltPvbZgLMcVSXRH.LgZNF/YeaYB8m', 'exam-admin4@nomail.nomail', 'en', 'UTC', 1 );
INSERT INTO user_role(user_id, role_name) VALUES (9, 'EXAM_ADMIN');




INSERT INTO seb_client_configuration (id, institution_id, name, date, client_name, client_secret, encrypt_secret, active) VALUES (2, 1, 'Connection Configuration 3', now(), 'ConnectionConfiguration3', '139ac27e49d9206c5fb70f4615550ce6f4ac09084198ed69cc0a8279309f98656a0fe1ad014538f18a6e3b37137137336a913bffe74951b78ddc980e1ed16229bb9d1b6f60a419d923b4ce164853a62fd2faa82f5dadd978522710437aa81086098388fedf943c87', NULL, 1);

INSERT INTO seb_client_configuration (id, institution_id, name, date, client_name, client_secret, encrypt_secret, active) VALUES (3, 7, 'Connection Configuration 4', now(), 'ConnectionConfiguration4', '139ac27e49d9206c5fb70f4615550ce6f4ac09084198ed69cc0a8279309f98656a0fe1ad014538f18a6e3b37137137336a913bffe74951b78ddc980e1ed16229bb9d1b6f60a419d923b4ce164853a62fd2faa82f5dadd978522710437aa81086098388fedf943c87', NULL, 1);

INSERT INTO seb_client_configuration (id, institution_id, name, date, client_name, client_secret, encrypt_secret, active) VALUES (4, 8, 'Connection Configuration 5', now(), 'ConnectionConfiguration5', '139ac27e49d9206c5fb70f4615550ce6f4ac09084198ed69cc0a8279309f98656a0fe1ad014538f18a6e3b37137137336a913bffe74951b78ddc980e1ed16229bb9d1b6f60a419d923b4ce164853a62fd2faa82f5dadd978522710437aa81086098388fedf943c87', NULL, 0);


INSERT INTO configuration_node (id, institution_id, template_id, owner, name, description, type, status) VALUES (2, 7, 0, 'exam-admin1-username', 'Exam Config 1', 'Description 1', 'EXAM_CONFIG', 'CONSTRUCTION');
INSERT INTO configuration (id, institution_id, configuration_node_id, version, version_date, followup) VALUES (3, 7, 2, 'v0', '2021-11-01 08:20:00', 0);
INSERT INTO configuration (id, institution_id, configuration_node_id, version, version_date, followup) VALUES (4, 7, 2, NULL, NULL, 1);

INSERT INTO configuration_node (id, institution_id, template_id, owner, name, description, type, status) VALUES (3, 7, 0, 'exam-admin2-username', 'Exam Config 2', 'Description 2', 'EXAM_CONFIG', 'CONSTRUCTION');
INSERT INTO configuration (id, institution_id, configuration_node_id, version, version_date, followup) VALUES (5, 7, 3, 'v0', '2021-11-01 08:21:00', 0);
INSERT INTO configuration (id, institution_id, configuration_node_id, version, version_date, followup) VALUES (6, 7, 3, NULL, NULL, 1);

INSERT INTO configuration_node (id, institution_id, template_id, owner, name, description, type, status) VALUES (4, 7, 0, 'super-admin', 'Exam Config 3', 'Description 3', 'EXAM_CONFIG', 'READY_TO_USE');
INSERT INTO configuration (id, institution_id, configuration_node_id, version, version_date, followup) VALUES (7, 7, 4, 'v0', '2021-11-01 08:22:00', 0);
INSERT INTO configuration (id, institution_id, configuration_node_id, version, version_date, followup) VALUES (8, 7, 4, NULL, NULL, 1);


INSERT INTO configuration_node (id, institution_id, template_id, owner, name, description, type, status) VALUES (5, 1, 0, 'super-admin', 'Configuration Template 1', 'Description 1', 'TEMPLATE', 'IN_USE');
INSERT INTO configuration (id, institution_id, configuration_node_id, version, version_date, followup) VALUES (9, 1, 5, 'v0', '2021-11-05 08:20:00', 0);
INSERT INTO configuration (id, institution_id, configuration_node_id, version, version_date, followup) VALUES (10, 1, 5, NULL, NULL, 1);
