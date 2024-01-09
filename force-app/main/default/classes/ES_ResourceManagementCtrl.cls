/*************************************************
* Name: ES_ResourceManagementCtrl
* Description: Lightning component helper for resource allocation
* Author : Shekhar Gawali
* Used By : ESResourceManagementTab (LWC),
            ES_MassResourceAllocationContainer.cmp, 
            ES_MassResourceAllocation.cmp, 
            ES_ResourceAvailabilityDataTable.cmp
* Test class : ES_Testcoverage(93%)
* ***********************************************/
public with sharing class ES_ResourceManagementCtrl {
    
    Public class ResourceDetail
    {
        @AuraEnabled
        public List<ES_Resource_Availability__c> ResourceAvailabilities; //All the available resources
        @AuraEnabled
        public List<ES_Resource_Allocation__c> ResourceAllocations; //Allocations for the Inspection
        @AuraEnabled
        public List<ES_Resource_Availability__c> dummyAvailabilities; //dummy availabilities with no user
        @AuraEnabled
        public List<String> roles;  //Roles for picklist
        @AuraEnabled
        public Boolean isCreatable;
        @AuraEnabled
        public Integer fiscalYearOffset;
    }
    
    /*****************************************************************
    * Method Name : getResourceDetailsWrapper
    * Params : Inspection record
    * Retrun : ResourceDetailWrapper
    * Description : Get data using SOQL and transform to wrapper
    * **************************************************************/
    @AuraEnabled
<<<<<<< HEAD
    public static ResourceDetail getResourceDetailsWrapper(Inspection__c Inspection)
=======
    public static ResourceDetail getResourceDetailsWrapper(Inspection__c project)
>>>>>>> 01eee72 (Change2)
    {
        try{                
            //Generate wrapper
            ResourceDetail resource = new ResourceDetail();
            
            List<String> lstOfAllocationFields = new List<String>{'Id','Role__c','Resource_Availability__c', 'Jan__c','Feb__c','Mar__c','Apr__c','May__c','Jun__c','Jul__c','Aug__c','Sep__c','Oct__c','Nov__c','Dec__c','Fiscal_Year__c','Inspection__c'};
                
                List<String> lstOfAvailabilityFields = new List<String>{'User__c','Feb_Remaining__c','Mar_Remaining__c','Apr_Remaining__c','May_Remaining__c','Jun_Remaining__c','Jul_Remaining__c','Aug_Remaining__c','Sep_Remaining__c','Oct_Remaining__c','Nov_Remaining__c','Dec_Remaining__c', 'Jan_Remaining__c','Id','fiscal_year__c', 'Start_Date__c', 'End_Date__c'};
                    
                    List<String> lstOfUsersFields = new List<String>{'Name','SmallPhotoURL','ManagerId','IsActive'};
                        List<String> lstOfInspectionFields = new List<String>{'Start_Fiscal_Year__c','End_Fiscal_Year__c','Deadline_formula__c','Kickoff_formula__c'};
            
                            if(ES_Utility.validateCRUD('ES_Resource_Allocation__c', lstOfAllocationFields, 'isAccessible') && 
                               ES_Utility.validateCRUD('ES_Resource_Availability__c', lstOfAvailabilityFields, 'isAccessible') && 
                               ES_Utility.validateCRUD('User', lstOfUsersFields, 'isAccessible') && 
<<<<<<< HEAD
                               ES_Utility.validateCRUD('Inspection__c', lstOfInspectionFields, 'isAccessible')){
=======
                               ES_Utility.validateCRUD('Inspection__c', lstOfProjectFields, 'isAccessible')){
>>>>>>> 01eee72 (Change2)
                                   
                                   resource.ResourceAllocations = getResourceAllocation(Inspection.Id);
                                   
                                   //calculate fiscal years using start and end
                                   Integer startFiscal = Integer.valueOf(Inspection.Start_Fiscal_Year__c.mid(2,2));
                                   Integer endFiscal = Integer.valueOf(Inspection.End_Fiscal_Year__c.mid(2,2));
                                   Integer difference = endFiscal - startFiscal;
                                   List<String> years = new List<String>();
                                   for(integer i=0;i<=difference;i++){
                                       years.add('FY' + (startFiscal+i));
                                   }
                                   
                                   resource.ResourceAvailabilities = getAvailibility(years, Inspection);
                                   resource.dummyAvailabilities = getDummyAvailabilities(years, Inspection);
                                   resource.roles = getRolesPickVals();
                                   resource.isCreatable = Schema.sObjectType.ES_Resource_Allocation__c.isCreateable();
                                   resource.fiscalYearOffset = Integer.valueOf(getESSettings().Start_Month_of_Fiscal_Year__c);
                                   return resource;
                               }else{
                                   throw new AuraHandledException('Access restricted. Please contact system administrator.');          
                               }
        }
        catch(Exception e){
            system.debug(e.getStackTraceString());
            List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                    INSERT new ES_Error_Log__c(Apex_Class__c='ES_ResourceManagementCtrl', Error_Message__c = e.getMessage() , Method_Name__c = 'getResourceDetailsWrapper');
                }
            return null;
        }
    }
    
    /*****************************************************************
    * Method Name : upsertDeleteAllocation
    * Params : List of allocations to save, list of allocations to delete
    * Retrun : n/a
    * Description : upsert/delete the allocation records
    * **************************************************************/
    @AuraEnabled
<<<<<<< HEAD
    public static void upsertDeleteAllocation(List<SObject> allocationsToSave, List<SObject> allocationsToDelete, Inspection__c Inspection){
=======
    public static void upsertDeleteAllocation(List<SObject> allocationsToSave, List<SObject> allocationsToDelete, Inspection__c project){
>>>>>>> 01eee72 (Change2)
        //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Resource_Allocation__c', null, 'isCreateable') && ES_Utility.validateCRUD('ES_Resource_Allocation__c', null, 'isUpdateable')){   
            //check if anything to upsert
            if(allocationsToSave!=null){
                List<ES_Resource_Allocation__c> allocations = new List<ES_Resource_Allocation__c>();
                allocations.addAll((List<ES_Resource_Allocation__c>)allocationsToSave);
                try{
                    UPSERT allocations;
                }catch(Exception e){
                    List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                        if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                            INSERT new ES_Error_Log__c(Apex_Class__c='ES_ResourceManagementCtrl', Error_Message__c = e.getMessage() , Method_Name__c = 'upsertDeleteAllocation');
                        }
                }
            }
        }else{
            throw new AuraHandledException('You don\'t have access to update/Insert ES resource allocation. Please contact system administrator.');            
        }
        
        //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Resource_Allocation__c', null, 'isDeletable') ){       
            //Check if anything to delete
            if(allocationsToDelete!=null){
                DELETE allocationsToDelete;
            }
        }else{
            throw new AuraHandledException('You don\'t have access to delete ES resource allocation. Please contact system administrator.');       
        }       
        
    }
    
    /*****************************************************************
    * Method Name : getRolesPickVals
    * Params : n/a
    * Retrun : List of picklist values
    * Description : Get picklist values of role from resource allocations
    * **************************************************************/
    private static List<String> getRolesPickVals(){
        //call resusable method
        return ES_TaskandPhaseManagementCtrl.getPicklistvalues('ES_Resource_Allocation__c', 'Role__c', false);
    }
    
    /*****************************************************************
    * Method Name : getResourceAllocation
    * Params : Inspection record Id
    * Retrun : List of resource allocations
    * Description : Get allocations using SOQL and transform to wrapper
    * **************************************************************/
    private static List<ES_Resource_Allocation__c> getResourceAllocation(Id InspectionId)
    {
        List<ES_Resource_Allocation__c> allocations = new List<ES_Resource_Allocation__c>();       
        allocations = [select id,Role__c,Resource_Availability__r.User__c,Resource_Availability__r.is_Dummy_Availability__c,
                       Resource_Availability__r.User__r.Name,Resource_Availability__r.User_Id__c, Resource_Availability__r.User__r.SmallPhotoURL,
                       Resource_Availability__r.User__r.ManagerId,Inspection__r.Start_Fiscal_Year__c,
                       Inspection__r.End_Fiscal_Year__c,Inspection__r.Deadline_formula__c,Inspection__r.Kickoff_formula__c,
                       Jan__c,Feb__c,Mar__c,Apr__c,May__c,Jun__c,Jul__c,Aug__c,Sep__c,Oct__c,
                       Nov__c,Dec__c,Fiscal_Year__c
                       from ES_Resource_Allocation__c where Inspection__c=:InspectionId order by Role__c desc limit :limits.getLimitQueryRows()];
        
        return allocations;
    }
    
    
    /*****************************************************************
    * Method Name : getAvailibility
    * Params : Inspection record
    * Retrun : list of reousrce availability
    * Description : Get availabilities using SOQL and transform to wrapper
    * **************************************************************/
<<<<<<< HEAD
    private static List<ES_Resource_Availability__c> getAvailibility(List<String> years, Inspection__c Inspection)
=======
    private static List<ES_Resource_Availability__c> getAvailibility(List<String> years, Inspection__c project)
>>>>>>> 01eee72 (Change2)
    {
        List<ES_Resource_Availability__c> ls = new List<ES_Resource_Availability__c>();
        
        ls = [select User_Id__c,is_Dummy_Availability__c, Feb_Remaining__c,Mar_Remaining__c,Apr_Remaining__c,
              May_Remaining__c,Jun_Remaining__c,Jul_Remaining__c,
              Aug_Remaining__c,Sep_Remaining__c,Oct_Remaining__c,
              Nov_Remaining__c,Dec_Remaining__c, Jan_Remaining__c,
              id,User__c, User__r.name,User__r.SmallPhotoUrl,User__r.ManagerId,
              fiscal_year__c, Start_Date__c, End_Date__c from ES_Resource_Availability__c
              where fiscal_year__c in :years and User_Name__c!='' and User_IsActive__c = true order by User_Name__c limit :limits.getLimitQueryRows()];
        return ls;
    }
    
    /*****************************************************************
    * Method Name : getDummyAvailabilities
    * Params : Inspection record
    * Retrun : list of availabilities with no user
    * Description : Get availabilities using SOQL and transform to wrapper
    * **************************************************************/
<<<<<<< HEAD
    private static List<ES_Resource_Availability__c> getDummyAvailabilities(List<String> years, Inspection__c Inspection)
=======
    private static List<ES_Resource_Availability__c> getDummyAvailabilities(List<String> years, Inspection__c project)
>>>>>>> 01eee72 (Change2)
    {
        List<ES_Resource_Availability__c> dummyAvailablities = new List<ES_Resource_Availability__c>();
        
        dummyAvailablities = [select Id,User__c,User__r.Name,User__r.SmallPhotoUrl,User__r.Id, 
                              Fiscal_Year__c from ES_Resource_Availability__c
                              WHERE User__c = '' AND Fiscal_Year__c IN: years limit :limits.getLimitQueryRows()];
        
        return dummyAvailablities;
    }
    
    /*************************************************
    * Name: AvailabilityWrapper
    * Description: Wrapper for Avaialbility and whether records are editble. It is used in ES_ResourceAvailabilityDataTable.cmp
    * ***********************************************/
    public class AvailabilityWrapper{
        @AuraEnabled
        public boolean isResourcePlanner;
        @AuraEnabled
        public List<ES_Resource_Allocation__c> resourceAvailabilities;
    }
    
    /************************************************
    * Method Name: getAllocationsForResource 
    * Description: Get allocations for resource. It is used in ES_ResourceAvailabilityDataTable.cmp
    * Parameters : resourceid, fiscalYear
    * Return Values: list of allocation
    * ***********************************************/    
    @AuraEnabled
    public static AvailabilityWrapper getAllocationsForResource(Id resourceId, String fiscalYear)
    {
        List<String> lstOfAllocationFields = new List<String>{'Id','Name','Role__c','Inspection_Owner__c','Resource_Availability__c','Inspection__c','Inspection_Name__c','Fiscal_Year__c','Resource_Name__c','Feb__c','Mar__c','Apr__c','May__c','Jun__c','Jul__c','Aug__c','Sep__c','Oct__c','Nov__c','Dec__c','Jan__c'};
            //Calling util method to check CRUD
            if(ES_Utility.validateCRUD('ES_Resource_Allocation__c', lstOfAllocationFields, 'isAccessible')){
                AvailabilityWrapper wrapper = new AvailabilityWrapper();
                wrapper.resourceAvailabilities = [SELECT id,Name,Role__c,Inspection_Owner__c,Resource_Availability__c,Inspection__c,Inspection_Name__c,  Fiscal_Year__c,Resource_Name__c,Feb__c,Mar__c,Apr__c,May__c,Jun__c,Jul__c,Aug__c,Sep__c,Oct__c,Nov__c,Dec__c,Jan__c FROM ES_Resource_Allocation__c WHERE Resource_Availability__c=:resourceId And Fiscal_Year__c=:fiscalYear order by Inspection_Name__c ASC, Name ASC limit: limits.getLimitQueryRows()];                                    
                
                wrapper.isResourcePlanner = Schema.sObjectType.ES_Resource_Availability__c.isCreateable();
                return wrapper;
            }else{
                throw new AuraHandledException('You don\'t have access to ES resource allocations. Please contact system administrator.');
            }   
    }
    
    /*************************************************
    * Method Name: updateAllocations
    * Description: Update allocations. It is used in ES_ResourceAvailabilityDataTable.cmp
    * Parameters : allocations
    * Return Values: list of allocations
    * ***********************************************/
    @AuraEnabled
    public static List<ES_Resource_Allocation__c> updateAllocations(List<ES_Resource_Allocation__c> allocations){
        //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Resource_Allocation__c', null, 'isUpdateable')){   
            try {               
                UPDATE allocations;
                return allocations;
            } catch(Exception e) {
                //Calling util method to check CRUD
                List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                    if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                        INSERT new ES_Error_Log__c(Apex_Class__c='ES_ResourceManagementCtrl', Error_Message__c = e.getMessage() , Method_Name__c = 'updateAllocations');
                    }
                return null;
            }
        }else{
            throw new AuraHandledException('You don\'t have access to update ES resource allocations. Please contact system administrator.');
        }   
    }  
    
    /*************************************************
    * Method Name: deleteRecord
    * Description: delete records. It is used in ES_ResourceAvailabilityDataTable.cmp
    * Parameters : recordToDelete
    * Return Values: null
    * ***********************************************/
    @auraEnabled
    public static Boolean deleteRecord(sObject recordToDelete) {
        //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Resource_Allocation__c', null, 'isDeletable')){    
            try {
                delete recordToDelete;
                return true;
            } catch(Exception e) {
                //Calling util method to check CRUD
                List<String> lstOfLogFields = new List<String>{'Apex_Class__c', 'Error_Message__c','Method_Name__c'};
                    if(ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')){
                        INSERT new ES_Error_Log__c(Apex_Class__c='ES_ResourceManagementCtrl', Error_Message__c = e.getMessage() , Method_Name__c = 'deleteRecord');
                    }
                return false;
            }
        }else{
            throw new AuraHandledException('You don\'t have access to delete ES resource allocations. Please contact system administrator.');
        }   
    }
    
    /*************************************************
    * Method Name: getESSettings
    * Description: gets the settings for the ES. It is used in ES_ResourceAvailibilityDisplay.cmp
    * Parameters : N/A
    * Return Values: ES_Setting__mdt
    * ***********************************************/
    @AuraEnabled
    public static ES_Setting__mdt getESSettings() {
        return ES_Utility.getESSettings('Default');
    }
    
    /************************** RESOURCE MANAGEMENT TAB **********************************/
    /*************************************************
    * Method Name: getFilters
    * Description: get the filter Values to be displayed in the picklists
    * Parameters : n/a
    * Return Values: list of list of values
    * ***********************************************/
    @AuraEnabled(cacheable=true)
    public static List<List<string>> getFilters(){
        List<String> lstOfAvailabilityFields = new List<String>{'User__c','Fiscal_Year__c','User_IsActive__c','User_Name__c'};
        List<String> lstOfUserFields = new List<String>{'Department'};
        if(ES_Utility.validateCRUD('ES_Resource_Availability__c', lstOfAvailabilityFields, 'isAccessible') && ES_Utility.validateCRUD('User', lstOfUserFields, 'isAccessible')){
            List<List<string>> filters = new List<List<string>>();
            //ES Department Values
            Set<String> picklistESDepartments = new Set<string>();
            //Fiscal Years
            Set<string> fiscalYears = new Set<string>();
            //Aggregate query to get all the utilized values for regions, fiscal years and departments from availability
            for(AggregateResult ar : [select count(Id),Fiscal_Year__c year,User__r.Department dept from ES_Resource_Availability__c group by Fiscal_Year__c, User__r.Department limit :limits.getLimitQueryRows()]){
                fiscalYears.add((String)ar.get('year'));
                picklistESDepartments.add((String)ar.get('dept')==null?'':(String)ar.get('dept'));
            }
            filters.add(new List<string>(picklistESDepartments));
            filters.add(new List<string>(fiscalYears));
            filters.add(new List<string>{String.valueOf(getESSettings().Start_Month_of_Fiscal_Year__c)});
            return filters;
        }
        else{
            throw new AuraHandledException('You don\'t have necessary access to ES resource allocations. Please contact system administrator.');
        }
    }
    
    /*************************************************
    * Method Name: getResourceAllocations
    * Description: get the resource availabilities and allocations based on the values selected
    * Parameters : fiscal year, department, manager id, user id and Inspection id
    * Return Values: wrapper with allocation and availabilities
    * ***********************************************/
    @AuraEnabled(cacheable=true)
    public static ResourceDataWrapper getResourceAllocations(String fiscalYear, String selectedDept, String selectedManagerId, String selectedUserId, String selectedInspectionId) {
        List<String> lstOfAllocationFields = new List<String>{'Id','Name','Role__c','Inspection_Owner__c','Resource_Availability__c','Inspection__c','Inspection_Name__c','Fiscal_Year__c','Resource_Name__c','Feb__c','Mar__c','Apr__c','May__c','Jun__c','Jul__c','Aug__c','Sep__c','Oct__c','Nov__c','Dec__c','Jan__c'};
        List<String> lstOfAvailabilityFields = new List<String>{'User__c','Feb_Remaining__c','Mar_Remaining__c','Apr_Remaining__c','May_Remaining__c','Jun_Remaining__c','Jul_Remaining__c','Aug_Remaining__c','Sep_Remaining__c','Oct_Remaining__c','Nov_Remaining__c','Dec_Remaining__c', 'Jan_Remaining__c','Id','fiscal_year__c', 'Start_Date__c', 'End_Date__c'};
        //Calling util method to check CRUD
        if(ES_Utility.validateCRUD('ES_Resource_Availability__c', lstOfAvailabilityFields, 'isAccessible') && ES_Utility.validateCRUD('ES_Resource_Allocation__c', lstOfAllocationFields, 'isAccessible')){
            FINAL integer queryRowLimit = limits.getLimitQueryRows();
            FINAL string dummyAllocationUserName = '';
            ResourceDataWrapper wrapper = new ResourceDataWrapper();
            
            String query = 'select Id, Apr_Allocation__c, Aug_Allocation__c, Dec_Allocation__c, Feb_Allocation__c, Jan_Allocation__c, Jul_Allocation__c, Jun_Allocation__c, Mar_Allocation__c, May_Allocation__c, Nov_Allocation__c, Oct_Allocation__c,';
            query += 'Sep_Allocation__c, Apr_Remaining__c, Aug_Remaining__c, Dec_Remaining__c, Feb_Remaining__c, Jan_Remaining__c, Jul_Remaining__c, Jun_Remaining__c, Mar_Remaining__c, May_Remaining__c, Nov_Remaining__c, Oct_Remaining__c,';
            query += 'Sep_Remaining__c, Fiscal_Year__c, User_Name__c, Apr__c, Aug__c, Dec__c, Feb__c, Jan__c, Jul__c, Jun__c, Mar__c, May__c, Nov__c, Oct__c, Sep__c, Start_Date__c, End_Date__c,User_Department__c from ES_Resource_Availability__c where ';
            query += 'User__r.IsActive=true and User__r.Name!=:dummyAllocationUserName and Fiscal_Year__c=:fiscalYear ';
            if(String.isNotEmpty(selectedManagerId)){
                query += 'and User__r.ManagerId = :selectedManagerId ';
            }
            if(String.isNotEmpty(selectedUserId)){
                query += 'and User__c = :selectedUserId ';
            }
            
            query += 'and User_Department__c = :selectedDept ';
            query += 'with security_enforced order by Name limit :queryRowLimit';
            //Esacpe single quotes for SOQL Injection
            query = String.escapeSingleQuotes(query);
            wrapper.resourceAvailabilities = database.query(query);
            
            query = 'select id,Role__c,Resource_Availability__r.User__c, Inspection_Name__c,Resource_Availability__c,';
            query += 'Inspection__c,Jan__c,Feb__c,Mar__c,Apr__c,May__c,Jun__c,Jul__c,Aug__c,Sep__c,Oct__c,';
            query += 'Nov__c,Dec__c,Fiscal_Year__c,User_Name__c from ES_Resource_Allocation__c where User_Department__c = :selectedDept and Fiscal_Year__c=:fiscalYear ';
            if(String.isNotEmpty(selectedManagerId)){
                query += 'and Resource_Availability__r.User__r.ManagerId = :selectedManagerId ';
            }
            if(String.isNotEmpty(selectedUserId)){
                query += 'and Resource_Availability__r.User__c = :selectedUserId ';
            }
            if(String.isNotEmpty(selectedInspectionId)){
                query += 'and Inspection__c = :selectedInspectionId ';
            }
            query += 'with security_enforced order by Name limit :queryRowLimit';
            //Esacpe single quotes for SOQL Injection
            query = String.escapeSingleQuotes(query);
            wrapper.resourceAllocations = database.query(query);
            return wrapper;
        }
        else{
            throw new AuraHandledException('You don\'t have access to ES resource allocations. Please contact system administrator.');
        }
    }
    
    /*
     * Name : ResourceDataWrapper
     * Description : Wrapper class used by the resource management tab
     * */
    public class ResourceDataWrapper{
        @AuraEnabled
        public List<ES_Resource_Availability__c> resourceAvailabilities;
        @AuraEnabled
        public List<ES_Resource_Allocation__c> resourceAllocations;
    }
}