/*****************************************************************************************
* Name: ES_Utility
* Referenced components: 
- ES_CaseDataTable.cmp
* Test class : ES_Testcoverage (96%)
******************************************************************************************/
public with sharing class ES_Utility {
    /*****************************************************************************************
* Method Name: getCasesForInspection
* Description: Get list of Cases for a Inspection for the Case Datatable on Inspection Summary page. Used in ES_CaseDataTable component
* Parameters : Inspection recordId
* Return Values: list of cases
* *****************************************************************************************/  
    @AuraEnabled
    public static List<Case> getCasesForInspection(Id recordId){    
        List<case> cases = new List<case>();
        //Calling util method to check CRUD
        List<String> lstOfCaseFields = new List<String>{'CaseNumber', 'Subject', 'ES_Days_Open__c', 'Description', 'Type', 'Status', 'Priority', 'Inspection__c'};        
            boolean hasAccess = validateCRUD('Case', lstOfCaseFields, 'isAccessible');
        
        if(hasAccess){  
            cases = [SELECT id,CaseNumber,Subject,ES_Days_Open__c,Description,Type,Status,Priority,Inspection__c FROM Case 
<<<<<<< HEAD
<<<<<<< HEAD
                     WHERE Inspection__c =:recordId AND RecordType.DeveloperName =: System.Label.ES_Inspection_Record_Type_on_Case ORDER BY Priority ASC, Type ASC limit: limits.getLimitQueryRows()];                                     
=======
                     WHERE Inspection__c =:recordId AND RecordType.DeveloperName =: System.Label.ES_Project_Record_Type_on_Case ORDER BY Priority ASC, Type ASC limit: limits.getLimitQueryRows()];                                     
>>>>>>> 01eee72 (Change2)
=======
                     WHERE Inspection__c =:recordId AND RecordType.DeveloperName =: System.Label.ES_Inspection_Record_Type_on_Case ORDER BY Priority ASC, Type ASC limit: limits.getLimitQueryRows()];                                     
>>>>>>> 3dc5bb9 (change10)
            return cases;
            
        }else{
            throw new AuraHandledException('You don\'t have access to related Cases. Please contact system administrator.');
        } 
    }
    
    /*****************************************************************************************
* Method Name: validateCRUD
* Description: Generic method to check CRUD access on object and fields
* Parameters : sObject API name, list of fields, type of access to check
* Return Values: boolean
* *****************************************************************************************/  
    public static boolean validateCRUD(String sObjectName, List<String> lstOfFieldAPIs, String accessCheck){    
        
        
            sObjectName = sObjectName;
      
        Schema.DescribeSobjectResult[] result = Schema.describeSObjects(new String[]{sObjectName});
        
        Map<String, Schema.SObjectField> fieldMap = result[0].fields.getMap();
        
        if(lstOfFieldAPIs == null ){ // Check object level access
            if( (accessCheck.equalsIgnoreCase('isDeletable') && result[0].isDeletable()) ||
               (accessCheck.equalsIgnoreCase('isUpdateable') && result[0].isUpdateable()) ||
               (accessCheck.equalsIgnoreCase('isCreateable') && result[0].isCreateable()) ||
               (accessCheck.equalsIgnoreCase('isAccessible') && result[0].isAccessible())) {
                   return true;
               }else{
                   return false;
               }
        } else if(lstOfFieldAPIs != null){// Check field level access 
            for (String field : lstOfFieldAPIs) {
               
                    field = field;
                if (accessCheck.equalsIgnoreCase('isAccessible') && !fieldMap.get(field).getDescribe().isAccessible()) {
                    return false;
                }else if (accessCheck.equalsIgnoreCase('isUpdateable') && !fieldMap.get(field).getDescribe().isUpdateable()) {
                    return false;
                }else if (accessCheck.equalsIgnoreCase('isCreateable') && !fieldMap.get(field).getDescribe().isCreateable()) {
                    return false;
                }
            }
            return true;
        }else{
            return false;
        }        
    }
    
    /*****************************************************************************************
* Method Name: getESSettings
* Description: Get settings stored in mdt
* Parameters : settingName
* Return Values: ES_Setting__mdt
* *****************************************************************************************/    
    public static ES_Setting__mdt getESSettings(String settingName){
        ES_Setting__mdt settings;
        try{
            settings = [select id, MasterLabel, DeveloperName, Allocation_Trigger_Status__c, Default_Availability_for_Scheduler__c, Resource_Planning_Years_in_Advance__c, Start_Month_of_Fiscal_Year__c from ES_Setting__mdt where DeveloperName=:settingName with security_enforced limit 1];
        }
        catch(Exception e){
            //If settings not found, create record to return
            settings = new ES_Setting__mdt();
            settings.MasterLabel='Default';
            settings.DeveloperName='Default';
            settings.Allocation_Trigger_Status__c = false;
            settings.Default_Availability_for_Scheduler__c = 100;
            settings.Resource_Planning_Years_in_Advance__c = 2;
            settings.Start_Month_of_Fiscal_Year__c = 2;
            
            List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                    INSERT new ES_Error_Log__c(Apex_Class__c='ES_Utility', Error_Message__c = e.getMessage() , Method_Name__c = 'getESSettings');
                }
        }
        return settings;
    }
    
    /*****************************************************************************************
* Method Name: getPicklistValues
* Description: Get the picklist values and labels 
* Parameters : Object API name and field API name
* Return Values: Map of picklist label and value
* *****************************************************************************************/  
    public static Map<String, String> getPicklistValues(String objectAPI, String fieldAPI){   
        
        
            
                objectAPI = objectAPI;
            
                fieldAPI =  fieldAPI;
            
        
        Map<String, String> mapOfResult = new Map<String, String>();
        Schema.SObjectType objMetadata = Schema.getGlobalDescribe().get(objectAPI) ;
        Schema.DescribeSObjectResult result = objMetadata.getDescribe() ;
        Map<String,Schema.SObjectField> fields = result.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldAPI).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            mapOfResult.put(pickListVal.getLabel(), pickListVal.getValue());
        }       
        return mapOfResult;
    }
}