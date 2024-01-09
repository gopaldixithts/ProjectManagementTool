/*************************************************
* Name: ES_TaskandPhaseManagementCtrlTest
* Test class for : ES_TaskandPhaseManagementCtrl (84%)
* ***********************************************/
@isTest
public class ES_TaskandPhaseManagementCtrlTest {
    @testSetup static void setup(){
        User testUser = ES_Testcoverage.createUser('Standard User', new List<String>{'ES_User'});
        User adminUser = ES_Testcoverage.createUser('System Administrator', new List<String>{'ES_User'});
        system.runAs(adminUser){
            List<ES_Task__c> lstOfTasks = new List<ES_Task__c>();
            Integer resourceAvailability = Integer.valueOf(ES_Utility.getESSettings('Default').Default_Availability_for_Scheduler__c);
            
<<<<<<< HEAD
            //ES Inspection record
            Inspection__c Inspection = new Inspection__c(Name='Inspection Controller Test', 
=======
            //ES project record
            Inspection__c project = new Inspection__c(Name='Project Controller Test', 
>>>>>>> 01eee72 (Change2)
                                                        Portfolio__c='R2R',
                                                        Initial_End_Date__c=System.today()+30,
                                                        Initial_Start_Date__c=System.today(),
                                                       Level_of_Effort__c = 'Small');
            INSERT Inspection;
            
            //ES phase record
            ES_Phase__c phases = new ES_Phase__c(Name = 'Phase 1',
                                                    Inspection__c = Inspection.Id);
            INSERT phases;
            
            //ES resource availability record
            ES_Resource_Availability__c resAvail = new ES_Resource_Availability__c( User__c = testUser.Id,
                                                                                         Fiscal_Year__c = 'FY21',
                                                                                         Jan__c = resourceAvailability, Feb__c = resourceAvailability, 
                                                                                         Mar__c = resourceAvailability, Apr__c = resourceAvailability, 
                                                                                         May__c = resourceAvailability, Jun__c = resourceAvailability, 
                                                                                         Jul__c = resourceAvailability, Aug__c = resourceAvailability, 
                                                                                         Sep__c = resourceAvailability, Oct__c = resourceAvailability,
                                                                                         Nov__c = resourceAvailability, Dec__c = resourceAvailability);
                                                                                         
            INSERT resAvail;
            
            //Allocation records
            ES_Resource_Allocation__c resAllocation = new ES_Resource_Allocation__c(Inspection__c = Inspection.Id,
                                                                                      Resource_Availability__c = resAvail.Id,
                                                                                      Role__c = 'SME' );                                                                                        
            INSERT resAllocation;
            
            //ES Task records
            ES_Task__c task1 = new ES_Task__c(Name = 'Task 1', 
                                                Status__c = 'Not Started',
                                                Start_Date__c = System.today(), 
                                                Due_Date__c = System.today()+30, 
                                                Assigned_To1__c = UserInfo.getUserId(),
                                                Is_Milestone__c = true,
                                                Phase__c = phases.Id); 
            lstOfTasks.add(task1);
            
            ES_Task__c task2 = new ES_Task__c(Name = 'Task 2', 
                                                Status__c = 'Not Started',
                                                Start_Date__c = System.today(), 
                                                Due_Date__c = System.today()+30, 
                                                Assigned_To1__c = UserInfo.getUserId(), 
                                                Is_Milestone__c = false, 
                                                Phase__c = phases.Id);
            lstOfTasks.add(task2);
            
            INSERT lstOfTasks;
        }
    }
    
    static testmethod void getTasksForInspectionTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
<<<<<<< HEAD
            Inspection__c Inspection = [SELECT Id FROM Inspection__c LIMIT 1];
=======
            Inspection__c project = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 01eee72 (Change2)
            Test.startTest();
            List<ES_Task__c> lstOfResult = ES_TaskandPhaseManagementCtrl.getTasksForInspection(Inspection.Id);
            Test.stopTest();
            system.assertEquals(2, lstOfResult.size(), 'There should be 2 tasks present.');
        }
    }
    
    static testmethod void updateTaskTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            ES_Task__c taskrec = [SELECT Id, Status__c FROM ES_Task__c LIMIT 1];
            taskrec.Status__c = 'In Progress';
            
            Test.startTest();
            List<ES_Task__c> lstOfResult = ES_TaskandPhaseManagementCtrl.updateTasks(new List<ES_Task__c>{taskrec});
            ES_Task__c taskUpdated = [SELECT Id, Status__c FROM ES_Task__c LIMIT 1];
            Test.stopTest();
            system.assertEquals('In Progress', taskUpdated.Status__c, 'Task status must be updated.');
        }
    }
    
    static testmethod void updateTaskNegTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            ES_Phase__c phase = [SELECT Id FROM ES_Phase__c LIMIT 1];
            
            //Create Tasks        
            ES_Task__c task = new ES_Task__c(Name = 'Task 1', 
                                               Status__c = 'Not Started',
                                               Start_Date__c = System.today(), 
                                               Due_Date__c = System.today()+30, 
                                               Assigned_To1__c = UserInfo.getUserId(),
                                               Is_Milestone__c = true,
                                               Phase__c = phase.Id); 
            
            Test.startTest();
            try{
                List<ES_Task__c> lstOfResult = ES_TaskandPhaseManagementCtrl.updateTasks(new List<ES_Task__c>{task});
            }catch(Exception e){
                System.assertEquals(true, e.getMessage().contains('error'),'The error should occur');
            }
            
            Test.stopTest();
        }
    }
    
    static testmethod void deleteRecordTestCase(){
        User testUser = ES_Testcoverage.createUser('Standard User', new List<String>{'ES_Global_Admin'});
        System.runAs(testUser){
            ES_Task__c taskrec = [SELECT Id, Status__c FROM ES_Task__c LIMIT 1];
            
            Test.startTest();
            Boolean result = ES_TaskandPhaseManagementCtrl.deleteRecord(taskrec);
            List<ES_Task__c> lstOfResult = [SELECT Id, Status__c FROM ES_Task__c];
            Test.stopTest();
            system.assertEquals(1, lstOfResult.size(), 'Only 1 task should be present on delete.');
        }
    }
    
    static testmethod void deleteRecordNegTestCase(){
        User testUser = ES_Testcoverage.createUser('Standard User', new List<String>{'ES_Global_Admin'});
        System.runAs(testUser){
            ES_Phase__c phase = [SELECT Id FROM ES_Phase__c LIMIT 1];
            
            //Create Tasks        
            ES_Task__c task = new ES_Task__c(Name = 'Task 1', 
                                               Status__c = 'Not Started',
                                               Start_Date__c = System.today(), 
                                               Due_Date__c = System.today()+30, 
                                               Assigned_To1__c = UserInfo.getUserId(),
                                               Is_Milestone__c = true,
                                               Phase__c = phase.Id); 
            
            Test.startTest();
            Boolean result = ES_TaskandPhaseManagementCtrl.deleteRecord(task);
            system.assertEquals(false, result, 'There should be error.');
            Test.stopTest();    
        }
    }
    
    static testmethod void savePhasesTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
<<<<<<< HEAD
            Inspection__c Inspection = [SELECT Id FROM Inspection__c LIMIT 1];
=======
            Inspection__c project = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 01eee72 (Change2)
            
            //Create Phases        
            ES_Phase__c phase = new ES_Phase__c(Name='Phase 3', Inspection__c = Inspection.Id);
            Test.startTest();
            ES_TaskandPhaseManagementCtrl.savePhases(new List<ES_Phase__c> {phase});
            
<<<<<<< HEAD
            Inspection__c InspectionUpdated = [SELECT Id, (SELECT Id FROM Inspection_Phases__r) FROM Inspection__c WHERE Id=: Inspection.Id];          
            system.assertEquals(2, InspectionUpdated.Inspection_Phases__r.size(), 'There should be 2 phases available.');
=======
            Inspection__c projectUpdated = [SELECT Id, (SELECT Id FROM Project_Phases__r) FROM Inspection__c WHERE Id=: project.Id];          
            system.assertEquals(2, projectUpdated.Project_Phases__r.size(), 'There should be 2 phases available.');
>>>>>>> 01eee72 (Change2)
            Test.stopTest();
        }
        
    }
    
    static testmethod void savePhasesNegTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            //Create Phases        
            ES_Phase__c phase = new ES_Phase__c(Name='Phase 3');
            Test.startTest();
            try{
                ES_TaskandPhaseManagementCtrl.savePhases(new List<ES_Phase__c> {phase});
            }catch(Exception e){
                System.assertEquals(true, e.getMessage().contains('error'),'The error should occur for negative test');
            }
            Test.stopTest();
        }
    }
    
    static testmethod void saveTasksTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            ES_Phase__c phase = [SELECT Id FROM ES_Phase__c LIMIT 1];
            
            //Create Tasks        
            ES_Task__c task = new ES_Task__c(Name = 'Task 1', 
                                               Status__c = 'Not Started',
                                               Start_Date__c = System.today(), 
                                               Due_Date__c = System.today()+30, 
                                               Assigned_To1__c = UserInfo.getUserId(),
                                               Is_Milestone__c = true,
                                               Phase__c = phase.Id); 
            
            Test.startTest();
            ES_TaskandPhaseManagementCtrl.saveTasks(new List<ES_Task__c> {task});
            
            ES_Phase__c phaseUpdated = [SELECT Id, (SELECT Id FROM Inspection_Tasks__r) FROM ES_Phase__c WHERE Id =: phase.Id];      
            Test.stopTest();
            system.assertEquals(3, phaseUpdated.Inspection_Tasks__r.size(), 'There should be 3 task available.');
        }
        
    }
    
    static testmethod void saveTasksNegTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            //Create Tasks        
            ES_Task__c task = new ES_Task__c(Name = 'Task 1', 
                                               Status__c = 'Not Started',
                                               Start_Date__c = System.today(), 
                                               Due_Date__c = System.today()+30, 
                                               Assigned_To1__c = UserInfo.getUserId(),
                                               Is_Milestone__c = true); 
            
            Test.startTest();
            try{    
                ES_TaskandPhaseManagementCtrl.saveTasks(new List<ES_Task__c> {task});
            }catch(Exception e){
                System.assertEquals(true, e.getMessage().contains('error'),'The error should occur for negative test');
            }                   
            Test.stopTest();
        }
    }
    
    static testmethod void getPicklistvaluesTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            Test.startTest();
            List<String> lstOfResult = ES_TaskandPhaseManagementCtrl.getPicklistvalues('ES_Task__c','Status__c', false);
            Test.stopTest();
            system.assertEquals(5, lstOfResult.size(), 'There should be 5 task status available.');
        }
    }
    
    static testmethod void getTaskWrapperTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
<<<<<<< HEAD
            Inspection__c Inspection = [SELECT Id FROM Inspection__c LIMIT 1];
=======
            Inspection__c project = [SELECT Id FROM Inspection__c LIMIT 1];
>>>>>>> 01eee72 (Change2)
            Test.startTest();
            ES_TaskandPhaseManagementCtrl.createTasksWrapper options = ES_TaskandPhaseManagementCtrl.getTaskWrapper(Inspection.Id);
            Test.stopTest();
            system.assertEquals(1, options.phasesList.size(), 'There should be 1 phase available.');
            system.assertEquals(1, options.memberList.size(), 'There should be 1 member available.');
        }
    }
    
    static testmethod void getTasksListTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            ES_Task__c taskrec = [SELECT Id FROM ES_Task__c LIMIT 1]; 
            
            Test.startTest();
            List<ES_Task__c> lstOfResult = ES_TaskandPhaseManagementCtrl.getTasksList(new List<ID>{taskrec.Id});
            Test.stopTest();
            system.assertEquals(true, lstOfResult[0].Assigned_To1__c != null, 'Assigned to field must be queried.');
        }
    }
    
    static testmethod void submitTaskForApprovalTestCase(){
        User testUser = [select id from user where profile.Name='Standard User' and alias = 'ESUser' and LastName='Last' limit 1];
        System.runAs(testUser){
            ES_Task__c taskrec = [SELECT Id FROM ES_Task__c LIMIT 1];         
            Test.startTest();
            Boolean result = ES_TaskandPhaseManagementCtrl.submitTaskForApproval(taskrec.Id);
            Test.stopTest();
            system.assertEquals(false, result, 'No approval process found'); //NOTE: Need to update assert on set up of approval process
        }
    }
    
}