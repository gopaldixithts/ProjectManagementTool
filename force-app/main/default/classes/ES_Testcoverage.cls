/***************************************************************************************************************************************************************************************
* Name: ES_Testcoverage
* Test class for: ES_InspectionSummaryCtrl (85%)
                  ES_Utility (96%)
                  ES_ResourceManagementCtrl (93%)  
* Release 1.0 - Fixed the getResourceDetailsWrapperTestCase() test method failure due to Fiscal Year mismatch between Inspection(FY23) & Availability Records(FY23)
****************************************************************************************************************************************************************************************/
@isTest
public class ES_Testcoverage {
 
    @testSetup static void setup(){
        User testUser = ES_Testcoverage.createUser('Standard User', new List<String>{'ES_User'});
        User testRPUser = ES_Testcoverage.createUser('Standard User', new List<String>{'ES_Resource_Planner'});
        User adminUser = ES_Testcoverage.createUser('System Administrator', new List<String>{'ES_User'});
        system.runAs(adminUser){
        List<ES_Phase__c> lstOfPhases = new List<ES_Phase__c>();
        List<ES_Task__c> lstOfTasks = new List<ES_Task__c>();
        Integer resourceAvailability = Integer.valueOf(ES_Utility.getESSettings('Default').Default_Availability_for_Scheduler__c);
        
<<<<<<< HEAD
<<<<<<< HEAD
    //Create Inspection
        Inspection__c Inspection = new Inspection__c(
                                                    Name = 'Inspection Controller Test', 
=======
    //Create Project
        Inspection__c project = new Inspection__c(
                                                    Name = 'Project Controller Test', 
>>>>>>> 01eee72 (Change2)
=======
    //Create Inspection
        Inspection__c Inspection = new Inspection__c(
                                                    Name = 'Inspection Controller Test', 
>>>>>>> 3dc5bb9 (change10)
                                                    Portfolio__c = 'R2R',
                                                    Initial_End_Date__c = System.today()+30,
                                                    Initial_Start_Date__c = System.today(),
                                                    ownerId = testRPUser.Id,
                                                    Level_of_Effort__c = 'Small');
                                                    
        INSERT Inspection;
        
    //Create Phases
        ES_Phase__c phase1 = new ES_Phase__c( Name = 'Phase 1',
                                                Inspection__c = Inspection.Id);
        
        lstOfPhases.add(phase1);
       
        ES_Phase__c phase2 = new ES_Phase__c( Name = 'Phase 2',
                                                Inspection__c = Inspection.Id);
        
        lstOfPhases.add(phase2);
        INSERT lstOfPhases;
        
    //Create Tasks
        ES_Task__c task1 = new ES_Task__c(
                                            Name = 'Late Task 1', 
                                            Status__c = 'In Progress',
                                            Start_Date__c = System.today()-40, 
                                            Due_Date__c = System.today()-10, 
                                            Is_Milestone__c = true,
                                            Phase__c = lstOfPhases[0].Id); 
        lstOfTasks.add(task1);
        
        ES_Task__c task2 = new ES_Task__c(
                                        Name ='Late Task 2', 
                                        Status__c = 'In Progress',
                                        Start_Date__c = System.today()-40, 
                                        Due_Date__c = System.today()-10, 
                                        Is_Milestone__c = false,
                                        Phase__c = lstOfPhases[1].Id); 
        lstOfTasks.add(task2);

        ES_Task__c task3 = new ES_Task__c(
                                        Name = 'Current Task 1', 
                                        Status__c = 'Completed',
                                        Start_Date__c = System.today()-15, 
                                        Due_Date__c = System.today(), 
                                        Is_Milestone__c = false, 
                                        Phase__c = lstOfPhases[0].Id);
        lstOfTasks.add(task3);
        
        ES_Task__c task4 = new ES_Task__c(
                                        Name = 'Current Task 2', 
                                        Status__c = 'Completed',
                                        Start_Date__c = System.today(), 
                                        Due_Date__c = System.today()+10, 
                                        Is_Milestone__c = false, 
                                        Phase__c = lstOfPhases[1].Id);
        lstOfTasks.add(task4);
        INSERT lstOfTasks;
        
        //Availability record
            ES_Resource_Availability__c resAvailwithUser = new ES_Resource_Availability__c( User__c = testUser.Id,
                                                                                     Fiscal_Year__c = 'FY22',
                                                                                     Jan__c = resourceAvailability, Feb__c = resourceAvailability, 
                                                                                     Mar__c = resourceAvailability, Apr__c = resourceAvailability, 
                                                                                     May__c = resourceAvailability, Jun__c = resourceAvailability, 
                                                                                     Jul__c = resourceAvailability, Aug__c = resourceAvailability, 
                                                                                     Sep__c = resourceAvailability, Oct__c = resourceAvailability,
                                                                                     Nov__c = resourceAvailability, Dec__c = resourceAvailability);
            INSERT resAvailwithUser;
        
            ES_Resource_Availability__c resAvailWOUSer = new ES_Resource_Availability__c(Fiscal_Year__c = 'FY22',
                                                                                     Jan__c = resourceAvailability, Feb__c = resourceAvailability, 
                                                                                     Mar__c = resourceAvailability, Apr__c = resourceAvailability, 
                                                                                     May__c = resourceAvailability, Jun__c = resourceAvailability, 
                                                                                     Jul__c = resourceAvailability, Aug__c = resourceAvailability, 
                                                                                     Sep__c = resourceAvailability, Oct__c = resourceAvailability,
                                                                                     Nov__c = resourceAvailability, Dec__c = resourceAvailability);
            INSERT resAvailWOUSer;
        
         //Allocation records
             ES_Resource_Allocation__c resAllocation = new ES_Resource_Allocation__c(Inspection__c = Inspection.Id,
                                                                                          Resource_Availability__c = resAvailwithUser.Id,
                                                                                          Role__c = 'SME' ); 
            INSERT resAllocation;
        
        
        //Create Cases for ES Inspection
            List<case> lstOfCases = new List<Case>();
            Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(System.Label.ES_Inspection_Record_Type_on_Case).getRecordTypeId();
            for(Integer i=0; i<10; i++){
<<<<<<< HEAD
<<<<<<< HEAD
                lstOfCases.add(new Case(ownerId = testUser.Id,Subject='test case', RecordTypeId = caseRecordTypeId, Inspection__c = Inspection.Id));            
=======
                lstOfCases.add(new Case(ownerId = testUser.Id,Subject='test case', RecordTypeId = caseRecordTypeId, Inspection__c = project.Id));            
>>>>>>> 01eee72 (Change2)
=======
                lstOfCases.add(new Case(ownerId = testUser.Id,Subject='test case', RecordTypeId = caseRecordTypeId, Inspection__c = Inspection.Id));            
>>>>>>> 3dc5bb9 (change10)
            }
            INSERT lstOfCases;
        }
        
    }
    
    /*****************************************************************************************
    * Method Name: getSummaryWrapperTestCase
    * Class : ES_InspectionSummaryCtrl
    * Description: Test method for getSummaryWrapper apex method which return wrapper of related phases and tasks
    * *****************************************************************************************/  
    static testmethod void getSummaryWrapperTestCase(){  
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
<<<<<<< HEAD
<<<<<<< HEAD
            Inspection__c InspectionRec = [SELECT Id FROM Inspection__c LIMIT 1];
=======
            Inspection__c projectRec = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 01eee72 (Change2)
=======
            Inspection__c InspectionRec = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 3dc5bb9 (change10)
            
            Test.startTest();
            ES_InspectionSummaryCtrl.createSummaryWrapper wrapperObj = ES_InspectionSummaryCtrl.getSummaryWrapper(InspectionRec.Id);
            Test.stopTest();
            system.assertEquals(2, wrapperObj.phasesList.size(),'Check the size of the phase list');
            system.assertEquals(2, wrapperObj.lateTaskList.size(),'Check the size of the late task list');  
            system.assertEquals(2, wrapperObj.onGoingTaskList.size(),'Check the size of the onGoing task list');
            system.assertEquals(1, wrapperObj.milestoneTaskList.size(),'Check the size of the milestone task list'); 
        }
    }
        
    /*****************************************************************************************
    * Method Name: getCasesForInspectionTestCase
    * Class : ES_Utility
    * Description: Test method for getCasesForInspection apex method which Search for cases related to Inspection
    * *****************************************************************************************/   
    static testmethod void getCasesForInspectionTestCase(){    
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
<<<<<<< HEAD
<<<<<<< HEAD
            Inspection__c InspectionRec = [SELECT Id FROM Inspection__c LIMIT 1];
=======
            Inspection__c projectRec = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 01eee72 (Change2)
=======
            Inspection__c InspectionRec = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 3dc5bb9 (change10)
            Test.startTest();
                List<Case> lstOfResult = ES_Utility.getCasesForInspection(InspectionRec.Id);
            Test.stopTest();
            system.assertEquals(10, lstOfResult.size(), 'There must be 10 cases related to Inspection.');
        }
    }
    
    /*****************************************************************************************
    * Method Name: getESSettingsTest
    * Class : ES_Utility
    * Description: Test method for getESSettings apex method which Search for cases related to Inspection
    * *****************************************************************************************/   
    static testmethod void getESSettingsTest(){    
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
<<<<<<< HEAD
<<<<<<< HEAD
            Inspection__c InspectionRec = [SELECT Id FROM Inspection__c LIMIT 1];
=======
            Inspection__c projectRec = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 01eee72 (Change2)
=======
            Inspection__c InspectionRec = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 3dc5bb9 (change10)
            Test.startTest();
                ES_Setting__mdt setting = ES_Utility.getESSettings('Test');
            Test.stopTest();
            system.assertNotEquals(null, setting, 'A setting should be returned even if not found with the name test');
        }
    }
    
    
    /*****************************************************************************************
    * Method Name: getAllocationsForResourceTestCase
    * Class : ES_ResourceManagementCtrl
    * Description: Test method for getAllocationsForResource apex method which Search for resource availability on allocations
    * *****************************************************************************************/    
    static testmethod void getAllocationsForResourceTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            ES_Resource_Availability__c resource = [SELECT Id FROM ES_Resource_Availability__c WHERE User__c !=''];
            
            Test.startTest();
            ES_ResourceManagementCtrl.AvailabilityWrapper wrapper = ES_ResourceManagementCtrl.getAllocationsForResource(resource.Id, 'FY22');
            Test.stopTest();
            system.assertEquals(1, wrapper.resourceAvailabilities.size(), 'There should be 1 availability present.');
        }
    }
    
    /*****************************************************************************************
    * Method Name: updateAllocationsTestCase
    * Class : ES_ResourceManagementCtrl
    * Description: Test method for updateAllocations apex method which updates resource allocation record
    * *****************************************************************************************/    
    static testmethod void updateAllocationsTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESRPUsr' and LastName='Last' limit 1];
        System.runAs(testUser){
            ES_Resource_Allocation__c resource = [SELECT Id, Jan__c FROM ES_Resource_Allocation__c WHERE UserId__c != ''];
            resource.Jan__c = 50;
            
            Test.startTest();
            List<ES_Resource_Allocation__c> lstOfResult = ES_ResourceManagementCtrl.updateAllocations(new List<ES_Resource_Allocation__c>{resource});
            ES_Resource_Allocation__c resourceUpdated = [SELECT Id, Jan__c FROM ES_Resource_Allocation__c WHERE Id =: resource.Id];
            Test.stopTest();
            system.assertEquals(50, resourceUpdated.Jan__c, 'Jan allocation must be updated.');
        }
    }
    
    /*****************************************************************************************
    * Method Name: deleteRecordTestCase
    * Class : ES_ResourceManagementCtrl
    * Description: Test method for deleteRecord apex method which deletes sObject record
    * *****************************************************************************************/    
    static testmethod void deleteRecordTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESRPUsr' and LastName='Last' limit 1];
        System.runAs(testUser){
            ES_Resource_Allocation__c resource = [SELECT Id, Jan__c FROM ES_Resource_Allocation__c WHERE UserId__c != ''];
            
            Test.startTest();
            Boolean result = ES_ResourceManagementCtrl.deleteRecord(resource);
            Test.stopTest();
            system.assertEquals(true, result, 'Allocation must be deleted.');
        }
    }
    
    /*****************************************************************************************
    * Method Name: deleteRecordNegTestCase
    * Class : ES_ResourceManagementCtrl
    * Description: Negative Test method for deleteRecord apex method which deletes sObject record
    * *****************************************************************************************/    
    static testmethod void deleteRecordNegTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESRPUsr' and LastName='Last' limit 1];
        System.runAs(testUser){
<<<<<<< HEAD
<<<<<<< HEAD
            Inspection__c Inspection = [SELECT Id FROM Inspection__c LIMIT 1];
=======
            Inspection__c project = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 01eee72 (Change2)
=======
            Inspection__c Inspection = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 3dc5bb9 (change10)
            ES_Resource_Availability__c resAvail = [SELECT Id FROM ES_Resource_Availability__c LIMIT 1]; 
            //Allocation records
            ES_Resource_Allocation__c resAllocation = new ES_Resource_Allocation__c(Inspection__c = Inspection.Id,
                                                                                      Resource_Availability__c = resAvail.Id,
                                                                                      Role__c = 'SME' ); 
            
            Test.startTest();
            Boolean result = ES_ResourceManagementCtrl.deleteRecord(resAllocation);
            Test.stopTest();
            system.assertEquals(false, result, 'Allocation must be deleted.');
        }
    }
    
    
    /*****************************************************************************************
    * Method Name: upsertDeleteAllocationTestCase
    * Class : ES_ResourceManagementCtrl
    * Description: Test method for upsertDeleteAllocation apex method which deletes and upserts new allocations
    * *****************************************************************************************/    
    static testmethod void upsertDeleteAllocationTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESRPUsr' and LastName='Last' limit 1];
        System.runAs(testUser){
<<<<<<< HEAD
<<<<<<< HEAD
            Inspection__c Inspection = [SELECT Id FROM Inspection__c LIMIT 1];
=======
            Inspection__c project = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 01eee72 (Change2)
=======
            Inspection__c Inspection = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 3dc5bb9 (change10)
            ES_Resource_Availability__c resAvail = [SELECT Id FROM ES_Resource_Availability__c LIMIT 1]; 
            //Allocation records
            ES_Resource_Allocation__c resAllocation = new ES_Resource_Allocation__c(Inspection__c = Inspection.Id,
                                                                                      Resource_Availability__c = resAvail.Id,
                                                                                      Role__c = 'IT' );
            
            ES_Resource_Allocation__c resAllToDelete = [SELECT Id FROM ES_Resource_Allocation__c WHERE Resource_Availability__c =: resAvail.Id];
            
            Test.startTest();
            ES_ResourceManagementCtrl.upsertDeleteAllocation(new List<SObject>{resAllocation}, new List<SObject>{resAllToDelete}, Inspection);
            ES_Resource_Allocation__c resAllInserted = [SELECT Id, Role__c FROM ES_Resource_Allocation__c WHERE Resource_Availability__c =: resAvail.Id];
            Test.stopTest();
            System.assertEquals('IT', resAllInserted.Role__c, 'Role of allocation should be IT.');
        }
    }
    
    /*****************************************************************************************
    * Method Name: getResourceDetailsWrapperTestCase
    * Class : ES_ResourceManagementCtrl
    * Description: Test method for getResourceDetailsWrapper apex method which search for availabilities, allocations
    * *****************************************************************************************/    
    static testmethod void getResourceDetailsWrapperTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
<<<<<<< HEAD
<<<<<<< HEAD
            Inspection__c Inspection = [SELECT Id,Start_Fiscal_Year__c,End_Fiscal_Year__c FROM Inspection__c LIMIT 1];
            system.debug(Inspection);
            system.debug([select id, Inspection__r.name from ES_Resource_Allocation__c]);
=======
            Inspection__c project = [SELECT Id,Start_Fiscal_Year__c,End_Fiscal_Year__c FROM Inspection__c LIMIT 1];
            system.debug(project);
            system.debug([select id, project__r.name from ES_Resource_Allocation__c]);
>>>>>>> 01eee72 (Change2)
=======
            Inspection__c Inspection = [SELECT Id,Start_Fiscal_Year__c,End_Fiscal_Year__c FROM Inspection__c LIMIT 1];
            system.debug(Inspection);
            system.debug([select id, Inspection__r.name from ES_Resource_Allocation__c]);
>>>>>>> 3dc5bb9 (change10)
            system.debug([select id, User__r.name from ES_Resource_Availability__c]);
            system.debug([select id, User__r.name from ES_Resource_Availability__c]);
            
            //Release 1.0 Start - Fixed this test method failure due to fiscal year of availability records are in FY22 but Inspection fiscal year is in FY23 
            ES_Resource_Availability__c availability = [select id, User__r.name from ES_Resource_Availability__c where User_Name__c!='' AND User_IsActive__c=true];
            availability.fiscal_year__c = Inspection.Start_Fiscal_Year__c;
            update availability;
            
            ES_Resource_Availability__c dummyAvailability = [select id, User__r.name from ES_Resource_Availability__c where User__c=''];
            dummyAvailability.fiscal_year__c = Inspection.Start_Fiscal_Year__c;
            update dummyAvailability;
            //Release 1.0 End //
            
            Test.startTest();
            ES_ResourceManagementCtrl.ResourceDetail resDetails = ES_ResourceManagementCtrl.getResourceDetailsWrapper(Inspection);
            system.debug(resDetails);
            system.assertEquals(1, resDetails.ResourceAllocations.size(), '1 allocation should be found');
            system.assertEquals(1, resDetails.ResourceAvailabilities.size(), '1 availability should be found');
            system.assertEquals(1, resDetails.dummyAvailabilities.size(), '1 Dummy availability should be found');
            Test.stopTest();
        }
    }
    
    /*****************************************************************************************
    * Method Name: getFiltersTest
    * Class : ES_ResourceManagementCtrl
    * Description: Test method for getFilters apex method which returns picklist filters
    * *****************************************************************************************/    
    static testmethod void getFiltersTest(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            Test.startTest();
            List<List<String>> filters= ES_ResourceManagementCtrl.getFilters();
            system.assertEquals(3, filters.size(), '2 filters departments and years + fiscal year offset should be found');
            system.assert(filters[0].size()>0, 'More than 1 dept filter should be found');
            system.assertEquals(1, filters[1].size(), '1 year should be found');
            Test.stopTest();
        }
    }
    
    /*****************************************************************************************
    * Method Name: getResourceAllocationsTest1
    * Class : ES_ResourceManagementCtrl
    * Description: Test method for getResourceAllocations apex method which returns picklist filters
    * *****************************************************************************************/    
    static testmethod void getResourceAllocationsTest1(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        String department = [select Department from User where id = :userInfo.getUserId() limit 1].Department;
        System.runAs(testUser){
            Test.startTest();
<<<<<<< HEAD
<<<<<<< HEAD
            Inspection__c Inspection = [SELECT Id,Start_Fiscal_Year__c,End_Fiscal_Year__c FROM Inspection__c LIMIT 1];
            ES_ResourceManagementCtrl.ResourceDataWrapper wrapper = ES_ResourceManagementCtrl.getResourceAllocations('FY22',department , null, null, Inspection.Id);
=======
            Inspection__c project = [SELECT Id,Start_Fiscal_Year__c,End_Fiscal_Year__c FROM Inspection__c LIMIT 1];
            ES_ResourceManagementCtrl.ResourceDataWrapper wrapper = ES_ResourceManagementCtrl.getResourceAllocations('FY22',department , null, null, project.Id);
>>>>>>> 01eee72 (Change2)
=======
            Inspection__c Inspection = [SELECT Id,Start_Fiscal_Year__c,End_Fiscal_Year__c FROM Inspection__c LIMIT 1];
            ES_ResourceManagementCtrl.ResourceDataWrapper wrapper = ES_ResourceManagementCtrl.getResourceAllocations('FY22',department , null, null, Inspection.Id);
>>>>>>> 3dc5bb9 (change10)
            system.assertEquals(1, wrapper.resourceAvailabilities.size(), '1 availability should be found');
            system.assertEquals(1, wrapper.resourceAllocations.size(), '1 resourceAllocations should be found');
            Test.stopTest();
        }
    }
    
    /*****************************************************************************************
    * Method Name: getResourceAllocationsTest2
    * Class : ES_ResourceManagementCtrl
    * Description: Test method for getResourceAllocations apex method which returns picklist filters
    * *****************************************************************************************/    
    static testmethod void getResourceAllocationsTest2(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            Test.startTest();
            ES_ResourceManagementCtrl.ResourceDataWrapper wrapper = ES_ResourceManagementCtrl.getResourceAllocations('FY22', 'A'+System.currentTimeMillis() , null, null, null);
            system.assertEquals(0, wrapper.resourceAvailabilities.size(), 'No availabilities should be found');
            system.assertEquals(0, wrapper.resourceAllocations.size(), 'No resourceAllocations should be found');
            Test.stopTest();
        }
    }
    
    /*****************************************************************************************
    * Method Name: testInstallScript
    * Class : ES_InstallHandler
    * Description: Test method for getResourceAllocations apex method which returns picklist filters
    * *****************************************************************************************/ 
    @isTest
    static void testInstallScript() {
        ES_InstallHandler installHandlerScript = new ES_InstallHandler();
        Test.testInstall(installHandlerScript, null);
        Test.startTest();
        List<ES_Program__c> programs = [select id from ES_Program__c];
<<<<<<< HEAD
<<<<<<< HEAD
        List<Inspection__c> Inspections = [select id from Inspection__c];
=======
        List<Inspection__c> projects = [select id from Inspection__c];
>>>>>>> 01eee72 (Change2)
=======
        List<Inspection__c> Inspections = [select id from Inspection__c];
>>>>>>> 3dc5bb9 (change10)
        List<ES_Phase__c> phases = [select id from ES_Phase__c];
        List<ES_Task__c> tasks = [select id from ES_Task__c];
        List<ES_Resource_Availability__c> avails = [select id from ES_Resource_Availability__c];
        List<ES_Resource_Allocation__c> allocs = [select id from ES_Resource_Allocation__c];
        System.assert(programs.size()>0, 'Program records should be present');
        System.assert(Inspections.size()>0, 'Inspection records should be present');
        System.assert(phases.size()>0, 'Phase records should be present');
        System.assert(tasks.size()>0, 'Task records should be present');
        System.assert(avails.size()>0, 'Availability records should be present');
        System.assert(allocs.size()>0, 'Allocation records should be present');
        Test.stopTest();
    }

    /*****************************************************************************
     * Name : createUser
     * Description : Method to create User with permission sets assigned
     * Parameters : Profile name which to be assigned to new user and list of permission sets assigned to him
     * Output : User record  
     * **************************************************************************/
    public static User createUser(String profileName, List<String> lstOfPermissionSets){
        List<PermissionSetAssignment> lstOfPSA = new List<PermissionSetAssignment>();
        String userName = lstOfPermissionSets.contains('ES_Resource_Planner')?'ESRPUsr':'ESUser';
        String userEmail = userName + Math.random()+'@test.com.invalid';        
        User userRecord;       
        
        Id profileId = [SELECT Id FROM Profile WHERE Name =:profileName limit 1].Id;
        userRecord = new User(
            profileId = profileId,
            LastName = 'last',
            Email = userEmail,
            Username = userName +'@testOrg.' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = userName,
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        INSERT userRecord;
        
        for(PermissionSet psRec : [SELECT Id FROM PermissionSet WHERE Name IN: lstOfPermissionSets]){
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = userRecord.Id, PermissionSetId = psRec.Id);
            lstOfPSA.add(psa);
        }                        
        INSERT lstOfPSA; 
            
        return userRecord;
    }
}