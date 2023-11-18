/***********************************************************************************************************
 * Name: ES_ResourceAvailabilitySchedulerTest
 * Test Class for: ES_CreateResourceAvailability (86%)
 *                 ES_ResourceAvailabilityScheduler (100%)
 ***********************************************************************************************************/
@isTest 
Public class ES_ResourceAvailabilitySchedulerTest{
    /*****************************************************************
     * Method Name : updateUserTestCase
     * Description : Test method for unit testing process automation written on User
     * **************************************************************/
    static testMethod void updateUserTestCase(){       
            User testUser = ES_Testcoverage.createUser('System Administrator', new List<String>{'ES_Resource_Planner'});
            System.runAs(testUser){
                Profile standardprofile = [SELECT Id FROM Profile WHERE Name='Standard User'];
                
                User ESUsr = new User(Alias = 'ES', Email='ESUser@testClass.com', 
                EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = standardprofile.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='ESUser@testClass.com', IsActive = true);
                INSERT ESUsr;
            
            
                Test.startTest();
                ES_CreateResourceAvailability.createRAOnUserInsert(new List<Id>{ESUsr.Id});
                Test.stopTest();
                List<ES_Resource_Availability__c> lstOfResourceAvailability = [SELECT id FROM ES_Resource_Availability__c WHERE User__c =: ESUsr.Id];
                System.assertEquals(lstOfResourceAvailability.size()>0 , true, 'Resource availability should be created for user.');
           }     
          
    }
    
    /*****************************************************************
     * Method Name : updateUserTestCase
     * Description : Test method for unit testing scheduler which creates Resource availability for all ES users
     * **************************************************************/
    static testMethod void apexSchedulerTestCase(){
   
            Profile standardprofile = [SELECT Id FROM Profile WHERE Name='Standard User'];
            
            User ESUsr = new User(Alias = 'ES', Email='ESUser@testClass.com', 
            EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = standardprofile.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='ESUser@testClass.com', IsActive = true, Department='Sales', Is_ES_User_consider_for_Availability__c = true);
            INSERT ESUsr;
            
            User testUser = ES_Testcoverage.createUser('Standard User', new List<String>{'ES_Resource_Planner'});
            System.runAs(testUser){
                Test.startTest();             
                    ES_ResourceAvailabilityScheduler scheduler = new ES_ResourceAvailabilityScheduler();
                    scheduler.execute(null);            
                Test.stopTest();
                List<ES_Resource_Availability__c> lstOfResourceAvailability = [SELECT id FROM ES_Resource_Availability__c WHERE User__c =: ESUsr.Id];
                System.assertEquals(lstOfResourceAvailability.size()>0 , true, 'Resource availability should be created for user.');
            }
           
    }
}