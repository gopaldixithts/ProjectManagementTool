/*************************************************
* Name: ES_TaskandPhaseManagementCtrl
* Description: Helper for Task Management related components:
            - ES_TaskTableEditor.cmp
            - ES_CreateMultiPhases
            - ES_CreateMultiTasks.cmp
* Test class: ES_TaskandPhaseManagementCtrlTest (84%)
* ***********************************************/

public with Sharing class ES_TaskandPhaseManagementCtrl{
    
    /*************************************************
* Name: CreateTasksWrapper
* Used by : ES_CreateMultiTasks.cmp
* ***********************************************/
    
    public class CreateTasksWrapper
    {
        @AuraEnabled public List<Map<String, String>> phasesList;
        @AuraEnabled public List<Map<String, String>> memberList;      
    }
    
    /************************************************
* Method Name: getTaskWrapper 
* Description: Get tasks for the current Inspection
* Component(s): ES_CreateMultiTasks.cmp
* Parameters : Inspection id
* Return Values:  CreateTasksWrapper instance
* ***********************************************/    
    @AuraEnabled
    public static CreateTasksWrapper getTaskWrapper(Id InspectionId)
    {
        CreateTasksWrapper taskWrapper = new CreateTasksWrapper();
        //Calling util method to check CRUD
        List<String> lstPhaseFields = new List<String>{'Name', 'Inspection__c'};
        if(ES_Utility.validateCRUD('ES_Phase__c', lstPhaseFields , 'isAccessible')) {
            taskWrapper.phasesList = getPhasesList(InspectionId);
        }else{
            throw new AuraHandledException('You don\'t have access to ES phases. Please contact system administartor.');
        }
        
        //Calling util method to check CRUD
        List<String> lstAllocationFields = new List<String>{'Allocated_Resource_Id__c', 'Resource_Name__c'};
        if(ES_Utility.validateCRUD('ES_Resource_Allocation__c', lstAllocationFields, 'isAccessible')) {
            taskWrapper.memberList = getMemberList(InspectionId);
        }else{
            throw new AuraHandledException('You don\'t have access to ES Resource allocations. Please contact system administartor.');
        }
        
        return taskWrapper;
    }
    
    /*************************************************
* Method Name: getPhasesList
* Description: Get list of Inspection related Phases
* Component(s): ES_CreateMultiTasks.cmp
* Parameters : InspectionId
* Return Values: items
* ***********************************************/  
    private static List<Map<String, String>> getPhasesList(ID InspectionId) {    
        List<Map<String, String>> items = new List<Map<String, String>>();        
        for (ES_Phase__c ph : [SELECT id, Name FROM ES_Phase__c WHERE Inspection__c =:InspectionId limit :limits.getLimitQueryRows()]){
            items.add(new Map<String, String>{'value' => ph.Id, 'label'=> ph.Name});
        }
        
        return items;
    }
    
    /*************************************************
* Method Name: getMemberList
* Description: Get list of Inspection Members
* Component(s): ES_CreateMultiTasks.cmp
* Parameters : InspectionId
* Return Values: items
* ***********************************************/    
    private static List<Map<String, String>> getMemberList(ID InspectionId) {    
        List<Map<String, String>> items = new List<Map<String, String>>();  
        Set<Id> uniqueUserIds = new Set<Id>();
        for (ES_Resource_Allocation__c mb : [SELECT id, Allocated_Resource_Id__c, Resource_Name__c FROM ES_Resource_Allocation__c WHERE Inspection__c =:InspectionId and Resource_IsActive__c = true limit :limits.getLimitQueryRows()]){
            if(uniqueUserIds.add(mb.Allocated_Resource_Id__c)){
                items.add(new Map<String, String>{'value' => mb.Allocated_Resource_Id__c, 'label'=> mb.Resource_Name__c});
            }
        }
        
        return items;
    }
    
    
    /************************************************
* Method Name: getTasksForInspection 
* Description: Get tasks for the current Inspection
* Component(s): ES_TaskTableEditor.cmp
*Parameters : Inspection id
* Return Values: list of Task
* ***********************************************/    
    @AuraEnabled
    public static List<ES_Task__c> getTasksForInspection(Id InspectionId)
    {
        List<String> lstTaskFields = new List<String>{'Id','Name','Status__c','Assigned_To1__c','Percentage_Completion__c','Start_Date__c','Due_Date__c','Description__c','On_Hold_Reason__c','Sign_off_status__c','Is_Milestone__c','Phase__c','Status_Icon__c','Status_Icon_Name__c'};
             
        List<String> lstUserFields = new List<String>{'Name'};
        
        List<String> lstPhaseFields = new List<String>{'Name', 'Id'};
        
            //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Task__c', lstTaskFields, 'isAccessible') && ES_Utility.validateCRUD('User', lstUserFields, 'isAccessible') && ES_Utility.validateCRUD('ES_Phase__c', lstPhaseFields, 'isAccessible')){
            
            return [SELECT id,Name,Status__c,Assigned_To1__c,Percentage_Completion__c,Assigned_To1__r.Name,Start_Date__c,Due_Date__c,Description__c,On_Hold_Reason__c,Sign_off_status__c,Is_Milestone__c,Phase__c,Status_Icon__c,Status_Icon_Name__c,Phase__r.Name,
                    Phase__r.Id FROM ES_Task__c WHERE Inspection_Id__c=:InspectionId order by Start_Date__c ASC limit: limits.getLimitQueryRows()];                     
                    
                    
        }else{
            throw new AuraHandledException('Access restricted. Please contact system administartor.');
        }
    }
    
    
    /*************************************************
* Method Name: updateTasks
* Description: Update tasks
* Component(s): ES_TaskTableEditor.cmp
* Parameters : tasks
* Return Values: list of tasks
* ***********************************************/
    @AuraEnabled
    public static List<ES_Task__c> updateTasks(List<ES_Task__c> tasks){
        //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Task__c', null, 'isUpdateable')){ 
            try {            
                if(!tasks.isEmpty()){
                    UPDATE tasks;
                    return tasks;  
                }else{
                    return null;
                }
                
            } catch(Exception e) {
                //Calling util method to check CRUD
                List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                    INSERT new ES_Error_Log__c(Apex_Class__c='ES_TaskandPhaseManagementCtrl', Error_Message__c = e.getMessage() , Method_Name__c = 'updateTasks');
                }
                AuraHandledException ae = new AuraHandledException('Error occurred while updating task:');
                ae.setMessage(e.getMessage());
                throw ae;
            }
        }else{
            throw new AuraHandledException('You don\'t have access to update ES tasks. Please contact system administartor.');
        }   
    }  
    
    /*************************************************
* Method Name: deleteRecord
* Description: delete records
* Component(s): ES_TaskTableEditor.cmp
* Parameters : recordToDelete
* Return Values: null
* ***********************************************/
    @auraEnabled
    public static Boolean deleteRecord(sObject recordToDelete) {
        //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Task__c', null, 'isDeletable')){       
            try {
                DELETE recordToDelete;
                return true;
            } catch(Exception e) {
                List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                    INSERT new ES_Error_Log__c(Apex_Class__c='ES_TaskandPhaseManagementCtrl', Error_Message__c = e.getMessage() , Method_Name__c = 'deleteRecord');
                }
                return false;
            }
        }else{
            throw new AuraHandledException('You don\'t have access to delete ES tasks. Please contact system administartor.');
        }   
    }
    
    /*************************************************
* Method Name: submitTaskForApproval
* Description: Submit task for Approval
* Component(s): ES_TaskTableEditor.cmp
* Parameters : taskId
* Return Values: null
* NOTE: It will need approval process to update Sign off status on task on approval.
* ***********************************************/
    @auraEnabled
    public static Boolean submitTaskForApproval(Id taskId) {        
        Boolean res = false;
        try {
            if(taskId != null) {
                // create the new approval request to submit
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval.');
                req.setObjectId(taskId);
                // submit the approval request for processing
                Approval.ProcessResult result = Approval.Process(req);
                // display if the reqeust was successful
                if(result.isSuccess()) {
                    res = true;
                } 
                else 
                {
                    return res;
                }
            }
            return res;
        } catch(Exception e) {
            //Calling util method to check CRUD
            List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
            if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                INSERT new ES_Error_Log__c(Apex_Class__c='ES_TaskandPhaseManagementCtrl', Error_Message__c = e.getMessage() , Method_Name__c = 'submitTaskForApproval');
            }
            return false;
        }        
    }
    
    /*************************************************
* Method Name: savePhases
* Description: Create phases on submission
* Component(s): ES_CreateMultiPhases.cmp
* Parameters : phaseList
* Return Values: null
* ***********************************************/
    @AuraEnabled
    public static void savePhases(List<ES_Phase__c> phaseList){
        //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Phase__c', null, 'isCreateable')){
            try{
                Insert phaseList;
                
            }catch(Exception e) {   
                //Calling util method to check CRUD
                List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                    INSERT new ES_Error_Log__c(Apex_Class__c='ES_TaskandPhaseManagementCtrl', Error_Message__c = e.getMessage() , Method_Name__c = 'savePhases');
                }
                AuraHandledException ae = new AuraHandledException('Error occurred while creating phase:');
                ae.setMessage(e.getMessage());
                throw ae;
            }
        }else{
            throw new AuraHandledException('You don\'t have access to create phases. Please contact system administartor.');
        }   
    }
    
    /*************************************************
    * Method Name: getPicklistvalues
    * Description: Get values from picklist fields
    * Component(s): ES_CreateMultiPhases.cmp
    * Parameters : objectName, field_apiname
    * Return Values: optionlist
    * ***********************************************/
    
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        
        objectName =  objectName;
    
        field_apiname =  field_apiname;
    
    
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname.toLowerCase()).getDescribe().getPickListValues();
        if(nullRequired == true){
            optionlist.add('--None--');
        }
        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        return optionlist;
    }
    
    /*************************************************
* Method Name: saveTasks
* Description: Create phases on submission
* Component(s): ES_CreateMultiTasks.cmp
* Parameters : taskList
* Return Values: taskList
* ***********************************************/    
    @AuraEnabled
    public static void saveTasks(List<ES_Task__c> taskList){
        //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Task__c', null, 'isCreateable')){
            try{    
                Insert taskList;
            }catch(Exception e) {
                //Calling util method to check CRUD
                List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                    INSERT new ES_Error_Log__c(Apex_Class__c='ES_TaskandPhaseManagementCtrl', Error_Message__c = e.getMessage() , Method_Name__c = 'saveTasks');
                }
                AuraHandledException ae = new AuraHandledException('Error occurred while creating task:');
                ae.setMessage(e.getMessage());
                throw ae;
            }
        }else{
            throw new AuraHandledException('You don\'t have access to create ES Task. Please contact system administrator.');
        } 
    }
    
    /*************************************************
* Method Name: getTasksList
* Description: Get list of Inspection tasks from Ids
* Component(s): ES_TaskTableEditor.cmp
* Parameters : taskIds
* Return Values: tasks list
* ***********************************************/   
    @AuraEnabled
    public static List<ES_Task__c> getTasksList(List<ID> taskIds) {
        List<ES_Task__c> items = new List<ES_Task__c>();
        List<String> lstOfTaskFields = new List<String>{'Id','Assigned_To1__c'};
        //Calling util method to check CRUD
        if(taskIds != null && taskIds.size() > 0 && ES_Utility.validateCRUD('ES_Task__c', lstOfTaskFields, 'isAccessible')) {
            items = [select Id, Assigned_To1__c from ES_Task__c where Id IN: taskIds limit :limits.getLimitQueryRows()];
            return items;
        }else{
            throw new AuraHandledException('You don\'t have access to ES Task. Please contact system administrator.');
        }
    }
}