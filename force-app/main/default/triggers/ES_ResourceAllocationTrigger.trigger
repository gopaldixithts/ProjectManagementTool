/******************************************************************************
 @ Trigger Name : ES_ResourceAllocationTrigger
 @ Description : Trigger to revoke and give access to ES Inspection for resources
 @ Test Class : ES_ResourceAllocationTriggerTest (84%)	
 * ***************************************************************************/
 
trigger ES_ResourceAllocationTrigger on ES_Resource_Allocation__c (after insert, before delete, after update) {
  //NOTE : Exceptional logic added to deactivate the trigger
  //Logic to block trigger if required using custom label
    Boolean isActive;
    try{
      isActive = ES_Utility.getESSettings('Default').Allocation_Trigger_Status__c;
    }
    catch(Exception e){
        isActive = true;
    }
    
    //If the setting is active, run the trigger logic
    if(isActive){
        if(trigger.isbefore && trigger.isdelete)
        {
            //restrict Deletion If Task Is Assigned to resource
                ES_ResourceAllocationTriggerHelper.restrictDeletionIfTaskIsAssigned(trigger.old);
            //Share Inspection with Inspection members
                ES_ResourceAllocationTriggerHelper.revokeInspectionAccess(trigger.old);            
        }
        if(trigger.isafter && trigger.isInsert)
        {
            //Share Inspection with Inspection members
                ES_ResourceAllocationTriggerHelper.shareInspectionWithEditAccess(trigger.new);        
        }
        
        if(trigger.isafter && trigger.isUpdate) 
        {
            //If Inspection members get changed update sharing for them 
                ES_ResourceAllocationTriggerHelper.updateSharingOnResourceChange(trigger.oldMap, trigger.newMap);        
        }
    }
}