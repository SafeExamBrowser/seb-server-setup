.. _logguide-label:

Setup Initial Log Guide
-----------------------

When the SEB Server services start up for the first time or after an update you can make some checks according to the logs.
Following the startup logs of each service is shown with some additional comments about the information the logs give.

**SEB Server Service Startup Log**

 .. code-block:: bash
    
    $ docker logs ${container name}

::
    
    08:00:38.110 INFO  [main]:[ch.ethz.seb.sebserver.SEBServer] Started SEBServer in 12.343 seconds (JVM running for 12.825)
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   ___  ___  ___   ___
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->  / __|| __|| _ ) / __| ___  _ _ __ __ ___  _ _
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->  \__ \| _| | _ \ \__ \/ -_)| '_|\ V // -_)| '_|
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->  |___/|___||___/ |___/\___||_|   \_/ \___||_|
    
    **The first sections shows the version, active profiles and context path of the service**
    
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Version: sprint-testing-f632cc9
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Active profiles: [gui, ws, prod-ws, prod-gui, prod]
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Context Path: /
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    
    **This section shows the seb-guiservice startup information**
    
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** GUI Service starting up...                        ***
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Webservice connection: http://localhost:8080/admin-api/v1
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> GUI service internal connection : http://0.0.0.0:8080
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> GUI service external connection : https://localhost:443
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> GUI service endpoint : /gui
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Webservice admin API endpoint: /admin-api/v1
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Webservice exam API endpoint: /exam-api
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Webservice admin API basic access: --guiClient--
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> SEB Server GUI running on bundled setup
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** GUI Service successfully successfully started up! ***
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    
    **This section shows the seb-sebservice startup info**
    
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** Webservice starting up...                         ***
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Register Webservice: 9c68d959-b0c0-4611-b5cb-c8d39cfe58c6_sprint-testing-f632cc9
    08:00:38.226 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Successfully register Webservice instance. uuid: 9c68d959-b0c0-4611-b5cb-c8d39cfe58c6_sprint-testing-f632cc9, address: 172.19.0.4
    08:00:38.226 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    
    **Here the database migration starts and gives info about migration that are applied and might be failed too**
    
    08:00:38.226 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> ** Migration check START **
    08:00:38.226 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Check database status
    08:00:38.311 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Found pending migrations: 2
    08:00:38.311 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.311 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> **** Start Migration ************************************
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Migration finished, new current version is: 29 --> set charset utf8mb4 v2 0
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> **** End Migration **************************************
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> ** Migration check END **
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    
    **Internal service init information and additional consistency check information**
    
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Initialize Services...
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> **** Run data-base integrity checks ****
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.615 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: OrientationTableDuplicatesCheck / Checks if there are duplicate entries in the orientation table by using the config_attribute_id and template_id to identify duplicates.
    08:00:38.650 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: Fixed duplicates by deletion: [990]
    08:00:38.651 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: ClipboardSEBSettingsGUICheck / Check if clipboardPolicy SEB Setting is missing in the GUI and if so add it to GUI
    08:00:38.654 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: clipboardPolicy SEB Setting detected in GUI
    08:00:38.657 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: ViewTableDuplicatesCheck / Checks if there are duplicate entries in the view table by using the name and template_id to identify duplicates.
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: OK
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: DowngradeSEBSettingsCheck / Check if there are additional SEB Settings orientations within the database that do not match the once for the current SEB Server version.
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: No additional SEB Settings orientations for downgrading found.
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: TableCharsetCheck / Checks the char-set and collation of DB tables if correct utf8mb4_general_ci is set
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: Skip check since this is done by a migration task
    08:00:38.714 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------>
    08:00:38.714 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Activate exam run controller background task
    08:00:38.714 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Task runs on an interval of 60000 milliseconds
    08:00:38.714 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Real exam running time span is expanded on 3600000 before start and 3600000 milliseconds after ending
    08:00:38.722 INFO  [main]:[ch.ethz.seb.sebserver.webservice.servicelayer.dao.impl.WebserviceInfoDAOImpl] Set webservice 9c68d959-b0c0-4611-b5cb-c8d39cfe58c6_sprint-testing-f632cc9 as master
    08:00:38.724 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------>
    08:00:38.724 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Activate SEB lost-ping-event update background task on a fix rate of: 5000 milliseconds
    08:00:38.725 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------>
    08:00:38.725 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Run SEBInstructionService...
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> No pending SEB client instructions found on persistent storage
    
    **Started up webservice information about common settings**
    
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** Webservice Info:                                  ***
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> JDBC connection pool max size: 100
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Configured Features:
    08:00:38.733 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.auditlogs --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.institution --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.user.account --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.user.account.self.registering --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.user.account.self.registering.autoactivation --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.user.administration --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   config.certificate --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   config.connection.configuration --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   config.exam.configuration --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   config.template --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.administration --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.ask --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.connection.config --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.monitoring.indicators --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.noLMS --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.seb.clientgroups --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.seb.liveProctoring --> false
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.seb.restriction --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.seb.screenProctoring --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.template --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.quiz.lookup --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.ANS_DELFT --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.MOCKUP --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.MOODLE --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.MOODLE_PLUGIN --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.OLAT --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.OPEN_EDX --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.finished.exams --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.overall.export --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.cancel.connection --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.client.filter --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.detailview --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.detailview.logexport --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.issue.filter --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.live.proctoring --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.lockscreen --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.quit --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.screen.proctoring --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.state.filter --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exams --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Working with ping service: BLOCKING
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Server address: 0.0.0.0
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Server port: 8080
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Local-Host address: 172.19.0.4
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Local-Host name: 4c15d0736cde
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Remote-Host address: 127.0.0.1
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Remote-Host name: localhost
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Context Path: /
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> External-Host URL: https://localhost:443
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Autologin URL: https://localhost:443
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> LMS-External-Address-Alias: {}
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> HTTP Scheme https
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Access-Tokens:
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> admin API access token validity: 3600s
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> admin API refresh token validity: 25200s
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> exam API access token validity: 43200s
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Screen Proctoring Bundle enabled: true
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> ScreenProctoringServiceBundle [bundled=true, serviceURL=https://localhost:4431, clientId=sebserverClient, apiAccountName=SEBServerAPIAccount]
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Property Override Test: This is a basic bundled productive setup
    08:00:38.737 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.737 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.737 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** Webservice successfully started up!               ***
    08:00:38.737 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************


   **the following section shows logging of specific migration tasks applied on fist update to 3.0**

    10:52:46.216 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ---->
    10:52:46.216 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ----> Check to apply reparation task for legacy Data for version 3.0
    10:52:46.216 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Wait to become master and SPS availability for at least 2 minutes"
    10:52:46.222 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------>
    10:52:46.222 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Start repairing legacy User Roles and add subsequent roles for InstitutionalAdmin and ExamAdmin if needed
    10:52:46.249 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Found Institutional Admin User with missing roles. Add missing roles: InstAdmin : 4190fa3e-4365-4fc2-9a85-68874bce6808
    10:52:46.276 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Successfully update User Roles for user: InstAdmin new roles: [EXAM_ADMIN, EXAM_SUPPORTER, INSTITUTIONAL_ADMIN]
    10:52:46.281 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Found Exam Admin User with missing roles. Add missing roles: ExamAdmin : 2a54a0fc-5987-4e23-ba23-d3f2b80fa68a
    10:52:46.296 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Successfully update User Roles for user: ExamAdmin new roles: [EXAM_ADMIN, EXAM_SUPPORTER]
    10:52:46.316 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Successfully finished repairing legacy User Roles
    10:52:46.320 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------>
    10:52:46.320 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Start repairing legacy Exams data...
    10:52:46.334 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Repair exam: 1 : b00b88a5-5a44-4c6e-bf57-11539d4e743e
    10:52:47.581 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ----------> Successfully synchronized Exam with SPS: 1 : b00b88a5-5a44-4c6e-bf57-11539d4e743e
    10:52:47.587 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Repair exam: 2 : 9a7db80d-23dd-424c-8cba-5d4dd4b5a849
    10:52:47.596 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ----------> Found invalid supervisor users for exam: 2 : 9a7db80d-23dd-424c-8cba-5d4dd4b5a849 old supervisor UUIDs [cb3a4075-4970-4496-a6f4-fb159c663863, c320e8a5-2b4a-4849-bc48-da358d826483, 67318279-db13-491a-b8ea-771a66ae3998, 9becca05-6254-4b2e-b529-90a2ae0b4d52], new supervisor UUIDs [cb3a4075-4970-4496-a6f4-fb159c663863, c320e8a5-2b4a-4849-bc48-da358d826483, 67318279-db13-491a-b8ea-771a66ae3998]
    10:52:47.697 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ----------> Successfully synchronized Exam with SPS: 2 : 9a7db80d-23dd-424c-8cba-5d4dd4b5a849
    10:52:47.703 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Repair exam: 3 : dd2db50e-8134-44a8-aaf1-ad99a6f0dcaf
    10:52:47.785 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ----------> Successfully synchronized Exam with SPS: 3 : dd2db50e-8134-44a8-aaf1-ad99a6f0dcaf
    10:52:47.793 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Successfully finished repairing legacy Exams
    10:52:47.797 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Start repairing legacy Exam Templates add set 'apply to groups' SPS collecting strategy if not set already...
    10:52:47.830 INFO  [asyncService-1]:[ch.ethz.seb.sebserver.webservice.servicelayer.exam.impl.ExamTemplateServiceImpl] **** Change collecting strategy form 'EXAM' to 'APPLY_SEB_GROUPS' for: ExamTemplate1
    10:52:48.007 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Successfully finished repairing legacy ExamTemplates and set SPS grouping strategy 'APPLY_SEB_GROUPS'
    10:52:48.008 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------>
    10:52:48.008 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] ------> Start SPS User Account synchronization
    10:52:48.011 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Synchronize User sebserver-admin with SPS
    10:52:48.117 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Synchronize User cb3a4075-4970-4496-a6f4-fb159c663863 with SPS
    10:52:48.191 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Synchronize User 4190fa3e-4365-4fc2-9a85-68874bce6808 with SPS
    10:52:48.243 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Synchronize User 2a54a0fc-5987-4e23-ba23-d3f2b80fa68a with SPS
    10:52:48.298 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Synchronize User c320e8a5-2b4a-4849-bc48-da358d826483 with SPS
    10:52:48.356 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Synchronize User 67318279-db13-491a-b8ea-771a66ae3998 with SPS
    10:52:48.412 INFO  [asyncService-1]:[ch.ethz.seb.SEB_SERVER_REPAIR] --------> Finished initial SPS User Account synchronisation successfully



 **SPS Webservice example Log**

::
    
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT]  _______ _______ _______      _______ _______ ______   __   __ ___ _______ _______
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |       |       |  _    |    |       |       |    _ | |  | |  |   |       |       |
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |  _____|    ___| |_|   |    |  _____|    ___|   | || |  |_|  |   |       |    ___|
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] | |_____|   |___|       |    | |_____|   |___|   |_||_|       |   |       |   |___
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |_____  |    ___|  _   |     |_____  |    ___|    __  |       |   |      _|    ___|
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT]  _____| |   |___| |_|   |     _____| |   |___|   |  | ||     ||   |     |_|   |___
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |_______|_______|_______| ___|_______|_______|___|  |_|_|___|_|___|_______|_______|____ _______ _______ ______   ___ __    _ _______
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |       |       |    _ | |       |       |  |  | |    |       |    _ | |       |       |       |       |    _ | |   |  |  | |       |
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |  _____|       |   | || |    ___|    ___|   |_| |    |    _  |   | || |   _   |       |_     _|   _   |   | || |   |   |_| |    ___|
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] | |_____|       |   |_||_|   |___|   |___|       |    |   |_| |   |_||_|  | |  |       | |   | |  | |  |   |_||_|   |       |   | __
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |_____  |      _|    __  |    ___|    ___|  _    |    |    ___|    __  |  |_|  |      _| |   | |  |_|  |    __  |   |  _    |   ||  |
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT]  _____| |     |_|   |  | |   |___|   |___| | |   |    |   |   |   |  | |       |     |_  |   | |       |   |  | |   | | |   |   |_| |
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |_______|_______|___|  |_|_______|_______|_|  |__|    |___|   |___|  |_|_______|_______| |___| |_______|___|  |_|___|_|  |__|_______|
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ----> Version: sprint-testing-9abbf93
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ----> Active profiles: [prod]
    28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> Context Path: /
    28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> *** Webservice starting up...                         ***
    28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> Register Webservice: 96487e9f-e503-4d56-bcbd-7688f38ce12d_sprint-testing-9abbf93
    28.08.2024 08:00:35.934 INFO  [main]:[com.zaxxer.hikari.HikariDataSource] HikariPool-1 - Starting...
    28.08.2024 08:00:36.015 INFO  [main]:[com.zaxxer.hikari.HikariDataSource] HikariPool-1 - Start completed.
    28.08.2024 08:00:36.078 WARN  [main]:[org.mariadb.jdbc.message.server.ErrorPacket] Error: 1146-42S02: Table 'SEBScreenProctoring.webservice_server_info' doesn't exist
    28.08.2024 08:00:36.168 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:36.168 INFO  [main]:[SERVICE_INIT] ----> **** Migration check START ******************************
    28.08.2024 08:00:36.169 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:36.169 INFO  [main]:[SERVICE_INIT] ----> Check database status
    28.08.2024 08:00:36.171 INFO  [main]:[org.flywaydb.core.internal.license.VersionPrinter] Flyway Community Edition 7.8.2 by Redgate
    28.08.2024 08:00:36.214 INFO  [main]:[org.flywaydb.core.internal.database.base.BaseDatabaseType] Database: jdbc:mariadb://seb-server-mariadb/SEBScreenProctoring (MariaDB 10.5)
    28.08.2024 08:00:36.276 INFO  [main]:[SERVICE_INIT] ----> Found pending migrations: 4
    28.08.2024 08:00:36.277 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    28.08.2024 08:00:36.277 INFO  [main]:[SERVICE_INIT] ----> **** Start Migration ************************************
    28.08.2024 08:00:36.277 INFO  [main]:[org.flywaydb.core.internal.license.VersionPrinter] Flyway Community Edition 7.8.2 by Redgate
    28.08.2024 08:00:36.299 INFO  [main]:[org.flywaydb.core.internal.license.VersionPrinter] Flyway Community Edition 7.8.2 by Redgate
    28.08.2024 08:00:36.310 INFO  [main]:[org.flywaydb.core.internal.command.DbValidate] Successfully validated 4 migrations (execution time 00:00.003s)
    28.08.2024 08:00:36.320 INFO  [main]:[org.flywaydb.core.internal.schemahistory.JdbcTableSchemaHistory] Creating Schema History table `SEBScreenProctoring`.`flyway_schema_history` ...
    28.08.2024 08:00:36.378 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Current version of schema `SEBScreenProctoring`: << Empty Schema >>
    28.08.2024 08:00:36.400 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Migrating schema `SEBScreenProctoring` to version "1 - create tables v1 0"
    28.08.2024 08:00:36.408 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.oauth_access_token' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.432 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.oauth_refresh_token' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.448 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.user' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.470 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.screenshot_data' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.494 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.screenshot' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.518 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.seb_group' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.544 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.session' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.576 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.client_access' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.597 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.entity_privilege' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.625 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.additional_attribute' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.642 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.webservice_server_info' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.659 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.audit_log' (SQL State:  - Error Code: 1051)
    28.08.2024 08:00:36.693 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Migrating schema `SEBScreenProctoring` to version "3 - add UUID to client access"
    28.08.2024 08:00:36.724 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Migrating schema `SEBScreenProctoring` to version "4 - add exam table"
    28.08.2024 08:00:36.901 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Migrating schema `SEBScreenProctoring` to version "5 - set charset utf8mb4"
    28.08.2024 08:00:36.965 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Successfully applied 4 migrations to schema `SEBScreenProctoring`, now at version v5 (execution time 00:00.592s)
    28.08.2024 08:00:36.967 INFO  [main]:[org.flywaydb.core.internal.license.VersionPrinter] Flyway Community Edition 7.8.2 by Redgate
    28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ----> Migration finished, new current version is: 5 --> set charset utf8mb4
    28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ----> **** End Migration **************************************
    28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ----> **** Migration check END ********************************
    28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.007 INFO  [main]:[SERVICE_INIT] ----> Successfully register Webservice instance. uuid: 96487e9f-e503-4d56-bcbd-7688f38ce12d_sprint-testing-9abbf93, address: 172.19.0.5
    28.08.2024 08:00:37.007 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.007 INFO  [main]:[SERVICE_INIT] ----> **** Initialize Services... *****************************
    28.08.2024 08:00:37.007 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.015 INFO  [main]:[SERVICE_INIT] ------> Activate background update task
    28.08.2024 08:00:37.015 INFO  [main]:[SERVICE_INIT] ------> Task runs on an update interval of 15000
    28.08.2024 08:00:37.039 INFO  [main]:[ch.ethz.seb.sps.server.datalayer.dao.impl.WebserviceInfoDAOImpl] Set webservice 96487e9f-e503-4d56-bcbd-7688f38ce12d_sprint-testing-9abbf93 as master
    28.08.2024 08:00:37.042 INFO  [main]:[SERVICE_INIT] -------->
    28.08.2024 08:00:37.042 INFO  [main]:[SERVICE_INIT] --------> This instance has become master!
    28.08.2024 08:00:37.042 INFO  [main]:[SERVICE_INIT] -------->
    28.08.2024 08:00:37.061 INFO  [main]:[SERVICE_INIT] ----> Screenshot Store: 2 workers with update-interval: 1000 initialized
    28.08.2024 08:00:37.061 INFO  [main]:[SERVICE_INIT] ----> SessionServiceHealthControl initialized
    28.08.2024 08:00:37.064 INFO  [main]:[SERVICE_INIT] ----> Screenshot FULL_RDBMS Store: initialized
    28.08.2024 08:00:37.064 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.064 INFO  [main]:[SERVICE_INIT] ----> **** Services initialized *******************************
    28.08.2024 08:00:37.064 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.071 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.071 INFO  [main]:[SERVICE_INIT] ----> Create Initial SEB Server API Account with name: SEBServerAPIAccount
    28.08.2024 08:00:37.072 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.109 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> *** Webservice Info:                                  ***
    28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> JDBC connection pool max size: 10
    28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> Admin access token validity seconds: 3600
    28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> Admin refresh token validity seconds: 25200
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> SEB session access token validity seconds: 43200
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Webservice context path: /
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Internal Server address: 0.0.0.0
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Internal Server port: 8090
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Local-Host address: 172.19.0.5
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Local-Host name: 47e92ba78184
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Remote-Host address: 127.0.0.1
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Remote-Host name: localhost
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> External service URI: https://localhost:4431
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Remote-Host name: localhost
    28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> Setup: distributed / cloud setup
    28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> Bundle: SEB Server bundle
    28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ---->
    28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> *** Webservice successfully started up!               ***
    28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> *********************************************************

    **the following section shows logging of specific migration tasks applied on fist update to 3.0**

    28.10.2026 11:30:30.196 INFO  [http-nio-0.0.0.0-8090-exec-8]:[ch.ethz.seb.sps.server.datalayer.dao.impl.ExamDAOBatis] Update: change Supporter for Exam: 39 : 6538:3268:Testkurs Mac KI:-- : 401-0242-00J 2024W : MAYDAY -- Schnellübung 11: Integration durch Substitution --> from: 30261dba-cb87-4e48-ae2a-e6747d36112c to: []
