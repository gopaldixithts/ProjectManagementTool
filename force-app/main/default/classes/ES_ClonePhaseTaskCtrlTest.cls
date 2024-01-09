/********************************************************
* Name: ES_ClonePhaseTaskCtrlTest
* Test class for : ES_ClonePhaseTaskCtrl (85%)
* Version : 56
* *******************************************************/

@isTest
public class ES_ClonePhaseTaskCtrlTest {
    
    @testSetup static void setup() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        
        User usr = new User(Alias = 'standt', Email = 'standarduser@EStemplate.com',
                            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                            LocaleSidKey = 'en_US', ProfileId = p.Id,
                            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser@ESdeepclone.com');
        
        insert usr;
        
        List<PermissionSetAssignment> lstOfPSA = new List<PermissionSetAssignment> ();
        
        for (PermissionSet psRec: [SELECT Id FROM PermissionSet WHERE Name IN('ES_User')]) {
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = usr.Id, PermissionSetId = psRec.Id);
            lstOfPSA.add(psa);
        }
        
        INSERT lstOfPSA;
        
        System.runAs(usr) {
            
            List<ES_Task__c > lstOfTasks = new List<ES_Task__c > ();
            
<<<<<<< HEAD
<<<<<<< HEAD
            //ES inspection record
            Inspection__c inspection = new Inspection__c(Name = 'Clone Phases/Tasks Test',
=======
            //ES project record
            Inspection__c project = new Inspection__c(Name = 'Clone Phases/Tasks Test',
>>>>>>> 01eee72 (Change2)
=======
            //ES inspection record
            Inspection__c inspection = new Inspection__c(Name = 'Clone Phases/Tasks Test',
>>>>>>> e5d1b8c (change15)
                                                        Portfolio__c = 'R2R',
                                                        Initial_End_Date__c = System.today() + 30,
                                                        Initial_Start_Date__c = System.today(),
                                                        Level_of_Effort__c = 'Medium'
                                                        //TShirtSize__c = 'Explorer'
                                                       );
            INSERT inspection;
            
<<<<<<< HEAD
<<<<<<< HEAD
            //ES inspection template record
            Inspection__c templateInspection = new Inspection__c(Name = 'Template Inspection',
=======
            //ES project template record
            Inspection__c templateProject = new Inspection__c(Name = 'Template Project',
>>>>>>> 01eee72 (Change2)
=======
            //ES inspection template record
            Inspection__c templateInspection = new Inspection__c(Name = 'Template Inspection',
>>>>>>> e5d1b8c (change15)
                                                                Portfolio__c = 'R2R',
                                                                Initial_End_Date__c = System.today() + 30,
                                                                Initial_Start_Date__c = System.today(),
                                                                Level_of_Effort__c = 'Medium',
                                                                IsTemplate__c = true
                                                                //TShirtSize__c = 'Explorer'
                                                               );
            INSERT templateInspection;
            
            //ES phase record
            ES_Phase__c phases = new ES_Phase__c(Name = 'Phase 1',
<<<<<<< HEAD
<<<<<<< HEAD
                                                   ES_Inspection__c = inspection.Id, Phase_Health__c = 'On Track');
=======
                                                   Inspection__c = inspection.Id, Phase_Health__c = 'On Track');
>>>>>>> e5d1b8c (change15)
=======
                                                   ES_Inspection__c = inspection.Id, Phase_Health__c = 'On Track');
>>>>>>> f6a11f4 (change20)
            INSERT phases;
            
            //ES phase record
            ES_Phase__c phases1 = new ES_Phase__c(Name = 'Phase Template',
<<<<<<< HEAD
<<<<<<< HEAD
                                                    ES_Inspection__c = templateInspection.Id, Phase_Health__c = 'On Track');
=======
                                                    Inspection__c = templateInspection.Id, Phase_Health__c = 'On Track');
>>>>>>> e5d1b8c (change15)
=======
                                                    ES_Inspection__c = templateInspection.Id, Phase_Health__c = 'On Track');
>>>>>>> f6a11f4 (change20)
            INSERT phases1;
            
            //ES Task records
            ES_Task__c task3 = new ES_Task__c(Name = 'Task Template',
                                                Status__c = 'Not Started',
                                                Start_Date__c = System.today(),
                                                Due_Date__c = System.today() + 30,
                                                Is_Milestone__c = true,
                                                Start_Days_Out__c = 2,
                                                Duration_In_Days__c = 5,
                                                Phase__c = phases1.Id);
            lstOfTasks.add(task3);
            
            //ES Task records
            ES_Task__c task1 = new ES_Task__c(Name = 'Task 1',
                                                Status__c = 'Not Started',
                                                Start_Date__c = System.today(),
                                                Due_Date__c = System.today() + 30,
                                                Is_Milestone__c = true,
                                                Phase__c = phases.Id);
            lstOfTasks.add(task1);
            
            ES_Task__c task2 = new ES_Task__c(Name = 'Task 2',
                                                Status__c = 'Not Started',
                                                Start_Date__c = System.today(),
                                                Due_Date__c = System.today() + 30,
                                                Is_Milestone__c = false,
                                                Phase__c = phases.Id);
            lstOfTasks.add(task2);
            
            INSERT lstOfTasks;
        }
    }
    
/*****************************************************************
* Method Name: getTasksforSelectedPhases 
* Class : ES_ClonePhaseTaskCtrl 
******************************************************************/
    static testmethod void getTasksforSelectedPhases() {
        
        User testUser = [select id from User where Email = 'standarduser@EStemplate.com'];
        
        System.runAs(testUser) {
            
            Test.startTest();
            
            List<ES_Task__c> lstTasks;
            List<Inspection__c> lstProj = [select id from Inspection__c where Name = 'Clone Phases/Tasks Test'];
            
            ES_ClonePhaseTaskCtrl.FlowInputs wrap = new ES_ClonePhaseTaskCtrl.FlowInputs();
<<<<<<< HEAD
<<<<<<< HEAD
            wrap.phases = [select id from ES_Phase__c where ES_Inspection__c=:lstProj[0].Id];
=======
            wrap.phases = [select id from ES_Phase__c where Inspection__c=:lstProj[0].Id];
>>>>>>> e5d1b8c (change15)
=======
            wrap.phases = [select id from ES_Phase__c where ES_Inspection__c=:lstProj[0].Id];
>>>>>>> f6a11f4 (change20)
            wrap.inspectionId = lstProj[0].Id;
            wrap.phaseCheck = true;
            
            List<ES_ClonePhaseTaskCtrl.FlowInputs > paramList = new List<ES_ClonePhaseTaskCtrl.FlowInputs > ();
            paramList.add(wrap);
            
            List<ES_ClonePhaseTaskCtrl.FlowOutputs > outputList = ES_ClonePhaseTaskCtrl.getTasks(paramList);
            
            for(ES_ClonePhaseTaskCtrl.FlowOutputs tasks: outputList){
                lstTasks = tasks.outputTasks;
            }
            System.assertEquals(2, lstTasks.size(), 'There should be 2 tasks returned.');
            Test.stopTest();
        }
    }
    
/*****************************************************************
* Method Name: cloneInspectionFromTemplates
* Class : ES_ClonePhaseTaskCtrl 
******************************************************************/
    static testmethod void cloneInspectionFromTemplates() {
        User testUser = [select id from User where Email = 'standarduser@EStemplate.com'];
        
        System.runAs(testUser) {
            
            Test.startTest();
            
            List<Inspection__c> lstProj = [select id from Inspection__c where IsTemplate__c=true];
            
            ES_ClonePhaseTaskCtrl.FlowInputs wrap = new ES_ClonePhaseTaskCtrl.FlowInputs();
<<<<<<< HEAD
<<<<<<< HEAD
            wrap.phases = [select id, Name, Inspection__c, Phase_Health__c from ES_Phase__c where ES_Inspection__c=:lstProj[0].Id];
=======
            wrap.phases = [select id, Name, Inspection__c, Phase_Health__c from ES_Phase__c where Inspection__c=:lstProj[0].Id];
>>>>>>> e5d1b8c (change15)
=======
            wrap.phases = [select id, Name, Inspection__c, Phase_Health__c from ES_Phase__c where ES_Inspection__c=:lstProj[0].Id];
>>>>>>> f6a11f4 (change20)
            wrap.tasks = [select id from ES_Task__c where Name='Task Template'];
            wrap.inspectionId = lstProj[0].Id;
            wrap.phaseCheck = false;
            wrap.inspectionName = 'Test Template Inspection';
            wrap.inspectionStartDate = System.Today();
            
            List<ES_ClonePhaseTaskCtrl.FlowInputs > paramList = new List<ES_ClonePhaseTaskCtrl.FlowInputs > ();
            paramList.add(wrap);
            
            ES_ClonePhaseTaskCtrl.getTasks(paramList);
            
<<<<<<< HEAD
<<<<<<< HEAD
            List<Inspection__c> lstProj1 = [select id from Inspection__c where Name='Test Template Inspection'];
=======
            List<Inspection__c> lstProj1 = [select id from Inspection__c where Name='Test Template Project'];
>>>>>>> 01eee72 (Change2)
=======
            List<Inspection__c> lstProj1 = [select id from Inspection__c where Name='Test Template Inspection'];
>>>>>>> e5d1b8c (change15)
            
            system.assertEquals(1, lstProj1.size(), 'There should be 1 new Inspection created from Template');
            
            Test.stopTest();
        }
    }
    
/*****************************************************************
* Method Name: cloneSelectedPhases
* Class : ES_ClonePhaseTaskCtrl 
******************************************************************/
    static testmethod void cloneSelectedPhases() {
        User testUser = [select id from User where Email = 'standarduser@EStemplate.com'];
        
        System.runAs(testUser) {
            
            Test.startTest();
            
            List<Inspection__c> lstProj = [select id from Inspection__c where Name='Clone Phases/Tasks Test'];
            
            ES_ClonePhaseTaskCtrl.FlowInputs wrap = new ES_ClonePhaseTaskCtrl.FlowInputs();
<<<<<<< HEAD
<<<<<<< HEAD
            wrap.phases = [select id, Name, ES_Inspection__c, Phase_Health__c from ES_Phase__c where Name='Phase 1'];
=======
            wrap.phases = [select id, Name, Inspection__c, Phase_Health__c from ES_Phase__c where Name='Phase 1'];
>>>>>>> e5d1b8c (change15)
=======
            wrap.phases = [select id, Name, ES_Inspection__c, Phase_Health__c from ES_Phase__c where Name='Phase 1'];
>>>>>>> f6a11f4 (change20)
            wrap.inspectionId = lstProj[0].Id;
            wrap.phaseCheck = false;
            
            List<ES_ClonePhaseTaskCtrl.FlowInputs > paramList = new List<ES_ClonePhaseTaskCtrl.FlowInputs > ();
            paramList.add(wrap);
            
            ES_ClonePhaseTaskCtrl.getTasks(paramList);
            
            Test.stopTest();
            List<ES_Phase__c> lstPhases = [select id, Phase_Health__c from ES_Phase__c where Name='Phase 1'];
            
            system.assertEquals(2, lstPhases.size(), 'There should be 2 phases returned.');
        }
    }
    
/*****************************************************************
* Method Name: cloneSelectedTasks
* Class : ES_ClonePhaseTaskCtrl 
******************************************************************/
    static testmethod void cloneSelectedTasks() {
        User testUser = [select id from User where Email = 'standarduser@EStemplate.com'];
        
        System.runAs(testUser) {
            
            Test.startTest();
            
            List<Inspection__c> lstProj = [select id from Inspection__c];
            
            ES_ClonePhaseTaskCtrl.FlowInputs wrap = new ES_ClonePhaseTaskCtrl.FlowInputs();
            wrap.phases = [select id from ES_Phase__c where Name='Phase 1'];
            wrap.tasks = [select id, Phase__c from ES_Task__c where Name='Task 1'];
            wrap.inspectionId = lstProj[0].Id;
            wrap.phaseCheck = false;
            
            List<ES_ClonePhaseTaskCtrl.FlowInputs > paramList = new List<ES_ClonePhaseTaskCtrl.FlowInputs > ();
            paramList.add(wrap);
            
            ES_ClonePhaseTaskCtrl.getTasks(paramList);
            
            Test.stopTest();
            
            List<ES_Task__c> lstTasks = [select id from ES_Task__c where Name='Task 1'];
            system.assertEquals(2, lstTasks.size(), 'There should be 2 tasks returned.');
        }
    }
    
/*****************************************************************
* Method Name: cloneSelectedPhasesNegative
* Class : ES_ClonePhaseTaskCtrl 
******************************************************************/
    static testmethod void cloneSelectedPhasesNegative() {
        User testUser = [select id from User where Email = 'standarduser@EStemplate.com'];
        
        System.runAs(testUser) {
            
            Test.startTest();
            
            ES_ClonePhaseTaskCtrl.FlowInputs wrap = new ES_ClonePhaseTaskCtrl.FlowInputs();
            wrap.phases = [select id from ES_Phase__c];
            wrap.phaseCheck = false;
            
            List<ES_ClonePhaseTaskCtrl.FlowInputs > paramList = new List<ES_ClonePhaseTaskCtrl.FlowInputs > ();
            paramList.add(wrap);
            
            ES_ClonePhaseTaskCtrl.getTasks(paramList);
            
            wrap.phases = new List<ES_Phase__c > ();
            wrap.tasks = [select id, Phase__c from ES_Task__c];
            wrap.inspectionStartDate = System.Today();
            
            ES_ClonePhaseTaskCtrl.getTasks(paramList);
            
            Test.stopTest();
            
            List<ES_Phase__c> lstPhases = [select id from ES_Phase__c where Name='Phase 1'];
            System.assertEquals(1, lstPhases.size(), 'There should be only 1 Phase returned due to failure');
        }
    }
}