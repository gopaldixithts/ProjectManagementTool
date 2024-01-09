/******************************************************************************
* Name: ES_InspectionSummaryCtrl.apxc
* Used by: Used by ES_InspectionSummaryPhaseTable.cmp
* Description : It contains methods to find out phases, tasks, milestones related to ES Inspection
* Test class : ES_Testcoverage(85%)
******************************************************************************/

public with sharing class ES_InspectionSummaryCtrl {

    /*************************************************
    * Name: createSummaryWrapper
    * Description: Create wrapper for lists
    * ***********************************************/
  
    public class CreateSummaryWrapper
    {
        @AuraEnabled public List<ES_Phase__c> phasesList;
        @AuraEnabled public List<ES_Task__c> lateTaskList;
        @AuraEnabled public List<ES_Task__c> onGoingTaskList;
        @AuraEnabled public List<ES_Task__c> milestoneTaskList;
        @AuraEnabled public integer fiscalMonthOffset;
    }
    
    /************************************************
    * Method Name: getSummaryWrapper 
    * Description: Wrapper for getPhasesForInspection and getTasksForInspection methods
    * Parameters : recordId
    * Return Values: list of Tasks and list of phases
    * ***********************************************/    
    @AuraEnabled
    public static CreateSummaryWrapper getSummaryWrapper(Id recordId)
    {
        CreateSummaryWrapper summaryWrapper = new CreateSummaryWrapper();
        //Calling util method to check CRUD
        List<String> lstOfPhaseFields = new List<String>{'Name', 'Health_Icon__c', 'Phase_Completion__c', 'Phase_Completion_Image__c', 'ES_Inspection__c','Kickoff_formula__c'};
        if (ES_Utility.validateCRUD('ES_Phase__c', lstOfPhaseFields, 'isAccessible') ){ 
            summaryWrapper.phasesList = getPhasesForInspection(recordId);
        }else{
            throw new AuraHandledException('You don\'t have access to ES Phases. Please contact system administrator.');
        }
        
        //Calling util method to check CRUD
        List<String> lstOfTaskFields = new List<String>{'Name', 'Status_Icon__c', 'Start_Date__c', 'Due_Date__c', 'Is_Milestone__c', 'Phase__c', 'Days_Late__c', 'Inspection_Id__c'};
        if (ES_Utility.validateCRUD('ES_Task__c', lstOfTaskFields, 'isAccessible') ){ 
            summaryWrapper.lateTaskList = getLateTasksForInspection(recordId);
            
            summaryWrapper.onGoingTaskList = getOnGoingTasksForInspection(recordId);
            
            summaryWrapper.milestoneTaskList = getMilestoneTasksForInspection(recordId);
        }else{
            throw new AuraHandledException('You don\'t have access to ES Task. Please contact system administrator.');
        }       
        
        //Get ES Settings
        summaryWrapper.fiscalMonthOffset = Integer.valueOf(ES_Utility.getESSettings('Default').Start_Month_of_Fiscal_Year__c);
        return summaryWrapper;      
    }
    
    /*************************************************
    * Method Name: getPhasesForInspection
    * Description: Get list of Phases for a Inspection
    * Parameters : recordId
    * Return Values: list of phases
    * ***********************************************/  
    private static List<ES_Phase__c> getPhasesForInspection(Id recordId)
    {
        return [SELECT id,Name,Health_Icon__c,Phase_Completion__c, Phase_Completion_Image__c,Kickoff_formula__c FROM ES_Phase__c 
                WHERE Inspection__c=:recordId ORDER BY Kickoff_formula__c ASC limit: limits.getLimitQueryRows()];                    
    }

    /*************************************************
    * Method Name: getLateTasksForInspection
    * Description: Get list of Tasks for a Inspection
    * Parameters : recordId
    * Return Values: list of late tasks
    * ***********************************************/  
    private static List<ES_Task__c> getLateTasksForInspection(Id recordId)
    {
        return [SELECT id,Name,Status_Icon__c,Start_Date__c,Due_Date__c,Is_Milestone__c,Phase__c,Days_Late__c FROM ES_Task__c 
                WHERE Inspection_Id__c=:recordId AND Days_Late__C > 0 order by Due_Date__c ASC, Name ASC limit: limits.getLimitQueryRows()];
    }

    /*************************************************
    * Method Name: getOnGoingTasksForInspection
    * Description: Get list of OnGoing Tasks set for a Inspection
    * Parameters : recordId
    * Return Values: list of ongoing tasks (not Late)
    * ***********************************************/  
    private static List<ES_Task__c> getOnGoingTasksForInspection(Id recordId)
    {
        return [SELECT id,Name,Status_Icon__c,Start_Date__c,Due_Date__c,Is_Milestone__c,Phase__c,Phase__r.Name,    Days_Late__c FROM ES_Task__c 
                WHERE Inspection_Id__c=:recordId AND Days_Late__C <= 0 order by Due_Date__c ASC, Name ASC limit: limits.getLimitQueryRows()];                        
    }

    /*************************************************
    * Method Name: getMilestoneTasksForInspection
    * Description: Get list of Milestone Tasks set for a Inspection
    * Parameters : recordId
    * Return Values: list of Milestone tasks
    * ***********************************************/  
    private static List<ES_Task__c> getMilestoneTasksForInspection(Id recordId)
    {
        return [SELECT id,Name,Status_Icon__c,Due_Date__c FROM ES_Task__c 
                WHERE Inspection_Id__c=:recordId AND Is_Milestone__c=true order by Due_Date__c ASC, Name ASC limit: limits.getLimitQueryRows()];                   
         
    }
    
}