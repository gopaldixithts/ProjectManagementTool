/******************************************************************************************************
 * Name: ES_GanttCtrlTest.apxc
 * Test class for : ES_GanttCtrl (87%)
 * Version : 56 
 ******************************************************************************************************/

@isTest
public with sharing class ES_GanttCtrlTest {
    /* Create Test Data */
    @testSetup static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        User testUser = new User(Alias = 'standt', Email = 'standarduser@ESgantt.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser@ESgantt.com');

        insert testUser;

        List<PermissionSetAssignment> lstOfPSA = new List<PermissionSetAssignment>();

        for (PermissionSet psRec: [SELECT Id FROM PermissionSet WHERE Name IN('ES_User')]) {
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = testUser.Id, PermissionSetId = psRec.Id);
            lstOfPSA.add(psa);
        }

        INSERT lstOfPSA;

        System.runAs(testUser) {
            List<ES_Task__c> lstOfTask = new List<ES_Task__c>();

            //Inspection 1 setup
            ES_Program__c pg1 = new ES_Program__c();
            pg1.Name = 'Test Program 1';
            pg1.Program_Health__c = 'On Track';
            INSERT pg1;

            Inspection__c prj1 = new Inspection__c();
<<<<<<< HEAD
<<<<<<< HEAD
            prj1.Name = 'New Inspection 1';
=======
            prj1.Name = 'New project 1';
>>>>>>> 01eee72 (Change2)
=======
            prj1.Name = 'New Inspection 1';
>>>>>>> 3dc5bb9 (change10)
            prj1.Program__c = pg1.Id;
            prj1.Inspection_Status__c = 'Execute';
            prj1.Inspection_Category__c = 'IT';
            prj1.Level_of_Effort__c = 'Medium';
            prj1.Inspection_Health__c = 'On Track';
            INSERT prj1;

            ES_Phase__c ph1 = new ES_Phase__c();
            ph1.Name = 'test phase 1';
<<<<<<< HEAD
<<<<<<< HEAD
            ph1.ES_Inspection__c = prj1.Id;
=======
            ph1.Inspection__c = prj1.Id;
>>>>>>> 3dc5bb9 (change10)
=======
            ph1.ES_Inspection__c = prj1.Id;
>>>>>>> f6a11f4 (change20)
            INSERT ph1;

            ES_Phase__c ph2 = new ES_Phase__c();
            ph2.Name = 'test phase 2';
<<<<<<< HEAD
<<<<<<< HEAD
            ph2.ES_Inspection__c = prj1.Id;
=======
            ph2.Inspection__c = prj1.Id;
>>>>>>> 3dc5bb9 (change10)
=======
            ph2.ES_Inspection__c = prj1.Id;
>>>>>>> f6a11f4 (change20)
            INSERT ph2;

            ES_Task__c tsk1 = new ES_Task__c();
            tsk1.Name = 'Task 01 for Inspection 1';
            tsk1.Phase__c = ph1.Id;
            tsk1.Assigned_To1__c = UserInfo.getUserId();
            lstOfTask.add(tsk1);

            //Inspection 2 setup
            ES_Program__c pg2 = new ES_Program__c();
            pg2.Name = 'Test Program 2';
            pg2.Program_Health__c = 'On Track';
            INSERT pg2;

            Inspection__c prj2 = new Inspection__c();
<<<<<<< HEAD
<<<<<<< HEAD
            prj2.Name = 'New Inspection 2';
=======
            prj2.Name = 'New project 2';
>>>>>>> 01eee72 (Change2)
=======
            prj2.Name = 'New Inspection 2';
>>>>>>> 3dc5bb9 (change10)
            prj2.Program__c = pg2.Id;
            prj2.Path_to_Green__c = 'Test';
            prj2.Level_of_Effort__c = 'Medium';
            prj2.Inspection_Status__c = 'Transition';
            prj2.Inspection_Category__c = 'Non IT';
            prj2.Inspection_Health__c = 'At Risk';
            INSERT prj2;

            ES_Phase__c ph3 = new ES_Phase__c();
            ph3.Name = 'test phase 2';
<<<<<<< HEAD
<<<<<<< HEAD
            ph3.ES_Inspection__c = prj2.Id;
=======
            ph3.Inspection__c = prj2.Id;
>>>>>>> 3dc5bb9 (change10)
=======
            ph3.ES_Inspection__c = prj2.Id;
>>>>>>> f6a11f4 (change20)
            INSERT ph3;

            ES_Task__c tsk2 = new ES_Task__c();
            tsk2.Name = 'Task 02 for Inspection 2';
            tsk2.Phase__c = ph3.Id;
            tsk2.Assigned_To1__c = UserInfo.getUserId();
            tsk2.Start_Date__c = System.Today();
            tsk2.Due_Date__c = System.Today() + 300;
            lstOfTask.add(tsk2);

            INSERT lstOfTask;
        }
    }

    static testmethod void testDefaultFilters() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'standarduser@ESgantt.com'];
        System.runAs(testUser) {
            Test.startTest();
            List<ES_GanttCtrl.GanttDataWrapper> result = ES_GanttCtrl.fetchGanttData(92, System.Today(), '', 'All', 'All', 'All', 'All', 'All');

            system.assertEquals(true, result.size() > 0);
            Test.stopTest();
        }
    }

    static testmethod void testOtherFilters() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'standarduser@ESgantt.com'];
        System.runAs(testUser) {

            Test.startTest();
            List<ES_GanttCtrl.GanttDataWrapper> result = ES_GanttCtrl.fetchGanttData(10, System.Today(), '', 'Execute', 'On Track', 'Inov8', 'Non IT', 'All');

            system.assertEquals(true, result.size() == 0);
            Test.stopTest();
        }
    }

    static testmethod void testProgramFilter() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'standarduser@ESgantt.com'];
        System.runAs(testUser) {
            ES_Program__c prg = [SELECT Id FROM ES_Program__c WHERE Name = 'Test Program 1'];

            Test.startTest();
            List<ES_GanttCtrl.GanttDataWrapper> result = ES_GanttCtrl.fetchGanttData(10, System.Today(), '', 'Execute', 'All', 'All', 'All', String.valueOf(prg.Id));
            system.assertEquals(true, result.size() > 0);
            Test.stopTest();
        }
    }

    static testmethod void testUpdateTask() {
        User testUser = [SELECT Id FROM User WHERE UserName = 'standarduser@ESgantt.com'];
        System.runAs(testUser) {
            ES_Task__c task = [SELECT Id FROM ES_Task__c WHERE Name = 'Task 01 for Inspection 1'];
            Test.startTest();

            String result = ES_GanttCtrl.saveTask(task.Id, System.Today(), System.Today()+30);
            Date start_Date = System.Today();
            Date end_Date = start_Date + 4 - 1;

            task = [SELECT Id, Start_Date__c, Due_Date__c FROM ES_Task__c WHERE Name = 'Task 01 for Inspection 1'];
            system.assertEquals(true, result == 'Task updated successfully.', 'Error updating Task');
            Test.stopTest();
        }
    }

    static testmethod void testUpdateTaskNegative() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];

        User testUser = new User(Alias = 'standt', Email = 'standarduser@ESgantt.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser@ESgantttest.com');

        insert testUser;
        System.runAs(testUser) {
            try {
                ES_Task__c task = [SELECT Id FROM ES_Task__c WHERE Name = 'Task 01 for Inspection 1'];
                Test.startTest();
                String result = ES_GanttCtrl.saveTask(task.Id, System.Today()+10, System.Today());
                Test.stopTest();
            } catch (Exception ex) {}
        }
    }

    static testmethod void testFilterValues() {
<<<<<<< HEAD
<<<<<<< HEAD
        Map<String, String> mapOfHealthValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Health__c');
        Map<String, String> mapOfCategoryValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Category__c');
        Map<String, String> mapOfSystemValues = ES_Utility.getPicklistValues('Inspection__c', 'SystemsImpacted__c');
        Map<String, String> mapOfProgressValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Status__c');
=======
        Map<String, String> mapOfHealthValues = ES_Utility.getPicklistValues('Inspection__c', 'Project_Health__c');
        Map<String, String> mapOfCategoryValues = ES_Utility.getPicklistValues('Inspection__c', 'Project_Category__c');
        Map<String, String> mapOfSystemValues = ES_Utility.getPicklistValues('Inspection__c', 'SystemsImpacted__c');
        Map<String, String> mapOfProgressValues = ES_Utility.getPicklistValues('Inspection__c', 'Project_Status__c');
>>>>>>> 01eee72 (Change2)
=======
        Map<String, String> mapOfHealthValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Health__c');
        Map<String, String> mapOfCategoryValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Category__c');
        Map<String, String> mapOfSystemValues = ES_Utility.getPicklistValues('Inspection__c', 'SystemsImpacted__c');
        Map<String, String> mapOfProgressValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Status__c');
>>>>>>> 3dc5bb9 (change10)

        User testUser = [SELECT Id FROM User WHERE UserName = 'standarduser@ESgantt.com'];

        System.runAs(testUser) {
            Test.startTest();
            ES_GanttCtrl.GanttFliterWrapper result = ES_GanttCtrl.getGanttFilters();

            system.assertEquals(true, result.prjhealth.size() == mapOfHealthValues.size(), 'All values of Inspection health must be fetched.');
            system.assertEquals(true, result.prjcategory.size() == mapOfCategoryValues.size(), 'All values of Inspection category must be fetched.');
            system.assertEquals(true, result.sysimpacted.size() == mapOfSystemValues.size(), 'All values of System impacted must be fetched.');
            system.assertEquals(true, result.prjprogress.size() == mapOfProgressValues.size(), 'All values of Inspection status must be fetched.');
            Test.stopTest();
        }
    }
}