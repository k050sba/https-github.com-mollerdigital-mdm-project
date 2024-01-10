INTRODUCTION

Prior to the release of this tool many configuration activities such as creation of users, association 
of users with roles, generation and deployment of ORS-Specific APIs and IDD Applications 
were done solely through manual operations using the Hub console or the IDD Config UI.

This tool allows running these operations through the command line to better enable scripting and automation. 
It involves one time setting of the properties for some generic information and then running commands for
configuration and deployments.  Below are instructions on how to use the tool to automate different parts
of hub and IDD configuration.

As the underlying private API's this tool relies on are quite old and stable, it can work with most versions of 
MDM. This tool is a client side tool and does not need to be run on the server.  Network connectivity 
to the MDM server is needed.

PREREQUISITE

At least hub server should be installed and running. For ORS related operations, those ORSes should be
installed and registered with master database.


INSTRUCTIONS

Below are the list of instructions to use the tool.

1- Unzip MDMAutomation.zip in an empty directory. You should get following files:

	AcquireReleaseLock.cmd
	AcquireReleaseLock.sh
	AddLoginModule.cmd
	AddLoginModule.sh
	AppserverContext.cmd
	AppserverContext.sh
	AssignRolesToUser.cmd
	AssignRolesToUser.sh
	AssignUsersToDatabases.cmd
	AssignUsersToDatabases.sh
	automation.properties
	commons-lang-2.3.jar
	CreateUsers.cmd
	CreateUsers.sh
	DeleteUsers.cmd
	DeleteUsers.sh
	GenerateDeployORSSpecificSchema.cmd
	GenerateDeployORSSpecificSchema.sh
	IddDeployment.cmd
	IddDeployment.sh
	IddGetApp.cmd
	IddGetApp.sh
	IddImportToExistingApp.cmd
	IddImportToExistingApp.sh
	jboss-client.jar
	LdapConnection.cmd
	LdapConnection.sh
	LdapUserSynchronization.cmd
	LdapUserSynchronization.sh
	LdapGroupSynchronization.cmd
	LdapGroupSynchronization.sh
	log4j-1.2.16.jar
	MDMAutomation.jar
	ojdbc6.jar
	db2jcc.jar
	sqljdbc4.jar

    Note: If you are running this utility on Unix machine, run dos2unix command for all sh files. This step
	  will remove ^M from the end of sh files. Below is the command to run dos2unix command.

	>dos2unix AcquireReleaseLock.sh
	>dos2unix AddLoginModule.sh
	>dos2unix AppserverContext.sh
	>dos2unix AssignRolesToUser.sh
	>dos2unix AssignUsersToDatabases.sh
	>dos2unix CreateUsers.sh
	>dos2unix DeleteUsers.sh
	>dos2unix GenerateDeployORSSpecificSchema.sh
	>dos2unix IddDeployment.sh
	>dos2unix IddGetApp.sh
	>dos2unix IddImportToExistingApp.sh
	>dos2unix LdapConnection.sh
	>dos2unix LdapGroupSynchronization.sh
	>dos2unix LdapUserSynchronization.sh

2- Copy following jar files from <hub_server_install>\lib to the directory where above files are unzipped.

	siperian-common.jar
	siperian-server.jar
	siperian-api.jar
	siperian-sql.jar

    Also, copy following jar files from <hub_server_install>\lib\hashing to the directory where above files are unzipped.
	siperian-server-hash.jar
	siperian-server-hashutils.jar
	bcprov-jdk15on-1.54.jar

3- Make sure java version 1.7.0_25 or higher is in path. Also, make sure MDM is running in JBoss EAP 6.1 
   or WebLogic 10.3.6 or WebSphere 8.5. 

4- Open automation.properties and update following properties as per your environment.

   (a) Properties for JBoss 
	appserver.type=jboss
	appserver.version=7.2 

	## Jboss credentials for JBoss EAP 6.1/6.4 or JBoss 7.2
	jboss.hostname=localhost
	jboss.remote_port=4447
	
	# enable JBoss EJB security support (by default, it is false)
	cmx.jboss7.security.enabled=false

   (b) Properties for Websphere

	appserver.type=websphere
	websphere.hostname=localhost
	websphere.rmi_port=2809
	
   (c) Properties for WebLogic
   
	appserver.type=weblogic
	weblogic.hostname=localhost
	weblogic.port=7001
	weblogic.login=weblogic
	weblogic.password=weblogic
   
   (d) Properties for hub server admin username and password

	MDMAdminUsername=<MDM_admin_user_name>
	MDMAdminPassword=<MDM_password_of_admin_user>

		or

	MDMAdminEncryptedPassword=<MDM_encrypted_password_of_admin_user> 

   Note: For admin user password, either use MDMAdminPassword property for clear text password or use 
         MDMAdminEncryptedPassword for encrypted password.

	 Use <resourcekit_install>\automation\ExecuteBatchCommandLineTool to generate ecrypted password.

5- Run following command to acquire and release lock.

   Command to run on Windows platforms:

	>AcquireReleaseLock.cmd

   Command to run on Unix platforms:

	>AcquireReleaseLock.sh

6- Below is the command to Generate and Deploy ORS-Specific JMS Schema and ORS-Specific SIF API. In this
   command two arguments need to be passed. The first argument is ORS databaseId. Every ORS has its own 
   databaseId. You can get ORS databaseId from hub console ->Databases -> click on respective ORS, then
   you can see Database ID under database properties.

   In 2nd argument, put SIF to Generate and Deploy ORS-Specific SIF APIs or put JMS to Generate and Deploy
   ORS-Specific Schema.

   Command to run on Windows platforms:

	>GenerateDeployORSSpecificSchema.cmd  <ors_database_id>  <SIF|JMS>

   Command to run on Unix platforms:

	>GenerateDeployORSSpecificSchema.sh  <ors_database_id>  <SIF|JMS>

   Note: From 9.7.1 onwards, for SIF, it will generate and deploy only new and updated objects.

7- User registration to cmx_system

   Before you run user creation tool, you must configure the automation.properties file for your environment.
   The automation.properties file contains sample properties to help you configure the file.

   (a) Edit the following property to provide the number of users you want to create:
	MDM.number.of.new.users

	Note: You can create a maximum of 1000 users.

   (b) For each user that you want to create, edit the following properties for each user to provide the name,
       username, password, if user is external authenticated, if user is administrator and if default database
       is one of the ORS databases.  If the max length of firstname(30), middlename(30), lastname(50),
       or email (100) is exceeded, it is automatically trimmed to the max length.

	MDM.new.user.firstname#
	MDM.new.user.middlename#
	MDM.new.user.lastname#
	MDM.new.user.username#
	MDM.new.user.password#
	MDM.new.user.isExternalAuthentication#
	MDM.new.user.isAdministrator#
	MDM.new.user.defaultDatabaseId#
	MDM.new.user.email#

	# is a number between 0 and (MDM.number.of.new.users)-1.

	The value of MDM.new.user.isExternalAuthentication# (if user is externally authenticated) is either "Y" or "N".

	If user is not externally authenticated, then user's password (MDM.new.user.password#) is required.

	The value of MDM.new.user.isAdministrator# (if user is administrator) is either "Y" or "N".

	The value of MDM.new.user.defaultDatabaseId# is the name of database id of default ORS database. If this
	property is not set, then user will be registered with system database.

   (c) Run following command to create users in cmx_system whose properties are set in automation.properties.

	Command to run on Windows platforms:

	    >CreateUsers.cmd

	Command to run on Unix platforms:

	    >CreateUsers.sh


8- Assign users to different ORSes - To assign user to different ORSes, first of all those users needs to be
   registered either manually through hub console or automatically through above command. Once users are
   registered, there are two ways you can assign user to different ORSes.  This command now treats usernames as 
   case insensitive.

   (a) Run following command to assign users to different ORSes.

       Command to run on Windows platforms:

	>AssignUsersToDatabases.cmd <list_of_registered_users> <list_of_registered_ORS_databaseIds>
	    where list_of_registered_users with comma delimiter without any space in between.
            where list_of_registered_ORS_databaseIds with comma delimiter without any space in between.

       Command to run on Unix platforms:

	>AssignUsersToDatabases.cmd <list_of_registered_users> <list_of_registered_ORS_databaseIds>
	    where list_of_registered_users with comma delimiter without any space in between.
            where list_of_registered_ORS_databaseIds with comma delimiter without any space in between.

       In above commands, one or more users can be assigned to one or more ORSes. If first argument in above
       command is user1,user2,user3 and if second argument is ors1,ors2, then the script will assign user1, user2
       and user3 to ors1 and ors2.

   (b) Incase username has space or some special characters which command line is unable to handle,
       you must configure the automation.properties file for your environment. The automation.properties file
       contains sample properties to help you configure the file.

       i) Edit the following property to provide the number of user and ORS database relationship you want to create:
	  
	  MDM.number.of.user_ors_relationships

	  Note: You can create a maximum of 1000 user ORS relationship in one command.

       ii) For each user that you want register with ORS databases, edit the following properties for each user
           to provide username and list of databaseIds for ORSes for which this user needs to be registered.

	   MDM.user_ors_rel.username#
	   MDM.user_ors_rel.databaseIds#

	   # is a number between 0 and (MDM.number.of.user_ors_relationships)-1.
	   databaseIds should be separated by comma.

	   In this scenario, if you want to register N users with different ORSes, N different
	   MDM.user_ors_rel.username# and MDM.user_ors_rel.databaseIds# properties need to be defined in
	   automation.properties.


        iii) Run following command to register user with different ORSes whose properties are set in automation.properties.

	     Command to run on Windows platforms:

	        >AssignUsersToDatabases.cmd

	     Command to run on Unix platforms:

	        >AssignUsersToDatabases.sh

9- Assign Roles to User - Before assigning roles to uses, make sure roles already exist in the corresponding
   ORS database and corresponding user already register with ORS database.

   Before you run assign roles to user tool, you must configure the automation.properties file for your environment.
   The automation.properties file contains sample properties to help you configure the file.

   (a) Edit the following property to provide the number of user and roles relationship you want to create:
       
       MDM.number.of.user_roles_relationships

       Note: You can create a maximum of 1000 user roles relationship in one command.

   (b) For each user that you want assign roles, edit the following properties for each user to provide username,
       ORS databaseId and list of roles in that ORS for which this user needs to be registered.

	   MDM.user_roles_rel.username#
	   MDM.user_roles_rel.databaseId#
	   MDM.user_roles_rel.roles#

	   # is a number between 0 and (MDM.number.of.user_roles_relationships)-1.
	   roles should be separated by comma.

       If you want to delink all the roles from a user, either don't set MDM.user_roles_rel.roles# property or set it to
       a blank value.

   (c) Run following command to assign user with different roles whose properties are set in automation.properties.

	     Command to run on Windows platforms:

	        >AssignRolesToUser.cmd

	     Command to run on Unix platforms:

	        >AssignRolesToUser.sh

    Note: Make sure user is already registered with ORS in which you are trying to assign different roles.
          If user is not registered with ORS, you will see following exception:

	com.delos.cmx.server.datalayer.repository.ReposException: SIP-10318: Could not get user for role due to data access error.

10- Delete users

   DeleteUsers can now delete a single user, or delete all the users specified in the automation.properties file.
   
   If deleting a single user, pass the -u <CASE_INSENSITIVE_USERNAME> to the command.  The username is not case sensitive.
   
   If deleting multiple users - Before you run user deletion tool, you must configure the automation.properties file for your environment.
   The automation.properties file contains sample properties to help you configure the file.

   (a) Edit the following property to provide the number of users you want to delete:
	MDM.number.of.delete.users

	Note: You can delete a maximum of 1000 users.

   (b) For each user that you want to delete, edit the following properties for each user to provide the username.

	MDM.delete.user.username#

	# is a number between 0 and (MDM.number.of.delete.users)-1.

   (c) Run following command to delete users in cmx_system whose properties are set in automation.properties.

	Command to run on Windows platforms:

	    >DeleteUsers.cmd

	Command to run on Unix platforms:

	    >DeleteUsers.sh
        
   (c2) Run following command to delete a single user in cmx_system that is passed in via -u flag.

	Command to run on Windows platforms:

	    >DeleteUsers.cmd -u CASE_INSENSITIVE_USERNAME

	Command to run on Unix platforms:

	    >DeleteUsers.sh -u CASE_INSENSITIVE_USERNAME

11- Registration of authentication provider - 

   Registration of new authentication provider (Login Module) needs following information. To get new login module
   registered in the Hub through automation tool, these information should be provided in automation.properties.

   (a) Name of the login module template - Supported templates are MicrosoftActiveDirectory-template, OpenLDAP-template
       and Kerberos-template.

	MDM.security_provider.login_module.template

   (b) Login Module name
	MDM.security_provider.login_module.name

   (c) Login Module description
	MDM.security_provider.login_module.description=

   (d) Whether Login Module is enabled or disabled. The value of property could be yes or no.
	MDM.security_provider.login_module.enabled

   (e) Position of login module
	MDM.security_provider.login_module.position

	Since there are existing login modules in the Hub, by default all the new login modules are being added
	at the end of the list. However, it can be moved to top through this automation tool. The value of this
	property could be either "top" or "bottom". If the property value is top, the login module will be the
	first login module. If the property value is bottom, the login module will be at the end of rest of login modules.
	There are not other position supported through automation tool.

   (f) Total number of provider properties 
	MDM.security_provider.login_module.no_of_properties

	Authentication provider/ Login module could have a few properties. List the number of properties.
	If there are no properties, put the value of MDM.security_provider.login_module.no_of_properties as 0.

   (g) For each login module property, provide the name of the property and its value as below:

	MDM.security_provider.login_module.properties_name#
	MDM.security_provider.login_module.properties_value#

	# is a number between 0 and (MDM.security_provider.login_module.no_of_properties)-1.
	Note: Incase any value has single slash ('\'), replace it with double slash ('\\').

   (h) Run following command to register authentication provider (login module) whose properties are set in
       automation.properties.

	     Command to run on Windows platforms:

	        >AddLoginModule.cmd

	     Command to run on Unix platforms:

	        >AddLoginModule.sh

12- IDD Import and deployment to an existing application

   Today, if IDD application is already deployed and running and if you have an update in a property file or configuration
   file (i.e. BDDConfig.xml or BDDBundle.properties), you have to go to IDD configuration (http://<machine>:<port>/bdd/config
   and import these changes in existing application. Now, with this tool, you can import the changes into existing
   application through command line. The command takes only one kind of change, so if you have multiple changes for an
   application (say change in configuration and change in BDDHelp), then the command needs to be run that many times for
   the application. Below are the usage of the commands. The first argument is the IDD application name. 2nd argument is the
   type of configuration change and the 3rd argument is the name the of file which has the changes.

	IddImportToExistingApp <IDD_application_name> -BDDConfiguration <BDDConfig.xml>
	IddImportToExistingApp <IDD_application_name> -BDDBundle BDDBundle[_locale].properties
	IddImportToExistingApp <IDD_application_name> -MetadataBundle MetadataBundle[_locale].properties
	IddImportToExistingApp <IDD_application_name> -MessagesBundle MessagesBundle[_locale].properties
	IddImportToExistingApp <IDD_application_name> -ErrorCodeBundle ErrorCodeBundle[_locale].properties
	IddImportToExistingApp <IDD_application_name> -BDDHelp BDDHelp[_locale].zip
	IddImportToExistingApp <IDD_application_name> -CustomBDDHelp CustomBDDHelp[_locale].zip
	IddImportToExistingApp <IDD_application_name> -ApplicationLogo logo.gif|logo.jpg|logo.jpeg|logo.png
	IddImportToExistingApp <IDD_application_name> -UserExitsImplementation <UserExitsImplemenation.jar>
	IddImportToExistingApp <IDD_application_name> -DataImportTemplate <data-import-template-config.xml>

    Since this tool makes the changes directly in the master database, credentials for master database are needed. Hence,
    following properties needs to be set in automation.properties before running the command to import configuration changes.
    This operation is supported in Oracle, DB2 and sqlserver databases. The first property to let the tool know the type of database

	MDM.master_database.type

    The value of MDM.master_database.type should be 'oracle', 'db2' or 'sqlserver' depending upon which database is being used.
    For Oracle database following properties needs to be set.

	MDM.master_database.server
	MDM.master_database.portnumber
	MDM.master_database.servicename
	MDM.master_database.username
	MDM.master_database.password

    For db2 database following properties needs to be set.

	MDM.master_database.server
	MDM.master_database.portnumber
	MDM.master_database.dbname
	MDM.master_database.username
	MDM.master_database.password

    where MDM.master_database.dbname represents to db2 database name.

    For sqlserver/mssql database following properties needs to be set.

	MDM.master_database.server
	MDM.master_database.portnumber
	MDM.master_database.dbname
	MDM.master_database.username
	MDM.master_database.password

    where MDM.master_database.dbname represents to sqlserver database name.

    The tool creates some temporary directories and files during its process. Therefore, it needs a temporary directory
    where it can keep temporary directories and files. Once import process is successful, the temporary directory or 
    directories / files under temporary directories can be deleted.

	MDM.temp_directory_name

    Incase you don't want to remove temporary directories and files for debugging purpose, set MDM.delete_temp_directory
    properties to "no" without quotes in automation.properties. If this property is not set or set to any value other than
    "no", then all the temporary files and directories will be deleted.

    Below is the command Command to run on Windows platforms:

	        > IddImportToExistingApp.cmd <IDD_application_name> -<configuration_type> <file_to_be_udpated>

    And, here is the Command to run on Unix platforms:

	        > IddImportToExistingApp.sh <IDD_application_name> -<configuration_type> <file_to_be_udpated>

    Above commands will save all the changes for the application. You need to restart appserver which will validate
    the application and if there is no validation error, it will keep application in deployed state if it was already
    in deployed state before importing the changes.

    If there are validation errors during restart, those needs to be fixed manually through IDD configuration page
    or those should be fixed outside and then can be imported configuration file again using this command line tool.

    In summary, there are three steps to import configuration changes to an existing application:

    (a) Setting of master database credentials in automation.properties.
    (b) Running the IddImportToExistingApp commands for each configuration change in the application.
    (c) Application Server restart

13- IDD Import and deployment as a new application

   Today, new IDD application can be imported and deployed using configuration xml file or using complete application zip
   file through IDD configuration site (http://<machine>:<port>/bdd/config). Now, with this tool, you can import application
   configuration xml file or complete application zip file through command line and deploy it.

   Since this tool makes the changes directly in the master database, credentials for master database are needed. Hence,
   following properties needs to be set in automation.properties before running the command to import configuration changes.
   These properties are same for importing into existing application through command line.

    This operation is supported in Oracle and DB2 databases. The first property to let the tool know the type of database

	MDM.master_database.type

    The value of MDM.master_database.type should be 'oracle', 'db2' or 'sqlserver' depending upon which database is being used.
    For Oracle database following properties needs to be set.

	MDM.master_database.server
	MDM.master_database.portnumber
	MDM.master_database.servicename
	MDM.master_database.username
	MDM.master_database.password

    For db2 database following properties needs to be set.

	MDM.master_database.server
	MDM.master_database.portnumber
	MDM.master_database.dbname
	MDM.master_database.username
	MDM.master_database.password

    where MDM.master_database.dbname represents to db2 database name.

    For sqlserver/mssql database following properties needs to be set.

	MDM.master_database.server
	MDM.master_database.portnumber
	MDM.master_database.dbname
	MDM.master_database.username
	MDM.master_database.password

    where MDM.master_database.dbname represents to sqlserver database name.

    Similar to importing into existing application through command line, the tool creates some temporary directories and 
    files during its process. Therefore, it needs a temporary directory where it can keep temporary directories and files.
    Once import process is successful, the temporary directory or directories / files under temporary directories can be deleted.

	MDM.temp_directory_name

    Incase you don't want to remove temporary directories and files for debugging purpose, set MDM.delete_temp_directory
    properties to "no" without quotes in automation.properties. If this property is not set or set to any value other than
    "no", then all the temporary files and directories will be deleted.

    Below is the command Command to run on Windows platforms:

		> IddDeployment.cmd -config_xml <BDDConfig.xml> -database_id <ors_database_id>
			 or
		> IddDeployment.cmd -config_zip <IDD_application.zip> -database_id <ors_database_id>

    And, here is the Command to run on Unix platforms:

		> IddDeployment.sh -config_xml <BDDConfig.xml> -database_id <ors_database_id>
			 or
		> IddDeployment.sh -config_zip <IDD_application.zip> -database_id <ors_database_id>

    Above command will parse configuration xml file (provided in the command line or get it from zip file) and get application
    name, display name and logical ORS name. If application already exists with same application name, it will report error
    and won't create new application.

    If application doesn't exist, the tool will create new application in the database and deploy it. You need to restart appserver
    which will validate the application and if there is no validation error, IDD will deploy the application and will be in ready
    to use state.

    In summary, there are three steps to import and deploy new application:

    (a) Setting of master database credentials in automation.properties.
    (b) Running the IddDeployment command with either configuration xml file or complete application zip file.
    (c) Application Server restart

14- IDD application export to zip file

   Today, IDD application can be exported through IDD configuration site (http://<machine>:<port>/bdd/config).
   Now, with this tool, you can export application into zip file.

   Since this tool gets application directly from the master database, credentials for master database are needed. Hence,
   following properties needs to be set in automation.properties before running the command to import configuration changes.
   These properties are same for importing into existing application through command line.

    This operation is supported in Oracle and DB2 databases. The first property to let the tool know the type of database

	MDM.master_database.type

    The value of MDM.master_database.type should be 'oracle', 'db2' or 'sqlserver' depending upon which database is being used.
    For Oracle database following properties needs to be set.

	MDM.master_database.server
	MDM.master_database.portnumber
	MDM.master_database.servicename
	MDM.master_database.username
	MDM.master_database.password

    For db2 database following properties needs to be set.

	MDM.master_database.server
	MDM.master_database.portnumber
	MDM.master_database.dbname
	MDM.master_database.username
	MDM.master_database.password

    where MDM.master_database.dbname represents to db2 database name.

    For sqlserver/mssql database following properties needs to be set.

	MDM.master_database.server
	MDM.master_database.portnumber
	MDM.master_database.dbname
	MDM.master_database.username
	MDM.master_database.password

    where MDM.master_database.dbname represents to sqlserver database name.

    Similar to importing into existing application through command line, the tool creates some temporary directories and 
    files during its process. Therefore, it needs a temporary directory where it can keep temporary directories and files.
    Once import process is successful, the temporary directory or directories / files under temporary directories can be deleted.

	MDM.temp_directory_name

    Incase you don't want to remove temporary directories and files for debugging purpose, set MDM.delete_temp_directory
    properties to "no" without quotes in automation.properties. If this property is not set or set to any value other than
    "no", then all the temporary files and directories will be deleted.

    Below is the command Command to run on Windows platforms:

		> IddGetApp.cmd <existing_idd_application_name> <zip_file>

    And, here is the Command to run on Unix platforms:

		> IddGetApp.sh <existing_idd_application_name> <zip_file>


15- Control over logging in automation tool

    Automation tool is using log4j for logging purpose. There are five different kinds of logging which are DEBUG, INFO,
    WARNING, ERROR and FATAL. 

    FATAL logging is being in command line usage errors. If command line is not correct or if all required arguments are
	not there in the command, then tool will give FATAL errors.

    ERROR logging is being used when there is an error during the processing. The tool will also give clear message with 
	"FAILED: <message>".

    WARNING logging is being used for warnings. Even if everything is successful, there could be some warnings.
	These warnings are mostly harmless, but suggestion is to check for warnings even if tool ran successfully.

    INFO logging is being used when tool is successful. At the end when everything is successful, Then there is a
	"SUCCESSFUL: <message>".

    DEBUG logging is being used for debugging purpose such as which EJB is being called, whether connection is successful,
	name of temporary filename and so on.

    Below is the default setting of log4j.properties. This file is packaged inside MDMAutomation.jar. By default, logging
    is set to INFO level for log file and console. It is recommended to have at least WARN level setting.
    By default log file is MDMAutomation.log which will be created in the current directory. Once file size reaches to 10 MB,
    it will roll to MDMAutomation.log.1. The rolling is set to five times.

    -----------------------------------------------------------------------------------------------------
	log4j.rootLogger=info, stdout, file

	log4j.appender.stdout=org.apache.log4j.ConsoleAppender
	log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
	log4j.appender.stdout.layout.ConversionPattern=[%d{ISO8601}] [%t] [%-5p] %c: %m%n

	log4j.appender.file=org.apache.log4j.RollingFileAppender
	log4j.appender.file.File=MdmAutomation.log
	log4j.appender.file.MaxFileSize=10MB
	log4j.appender.file.MaxBackupIndex=5
	log4j.appender.file.layout=org.apache.log4j.PatternLayout
	log4j.appender.file.layout.ConversionPattern=[%d{ISO8601}] [%t] [%-5p] %c: %m%n
    -----------------------------------------------------------------------------------------------------

    In case you want to change above settings say log level, copy log4.properties MDMAutomation.jar to somewhere in your machine,
    make the changes and replace the file in MDMAutomation.jar.

16- User Synchronization through a LDAP server

    There are two scenarios in user synchronization through LDAP server. One scenario is where MDM users for roles are being
    maintained in a LDAP server and you want to synchronize users for roles in ORS database. The other scenario is where MDM users for
    user groups are being maintained in a LDAP server and users need to be synchronized for user group in ORS database.

    This script can be used for both of above scenarios. This tool should work with any LDAP server.

    LdapConnection.cmd on windows and LdapConnection.sh on Unix can be used to check the connection for LDAP server from the script.
    LDAP server connection requires following properties in automation.properties:

	LDAP.Server
	LDAP.Username
	LDAP.Password

    Incase, LDAP server search is not secure and can be connected without username and password, LDAP.Username and LDAP.Password
    properties are not needed.

	Command to check LDAP sever connection on windows platforms:

		> LdapConnection.cmd

	Command to check LDAP sever connection on UNIX platforms:

		> LdapConnection.sh

    Above command can also be used to search an entity in LDAP. LDAP entity (i.e. has cn=cmx_ors_datasteward_role,dc=example,dc=com)
    has two parts: entity distinguished name say cn=cmx_ors_datasteward_role and base say dc=example,dc=com. To search an entity
    through above command and for user synchronization from LDAP to MDM, following search base needs to be provided in
    automation.properties:

	LDAP.SearchBase

	Command to search an entity in LDAP sever on windows platforms:

		> LdapConnection.cmd -search <entity_name>

	Command to search an entity in LDAP sever on UNIX platforms:

		> LdapConnection.sh -search <entity_name>

   Scenario 1: User synchronization to ORS Roles through a LDAP server

    LdapUserSynchronization for Roles has 2 modes -
    
    Batch Sync (default) - allows adding/synchronizing all the users assigned to a group or role in your LDAP server to MDM. 

    Single User Sync (Roles only)- allows adding a single user that exists in your LDAP server role to MDM.
    
    For user synchronization from LDAP server to MDM roles, your LDAP server should already have users and roles. Roles should also
    have attributes for users. There can be more than one user in a role's attribute. The tool can Synchronize users from LDAP
    server to MDM for multiple ORSes in one command. Make sure that roles are already created in MDM, and you already know
    which role in LDAP is corresponding to which role in MDM. This tool will not create roles in MDM.

    Since users can be Synchronized for multiple ORSes through one command, information for all the ORSes needed in
    automation.properties. The automation.properties file contains sample properties to help you configure the file.

    (a) Edit the following property to provide the number of roles in all the ORSes for which you want to synchronize users:
	
	LDAP.number.of.ldaproles

    (b) For each ORS roles you want to synchronize users, edit the following properties for rolename in LDAP, LDAP role's attribute
	name for users, corresponding ORS's database id and corresponding ORS's rolename.

	LDAP.rolename.for.ldap.search#
	LDAP.role.attribute_name.for.userlist#
	LDAP.MDM.ORS.databaseId#
	LDAP.MDM.rolename#

	# is a number between 0 and (LDAP.number.of.ldaproles)-1.

	(c) If you want to synchronize user's first name, middle name and last name from LDAP to MDM, edit following properties.
	These properties are the attribute name in user for first name, middle name and last name. If attribute name is not available for 
	any of these, then leave the value of that property as blank.
	
	LDAP.attribute_name.for.user.firstname
	LDAP.attribute_name.for.user.middlename
	LDAP.attribute_name.for.user.lastname
	
	If you want to use another attribute for the username besides CN or uid, such as sAMAccountName, set the attribute to use here:
	LDAP.attribute_name.for.username
	
	If you want to strip backslashes (\) from usernames, add and set the following in automation.properties:
	LDAP.strip_slashes_from_usernames=true
	
	If you want to use an attribute for the user's email in MDM, set the attribute to use here:
    LDAP.attribute_name.for.user.email
	
    (d) Batch Sync - Run following command to synchronize users from LDAP server roles to MDM roles 

	Command to run on Windows platforms:

	    > LdapUserSynchronization.cmd

	Command to run on Unix platforms:

	    > LdapUserSynchronization.sh
    
    (d2) Single User Sync - Run following command to synchronize a single user from LDAP server roles to MDM roles

	Command to run on Windows platforms:

	    > LdapUserSynchronization.cmd -u CASE_SENSITIVE_USERNAME -admin true/false

	Command to run on Unix platforms:

	    > LdapUserSynchronization.sh -u CASE_SENSITIVE_USERNAME -admin true/false   
        

    (e) By default as a part of cleanup process, user synchronization process either unassigns all the users OR a single user (if -u is 
        passed) from ORS before assigning them to ORS and roles. In case, you don't want users to get unassigned from ORS and from 
        existing roles, set the following property before running LdapUserSynchronization.cmd or LdapUserSynchronization.sh.

	LDAP.cleanup.before.sync=false

     Note: If a user has been removed from LDAP or if all the roles have been revoked from the user, then this synchronization doesn't
           remove user from MDM. You need to manually remove the user from MDM.


   Scenario 2: User synchronization to ORS User Groups through a LDAP server

    For user synchronization from LDAP server to MDM User Groups, your LDAP server should already have users and groups. Groups should also
    have attributes for users. There can be more than one user in a group's attribute. The tool can Synchronize users from LDAP
    server to MDM for multiple ORSes in one command. Make sure that groups are already created in MDM, and you already know
    which group in LDAP is corresponding to which group in MDM. This tool will not create groups in MDM.

    Since users can be Synchronized for multiple ORSes through one command, information for all the ORSes needed in
    automation.properties. The automation.properties file contains sample properties to help you configure the file.

    (a) Edit the following property to provide the number of roles in all the ORSes for which you want to synchronize users:
	
	LDAP.number.of.ldapgroups

    (b) For each ORS roles you want to synchronize users, edit the following properties for rolename in LDAP, LDAP role's attribute
	name for users, corresponding ORS's database id and corresponding ORS's rolename.

	LDAP.groupname.for.ldap.search#
	LDAP.group.attribute_name.for.userlist#
	LDAP.MDM.ORS.group.databaseId#
	LDAP.MDM.groupname#

	# is a number between 0 and (LDAP.number.of.ldapgroups)-1.

	(c) If you want to synchronize user's first name, middle name and last name from LDAP to MDM, edit following properties.
	These properties are the attribute name in user for first name, middle name and last name. If attribute name is not available for 
	any of these, then leave the value of that property as blank.
	
	LDAP.attribute_name.for.user.firstname
	LDAP.attribute_name.for.user.middlename
	LDAP.attribute_name.for.user.lastname
	
    (d) Run following command to synchronize users from LDAP server groups to MDM groups

	Command to run on Windows platforms:

	    > LdapGroupSynchronization.cmd

	Command to run on Unix platforms:

        > LdapGroupSynchronization.sh

    (e) By default as a part of cleanup process, group user synchronization process unassigns all the users from ORS before assiging them 
        to ORS and group. Incase, you don't want get users to get unassgined from ORS and from existing groups, set following properties
        before running LdapUserSynchronization.cmd or LdapUserSynchronization.sh.

	LDAP.cleanup.before.sync=false

     Note: If a user has been removed from LDAP or if the user has been removed from all the groups, then this synchronization doesn't
           remove user from MDM. You need to manually remove the user from MDM.

16- Location of automation.properties

	When you unzip MDMAutomation.zip in an empty directory, you will get automation.properties along with other 
	automation files. It is recommended to update this property file for all the changes needed. For some reason,
	if the location of property file is somewhere else or the name of the property file is something else, then
	set system variable MDM.MISC_AUTOMATION_TOOL.AUTOMATION_PROP_FILE with complete directory and name of the property
	file.

General Note: While using this automation tool against JBOss EAP 6.1/6.4, JBoss will report following type of information and error
at the end of the logging after SUCCESSFUL logging message. This information and error message is harmless and should be ignored.

[2013-08-31 18:49:48,075] [Remoting "config-based-naming-client-endpoint" task-3] [INFO ] org.jboss.ejb.client.remoting: EJBCLIENT000016: Channel Channel ID 8b1ec6fe (outbound) of Remoting connection 7636d59a to localhost/127.0.0.1:4447 can no longer process messages
[2013-08-31 18:49:48,078] [Remoting "config-based-naming-client-endpoint" task-1] [ERROR] org.jboss.naming.remote.protocol.v1.RemoteNamingStoreV1: Channel end notification received, closing channel Channel ID 957d65e5 (outbound) of Remoting connection 7636d59a to localhost/127.0.0.1:4447

That's it.

