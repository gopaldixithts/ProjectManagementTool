/******************************************************************************
@ ClassName : ES_ResourceAllocationTriggerHelper
@ Description : Its a helper class for ES_ResourceAllocationTrigger. It contains methods to revoke and give access to ES Inspection for resources
@ Test Class : ES_ResourceAllocationTriggerTest (90%)
* ***************************************************************************/
public with sharing class ES_ResourceAllocationTriggerHelper{
    
    /**********************************************************************************************
* Method Name: restrictDeletionIfTaskIsAssigned
* Params : List of Resource Allocation
* @description : check if task is assigned or not before deletion
* Returns : void
* **********************************************************************************************/
    public static void restrictDeletionIfTaskIsAssigned(List<ES_Resource_Allocation__c> recs)
    {
        List<ID>userid=new list<id>();
        List<ID>Inspectionid=new list<id>();
        try {
            for(ES_Resource_Allocation__c rec : recs)
            {
                userid.add(rec.Allocated_Resource_Id__c);
                Inspectionid.add(rec.Inspection__c);
            }
            //Calling util method to check CRUD
            List<String> lstOfTaskFields = new List<String>{'Assigned_To1__c', 'Name','Id', 'Inspection_Id__c'};
                if(ES_Utility.validateCRUD('ES_Task__c', lstOfTaskFields, 'isAccessible')){
<<<<<<< HEAD
<<<<<<< HEAD
                    List<ES_Task__c> tasklist=[SELECT id,name,Assigned_To1__c,Phase__r.ES_Inspection__c FROM ES_Task__c WHERE Assigned_To1__c IN :userid AND Inspection_Id__c IN :Inspectionid limit :Limits.getLimitQueries()];
=======
                    List<ES_Task__c> tasklist=[SELECT id,name,Assigned_To1__c,Phase__r.Inspection__c FROM ES_Task__c WHERE Assigned_To1__c IN :userid AND Inspection_Id__c IN :Inspectionid limit :Limits.getLimitQueries()];
>>>>>>> 3dc5bb9 (change10)
=======
                    List<ES_Task__c> tasklist=[SELECT id,name,Assigned_To1__c,Phase__r.ES_Inspection__c FROM ES_Task__c WHERE Assigned_To1__c IN :userid AND Inspection_Id__c IN :Inspectionid limit :Limits.getLimitQueries()];
>>>>>>> f6a11f4 (change20)
                    for(ES_Resource_Allocation__c rec : recs)
                    {
                        for(ES_Task__c taskRec : tasklist)
                        {
<<<<<<< HEAD
<<<<<<< HEAD
                            if(!String.isEmpty(rec.Allocated_Resource_Id__c) && rec.Allocated_Resource_Id__c == taskRec.Assigned_To1__c && rec.ES_Inspection__c == taskRec.Phase__r.Inspection__c){
=======
                            if(!String.isEmpty(rec.Allocated_Resource_Id__c) && rec.Allocated_Resource_Id__c == taskRec.Assigned_To1__c && rec.Inspection__c == taskRec.Phase__r.Inspection__c){
>>>>>>> 3dc5bb9 (change10)
=======
                            if(!String.isEmpty(rec.Allocated_Resource_Id__c) && rec.Allocated_Resource_Id__c == taskRec.Assigned_To1__c && rec.ES_Inspection__c == taskRec.Phase__r.Inspection__c){
>>>>>>> f6a11f4 (change20)
                                rec.addError('Resource can not be deleted, as resource is assigned to a task');
                            }               
                        }
                    }
                }
        } catch(Exception e) {
            System.debug('Error in checkiftaskassigned: '+e.getMessage());
            throw new AuraHandledException('Record can not be deleted. As it is assigned to task');
        }
    }
    
    /**********************************************************************************************
* Method Name: updateSharingOnResourceChange
* Params : Map of old and new Resource allocations
* @description : Revoke access for resources who get removed and give access to who gets added as new
* Returns : void
* **********************************************************************************************/
    public static void updateSharingOnResourceChange(Map<Id, ES_Resource_Allocation__c> mapOfOldRecs, Map<Id, ES_Resource_Allocation__c> mapOfNewRecs)
    {
        List<ES_Resource_Allocation__c> lstOfResourcesToRemoveAccess = new List<ES_Resource_Allocation__c>();
        List<ES_Resource_Allocation__c> lstOfResourcesToGiveAccess = new List<ES_Resource_Allocation__c>();
        
        for(ES_Resource_Allocation__c allocRec : mapOfNewRecs.values()){
            if(mapOfOldRecs.get(allocRec.Id).Resource_Availability__c != allocRec.Resource_Availability__c){
                lstOfResourcesToRemoveAccess.add(mapOfOldRecs.get(allocRec.Id));
                lstOfResourcesToGiveAccess.add(allocRec);
            }
        }
        
        if(!lstOfResourcesToRemoveAccess.isEmpty()){
            revokeInspectionAccess(lstOfResourcesToRemoveAccess);
        }
        
        if(!lstOfResourcesToGiveAccess.isEmpty()){
            shareInspectionWithEditAccess(lstOfResourcesToGiveAccess);
        }
    }
    
    /***********************************************************************************************
* Method Name:revokeInspectionAccess
* Params : List of resource allocations
* @description : Revoke Inspection access from old resources
* Returns : void
* *********************************************************************************************/
    public static void revokeInspectionAccess(List<ES_Resource_Allocation__c> lstOfResourcesToRemoveAccess){
        Map<Id,Id> mapOfResAllAndResAvail = new Map<Id,Id>();
        Map<Id,Id> mapOfResAllAndInspection = new Map<Id,Id>();
        Map<Id,Id> mapOfResourceAvailAndUser = new Map<Id,Id>();
<<<<<<< HEAD
<<<<<<< HEAD
        List<Inspection__Share> lstOfShareRecToBeDeleted = new List<Inspection__Share>();
=======
        List<ES_Inspection__Share> lstOfShareRecToBeDeleted = new List<ES_Inspection__Share>();
>>>>>>> 3dc5bb9 (change10)
=======
        List<Inspection__Share> lstOfShareRecToBeDeleted = new List<Inspection__Share>();
>>>>>>> 7e49b80 (change11)
        List<ES_Error_Log__c> lstOfErrorLogs = new List<ES_Error_Log__c>();
        try {
            for(ES_Resource_Allocation__c allocationRec : lstOfResourcesToRemoveAccess){
                mapOfResAllAndResAvail.put(allocationRec.Id, String.escapeSingleQuotes(allocationRec.Resource_Availability__c));
<<<<<<< HEAD
<<<<<<< HEAD
                mapOfResAllAndInspection.put(allocationRec.Id, String.escapeSingleQuotes(allocationRec.ES_Inspection__c));
=======
                mapOfResAllAndInspection.put(allocationRec.Id, String.escapeSingleQuotes(allocationRec.Inspection__c));
>>>>>>> 3dc5bb9 (change10)
=======
                mapOfResAllAndInspection.put(allocationRec.Id, String.escapeSingleQuotes(allocationRec.ES_Inspection__c));
>>>>>>> f6a11f4 (change20)
            }
            
            for(ES_Resource_Availability__c availabilityRec : [SELECT Id, User__c FROM ES_Resource_Availability__c WHERE Id IN: mapOfResAllAndResAvail.values() limit :Limits.getLimitQueries()]){
                mapOfResourceAvailAndUser.put(availabilityRec.Id, availabilityRec.User__c);
            }
            
<<<<<<< HEAD
<<<<<<< HEAD
            for(Inspection__Share shareRec : [Select ParentId, UserOrGroupId from Inspection__Share where ParentId IN: mapOfResAllAndInspection.values() and UserOrGroupId IN: mapOfResourceAvailAndUser.values() limit :Limits.getLimitQueries()]){
                for(ES_Resource_Allocation__c allocationRec : lstOfResourcesToRemoveAccess){
                    if(allocationRec.ES_Inspection__c == shareRec.ParentId && mapOfResourceAvailAndUser.get(mapOfResAllAndResAvail.get(allocationRec.Id)) == shareRec.UserOrGroupId){
<<<<<<< HEAD
=======
            for(ES_Inspection__Share shareRec : [Select ParentId, UserOrGroupId from ES_Inspection__Share where ParentId IN: mapOfResAllAndInspection.values() and UserOrGroupId IN: mapOfResourceAvailAndUser.values() limit :Limits.getLimitQueries()]){
=======
            for(Inspection__Share shareRec : [Select ParentId, UserOrGroupId from Inspection__Share where ParentId IN: mapOfResAllAndInspection.values() and UserOrGroupId IN: mapOfResourceAvailAndUser.values() limit :Limits.getLimitQueries()]){
>>>>>>> 7e49b80 (change11)
                for(ES_Resource_Allocation__c allocationRec : lstOfResourcesToRemoveAccess){
                    if(allocationRec.Inspection__c == shareRec.ParentId && mapOfResourceAvailAndUser.get(mapOfResAllAndResAvail.get(allocationRec.Id)) == shareRec.UserOrGroupId){
>>>>>>> 3dc5bb9 (change10)
=======
>>>>>>> f6a11f4 (change20)
                        lstOfShareRecToBeDeleted.add(shareRec);
                    }
                }
            }
            if(!lstOfShareRecToBeDeleted.isEmpty()){
                Database.DeleteResult[] srList = Database.Delete(lstOfShareRecToBeDeleted, false);
                for (Database.DeleteResult dr : srList) {
                    if (!dr.isSuccess()){ 
                        // Operation failed, so get all errors                
                        for(Database.Error err : dr.getErrors()) {
                            lstOfErrorLogs.add(new ES_Error_Log__c(Apex_Class__c='ES_ResourceAllocationTriggerHelper', Error_Message__c = err.getMessage() + 'and fields that affected this error:' + err.getFields(), Method_Name__c = 'revokeInspectionAccess'));
                        }
                    }
                }
            }
        } catch(Exception e) {
            lstOfErrorLogs.add(new ES_Error_Log__c(Apex_Class__c='ES_ResourceAllocationTriggerHelper', Error_Message__c = e.getMessage() , Method_Name__c = 'revokeInspectionAccess'));
        }
        
        if(!lstOfErrorLogs.isEmpty()){
            //Calling util method to check CRUD
            List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                    INSERT lstOfErrorLogs;
                }
        }           
    }
    
    /**********************************************************************************************
* Method Name:shareInspectionWithEditAccess
* Params : List of resource allocations
* @description : Share Inspection with new resources
* Returns : void
* *********************************************************************************************/
    public static void shareInspectionWithEditAccess(List<ES_Resource_Allocation__c> lstOfResourcesToRemoveAccess){
        Map<Id,Id> mapOfResAllAndResAvail = new Map<Id,Id>();
        Map<Id,Id> mapOfResourceAvailAndUser = new Map<Id,Id>();
        List<ES_Error_Log__c> lstOfErrorLogs = new List<ES_Error_Log__c>();
        try {
<<<<<<< HEAD
<<<<<<< HEAD
            List<Inspection__Share> lsToInsert = new List<Inspection__Share>();
=======
            List<ES_Inspection__Share> lsToInsert = new List<ES_Inspection__Share>();
>>>>>>> 3dc5bb9 (change10)
=======
            List<Inspection__Share> lsToInsert = new List<Inspection__Share>();
>>>>>>> 7e49b80 (change11)
            
            for(ES_Resource_Allocation__c allocationRec : lstOfResourcesToRemoveAccess){
                mapOfResAllAndResAvail.put(allocationRec.Id, allocationRec.Resource_Availability__c);
            }
            
            for(ES_Resource_Availability__c availabilityRec : [SELECT Id, User__c FROM ES_Resource_Availability__c WHERE Id IN: mapOfResAllAndResAvail.values() limit :Limits.getLimitQueries()]){
                mapOfResourceAvailAndUser.put(availabilityRec.Id, availabilityRec.User__c);
            }
            
            for(ES_Resource_Allocation__c allocationRec : lstOfResourcesToRemoveAccess){
<<<<<<< HEAD
<<<<<<< HEAD
                Inspection__Share projShareObj = new Inspection__Share();
                projShareObj.ParentId = allocationRec.ES_Inspection__c;
                projShareObj.UserOrGroupId = mapOfResourceAvailAndUser.get(mapOfResAllAndResAvail.get(allocationRec.Id));               
                projShareObj.AccessLevel = 'Edit';
                projShareObj.RowCause = Schema.Inspection__Share.RowCause.Inspection_Member__c;
=======
                ES_Inspection__Share projShareObj = new ES_Inspection__Share();
                projShareObj.ParentId = allocationRec.Inspection__c;
                projShareObj.UserOrGroupId = mapOfResourceAvailAndUser.get(mapOfResAllAndResAvail.get(allocationRec.Id));               
                projShareObj.AccessLevel = 'Edit';
                projShareObj.RowCause = Schema.ES_Inspection__Share.RowCause.Inspection_Member__c;
>>>>>>> 3dc5bb9 (change10)
=======
                Inspection__Share projShareObj = new Inspection__Share();
                projShareObj.ParentId = allocationRec.ES_Inspection__c;
                projShareObj.UserOrGroupId = mapOfResourceAvailAndUser.get(mapOfResAllAndResAvail.get(allocationRec.Id));               
                projShareObj.AccessLevel = 'Edit';
                projShareObj.RowCause = Schema.Inspection__Share.RowCause.Inspection_Member__c;
>>>>>>> 7e49b80 (change11)
                lsToInsert.add(projShareObj);
            }
            
            if(!lsToInsert.isEmpty()){
                Database.SaveResult[] srList = Database.INSERT(lsToInsert, false);
                for (Database.SaveResult dr : srList) {
                    if (!dr.isSuccess()){ 
                        // Operation failed, so get all errors                
                        for(Database.Error err : dr.getErrors()) {
                            lstOfErrorLogs.add(new ES_Error_Log__c(Apex_Class__c='ES_ResourceAllocationTriggerHelper', Error_Message__c = err.getMessage() + 'and fields that affected this error:' + err.getFields(), Method_Name__c = 'shareInspectionWithEditAccess'));
                        }
                    }
                }
            }
        } catch(Exception e) {
            lstOfErrorLogs.add(new ES_Error_Log__c(Apex_Class__c='ES_ResourceAllocationTriggerHelper', Error_Message__c = e.getMessage() , Method_Name__c = 'shareInspectionWithEditAccess'));
        }
        
        if(!lstOfErrorLogs.isEmpty()){
            //Calling util method to check CRUD
            List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                    INSERT lstOfErrorLogs;
                }
        }           
    }
}