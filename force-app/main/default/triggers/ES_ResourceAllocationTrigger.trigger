/******************************************************************************
 @ Trigger Name : ES_ResourceAllocationTrigger
 @ Description : Trigger to revoke and give access to ES project for resources
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
            //Share project with project members
                ES_ResourceAllocationTriggerHelper.revokeProjectAccess(trigger.old);            
        }
        if(trigger.isafter && trigger.isInsert)
        {
            //Share project with project members
                ES_ResourceAllocationTriggerHelper.shareProjectWithEditAccess(trigger.new);        
        }
        
        if(trigger.isafter && trigger.isUpdate) 
        {
            //If project members get changed update sharing for them 
                ES_ResourceAllocationTriggerHelper.updateSharingOnResourceChange(trigger.oldMap, trigger.newMap);        
        }
    }
}