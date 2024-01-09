/******************************************************************************************************
 * Name: ES_GanttCtrl.apxc
 * Test class : ES_GanttCtrlTest (87%)
 * Used by: Used by LWC ESGantt.cmp & ESGanttdata.cmp
 * Description : Class to get required filters and the data for ES Gantt LWC components
 * Version     : 56 
 ******************************************************************************************************/

public with sharing class ES_GanttCtrl {

    /***********************************************************************************************************************************************************************************************************************************
     * Method Name: fetchGanttData
     * Description: It queries data as per filters provided to show on gantt chart
     * Parameter : It accepts filters which is selected by user like Inspection Progress, Inspection Health. system Impacted. Inspection Category, program and InspectionId if chart is displayed on specific Inspection record page
     * Returns : String
     ***********************************************************************************************************************************************************************************************************************************/
     @AuraEnabled(cacheable = true)
    public static List<GanttDataWrapper> fetchGanttData(Integer slotSize, Date startTime, String InspectionId, String InspectionProgress, String InspectionHealth, String systemImpacted, String InspectionCategory, String program) {
        List<GanttDataWrapper> lstOfGanttDataWrapper = new List<GanttDataWrapper>();
        List<Id> projIds = new List<Id>();
        Id loginUserId = UserInfo.getUserId();
        Set<Id> setOfProjOwners = new Set<Id>();
        Set<Id> followIds = new Set<Id>();
        Set<Id> setOfTasksAssignedToMe = new Set<Id>();
        List<GanttDataWrapper> lstOfWrapper = new List<GanttDataWrapper>();
        Map<Id, List<ES_Phase__c>> mapOfMilestoneToPhases = new Map<Id, List < ES_Phase__c>>();
        Map<Id, List<ES_Task__c>> mapOfPhaseToTasks = new Map<Id, List<ES_Task__c>>();

        List<String> lstOfInspectionFields = new List<String> {'Id', 'OwnerId', 'Name', 'Kickoff_formula__c', 'Duration__c', 'Deadline_formula__c', 'Inspection_Status__c', 'Inspection_Health__c', 'Health_Icon__c', 'Inspection_Category__c', 'Program_Text__c', 'SystemsImpacted__c'};

        slotSize = Integer.valueOf(slotSize);
        Date startDate = startTime;
        

<<<<<<< HEAD
<<<<<<< HEAD
        if (ES_Utility.validateCRUD('Inspection__c', lstOfInspectionFields, 'isAccessible')) {

            List<Inspection__c> Inspections = getInspections(InspectionId, InspectionProgress, InspectionHealth, systemImpacted, InspectionCategory, program);

            if (Inspections != null && Inspections.size() != 0) {
                List < Inspection__c > Inspections_clone = Inspections.clone();
                Inspections.clear();
                Integer size = (Inspections_clone.size() > 1000) ? 1000 : Inspections_clone.size();

                for (Integer i = 0; i < size; i++) {
                    Inspection__c prj = Inspections_clone[i];
                    Inspections.add(prj);
=======
        if (ES_Utility.validateCRUD('Inspection__c', lstOfprojectFields, 'isAccessible')) {
=======
        if (ES_Utility.validateCRUD('Inspection__c', lstOfInspectionFields, 'isAccessible')) {
>>>>>>> 3dc5bb9 (change10)

            List<Inspection__c> Inspections = getInspections(InspectionId, InspectionProgress, InspectionHealth, systemImpacted, InspectionCategory, program);

            if (Inspections != null && Inspections.size() != 0) {
                List < Inspection__c > Inspections_clone = Inspections.clone();
                Inspections.clear();
                Integer size = (Inspections_clone.size() > 1000) ? 1000 : Inspections_clone.size();

                for (Integer i = 0; i < size; i++) {
<<<<<<< HEAD
                    Inspection__c prj = projects_clone[i];
                    projects.add(prj);
>>>>>>> 01eee72 (Change2)
=======
                    Inspection__c prj = Inspections_clone[i];
                    Inspections.add(prj);
>>>>>>> 3dc5bb9 (change10)
                    projIds.add(prj.Id);
                    setOfProjOwners.add(prj.ownerId);
                }

                List<String> lstOfEntitySubscrFields = new List<String> {'Id', 'ParentId', 'SubscriberId'};
                    
                if (ES_Utility.validateCRUD('EntitySubscription', lstOfEntitySubscrFields, 'isAccessible')) {
                    followIds = getFollowIds(Inspections);
                } else {
                    throw new AuraHandledException('Access restricted to check following Inspection, please contact system administrator.');
                }

                // fetching ES Phases
<<<<<<< HEAD
<<<<<<< HEAD
                List<String> lstOfPhaseFields = new List<String> {'Id', 'Name', 'Kickoff_formula__c', 'Duration__c', 'Deadline_formula__c', 'Health_Icon__c', 'ES_Inspection__c'};
=======
                List<String> lstOfPhaseFields = new List<String> {'Id', 'Name', 'Kickoff_formula__c', 'Duration__c', 'Deadline_formula__c', 'Health_Icon__c', 'Inspection__c'};
>>>>>>> 3dc5bb9 (change10)
=======
                List<String> lstOfPhaseFields = new List<String> {'Id', 'Name', 'Kickoff_formula__c', 'Duration__c', 'Deadline_formula__c', 'Health_Icon__c', 'ES_Inspection__c'};
>>>>>>> f6a11f4 (change20)

                if (ES_Utility.validateCRUD('ES_Phase__c', lstOfPhaseFields, 'isAccessible')) {
                    Map<Id, ES_Phase__c> mapOfPhases = getPhases(projIds);

                    // fetching ES Tasks
                    List<String> lstOfTaskFields = new List<String> {'Name', 'Start_Date__c', 'Due_Date__c', 'Duration__c', 'Percentage_Completion__c', 'Assigned_To1__c', 'Status__c', 'Phase__c', 'Is_Milestone__c'};

                    if (ES_Utility.validateCRUD('ES_Task__c', lstOfTaskFields, 'isAccessible')) {
                        Map<Id, ES_Task__c> mapOfTasks = getTasks(mapOfPhases.keySet());
                        //Boolean isAssignedToMe = false;
                        for (ES_Task__c tsk: mapOfTasks.values()) {
                            if (tsk.Assigned_To1__c == loginUserId) {
                                setOfTasksAssignedToMe.add(tsk.Id);
                                setOfTasksAssignedToMe.add(tsk.Phase__r.Id);
                                setOfTasksAssignedToMe.add(tsk.Phase__r.Inspection__r.Id);
                            }

                            if (mapOfPhaseToTasks.containsKey(tsk.Phase__c)) {
                                List<ES_Task__c> lstOfTasks = mapOfPhaseToTasks.get(tsk.Phase__c);
                                lstOfTasks.add(tsk);
                                mapOfPhaseToTasks.put(tsk.Phase__c, lstOfTasks);
                            } else {
                                mapOfPhaseToTasks.put(tsk.Phase__c, new List<ES_Task__c> {tsk});
                            }
                        }
                    } else {
                        throw new AuraHandledException('You don\'t have access to ES task. Please contact system administartor.');
                    }

                    for (ES_Phase__c phs: mapOfPhases.values()) {
<<<<<<< HEAD
<<<<<<< HEAD
                        if (mapOfMilestoneToPhases.containsKey(phs.ES_Inspection__c)) {
                            List<ES_Phase__c> lstOfPhases = mapOfMilestoneToPhases.get(phs.ES_Inspection__c);
                            lstOfPhases.add(phs);
                            mapOfMilestoneToPhases.put(phs.ES_Inspection__c, lstOfPhases);
                        } else {
                            mapOfMilestoneToPhases.put(phs.ES_Inspection__c, new List<ES_Phase__c>{phs}); 
=======
                        if (mapOfMilestoneToPhases.containsKey(phs.Inspection__c)) {
                            List<ES_Phase__c> lstOfPhases = mapOfMilestoneToPhases.get(phs.Inspection__c);
=======
                        if (mapOfMilestoneToPhases.containsKey(phs.ES_Inspection__c)) {
                            List<ES_Phase__c> lstOfPhases = mapOfMilestoneToPhases.get(phs.ES_Inspection__c);
>>>>>>> f6a11f4 (change20)
                            lstOfPhases.add(phs);
                            mapOfMilestoneToPhases.put(phs.ES_Inspection__c, lstOfPhases);
                        } else {
<<<<<<< HEAD
                            mapOfMilestoneToPhases.put(phs.Inspection__c, new List<ES_Phase__c>{phs}); 
>>>>>>> 3dc5bb9 (change10)
=======
                            mapOfMilestoneToPhases.put(phs.ES_Inspection__c, new List<ES_Phase__c>{phs}); 
>>>>>>> f6a11f4 (change20)
                        }
                    }
                } else {
                    throw new AuraHandledException('You don\'t have access to ES Phases or tasks. Please contact system administartor.');
                }

<<<<<<< HEAD
<<<<<<< HEAD
                for (Inspection__c prj: Inspections) {

                    GanttDataWrapper ESInspection = getGanttDataWrapper(slotSize, startDate, prj.Id, prj.Name, prj.Kickoff_formula__c, prj.Deadline_formula__c, prj.Duration__c, '', 'Inspection__c', prj.Health_Icon__c, (followIds.contains(prj.Id)) ? true : false, (setOfTasksAssignedToMe.contains(prj.Id)) ? true : false, (prj.OwnerId==loginUserId) ? true : false, formatDate(prj.Deadline_formula__c, 'dd-MM-yyyy'), false);
=======
                for (Inspection__c prj: projects) {

                    GanttDataWrapper ESProject = getGanttDataWrapper(slotSize, startDate, prj.Id, prj.Name, prj.Kickoff_formula__c, prj.Deadline_formula__c, prj.Duration__c, '', 'Inspection__c', prj.Health_Icon__c, (followIds.contains(prj.Id)) ? true : false, (setOfTasksAssignedToMe.contains(prj.Id)) ? true : false, (prj.OwnerId==loginUserId) ? true : false, formatDate(prj.Deadline_formula__c, 'dd-MM-yyyy'), false);
>>>>>>> 01eee72 (Change2)
=======
                for (Inspection__c prj: Inspections) {

                    GanttDataWrapper ESInspection = getGanttDataWrapper(slotSize, startDate, prj.Id, prj.Name, prj.Kickoff_formula__c, prj.Deadline_formula__c, prj.Duration__c, '', 'Inspection__c', prj.Health_Icon__c, (followIds.contains(prj.Id)) ? true : false, (setOfTasksAssignedToMe.contains(prj.Id)) ? true : false, (prj.OwnerId==loginUserId) ? true : false, formatDate(prj.Deadline_formula__c, 'dd-MM-yyyy'), false);
>>>>>>> 3dc5bb9 (change10)

                    if (mapOfMilestoneToPhases.containsKey(prj.Id)) {
                        List<GanttDataWrapper> lstOfPhases = new List<GanttDataWrapper>();

                        for (ES_Phase__c phs: mapOfMilestoneToPhases.get(prj.Id)) {
<<<<<<< HEAD
<<<<<<< HEAD
                            GanttDataWrapper ESPhase = getGanttDataWrapper(slotSize, startDate, phs.Id, phs.Name, phs.Kickoff_formula__c, phs.Deadline_formula__c, phs.Duration__c, phs.ES_Inspection__c, 'ES_Phase__c', phs.Health_Icon__c, (followIds.contains(phs.Inspection__r.Id)) ? true : false, (setOfTasksAssignedToMe.contains(phs.Id)) ? true : false, (setOfProjOwners.contains(loginUserId)) ? true : false, null, false);
=======
                            GanttDataWrapper ESPhase = getGanttDataWrapper(slotSize, startDate, phs.Id, phs.Name, phs.Kickoff_formula__c, phs.Deadline_formula__c, phs.Duration__c, phs.Inspection__c, 'ES_Phase__c', phs.Health_Icon__c, (followIds.contains(phs.Inspection__r.Id)) ? true : false, (setOfTasksAssignedToMe.contains(phs.Id)) ? true : false, (setOfProjOwners.contains(loginUserId)) ? true : false, null, false);
>>>>>>> 3dc5bb9 (change10)
=======
                            GanttDataWrapper ESPhase = getGanttDataWrapper(slotSize, startDate, phs.Id, phs.Name, phs.Kickoff_formula__c, phs.Deadline_formula__c, phs.Duration__c, phs.ES_Inspection__c, 'ES_Phase__c', phs.Health_Icon__c, (followIds.contains(phs.Inspection__r.Id)) ? true : false, (setOfTasksAssignedToMe.contains(phs.Id)) ? true : false, (setOfProjOwners.contains(loginUserId)) ? true : false, null, false);
>>>>>>> f6a11f4 (change20)

                            if (mapOfPhaseToTasks.containsKey(phs.Id)) {
                                List<GanttDataWrapper> lstOfTasks = new List<GanttDataWrapper>();

                                for (ES_Task__c tsk: mapOfPhaseToTasks.get(phs.Id)) {
                                    GanttDataWrapper ESTask = getGanttDataWrapper(slotSize, startDate, tsk.Id, tsk.Name, tsk.Start_Date__c, tsk.Due_Date__c, tsk.Duration__c, tsk.Phase__c, 'ES_Task__c', tsk.Status_Icon__c, (followIds.contains(tsk.Phase__r.Inspection__r.Id)) ? true : false, (setOfTasksAssignedToMe.contains(tsk.Id)) ? true : false, (setOfProjOwners.contains(loginUserId)) ? true : false, null, tsk.Is_Milestone__c);
                                    ESTask.lstOfChilds = new List<GanttDataWrapper>();
                                    lstOfTasks.add(ESTask);
                                }
                                ESPhase.lstOfChilds = lstOfTasks;
                            }
                            lstOfPhases.add(ESPhase);
                        }
                        ESInspection.lstOfChilds = lstOfPhases;
                    }
                    lstOfWrapper.add(ESInspection);
                }
            }
        } else {
            throw new AuraHandledException('You don\'t have access to ES Inspection. Please contact system administartor.');
        }
        return lstOfWrapper;
    }

    /****************************************************************************************************************************************
    * Method Name: GanttDataWrapper is a wrapper class
    * Description: It is used to form tasks list with pre-defined attributes which are going to use to show data on gantt chart
    *****************************************************************************************************************************************/
    public class GanttDataWrapper {
        @AuraEnabled
        public Id id {get;set;}
            
        @AuraEnabled
        public String text {get;set;}
            
        @AuraEnabled
        public Date start_date {get;set;}
            
        @AuraEnabled
        public Date end_date {get;set;}
        
        @AuraEnabled
        public String parent {get;set;}
            
        @AuraEnabled
        public Decimal duration {get;set;}
            
        @AuraEnabled
        public String objAPIName {get;set;}
        
        @AuraEnabled
        public String statusIcon {get;set;}

        @AuraEnabled
        public Boolean isFollow {get;set;}
            
        @AuraEnabled
        public Boolean isAssignedToMe {get;set;}
            
        @AuraEnabled
        public Boolean isMyInspection {get;set;}
            
        @AuraEnabled
        public String deadline {get;set;}
        
        @AuraEnabled
        public Boolean isMilestone {get;set;}
            
        @AuraEnabled
        public Decimal left {get;set;}

        @AuraEnabled
        public Decimal right {get;set;}
            
        @AuraEnabled
        public List<GanttDataWrapper> lstOfChilds {get;set;}        
    }

    /*********************************************************************************************************************************************
     * Method Name: getGanttDataWrapper
     * Description: Method to form the response based on the parameters passed & calcudate the left & right value based on slotsize
     * Parameter : Mutilple parameters
     * Returns : GanttDataWrapper
     **********************************************************************************************************************************************/
    public static GanttDataWrapper getGanttDataWrapper(Integer slotSize, Date sDate, Id recId, String name, Date startDate, Date endDate, Decimal duration, String parentId, String objAPIName, String statusIcon, Boolean isFollow, Boolean isAssignedToMe, Boolean isMyInspection, String prjDeadline, Boolean isMilestone) {
        try{
        GanttDataWrapper wrapperRecord = new GanttDataWrapper();
        wrapperRecord.id = recId;
        wrapperRecord.text = name;
        wrapperRecord.start_date = startDate;
        wrapperRecord.end_date = endDate;
        wrapperRecord.duration = duration;
        wrapperRecord.parent = parentId;
        wrapperRecord.objAPIName = objAPIName;
        wrapperRecord.statusIcon = statusIcon; 
        wrapperRecord.isFollow = isFollow;
        wrapperRecord.isAssignedToMe = isAssignedToMe;
        wrapperRecord.isMyInspection = isMyInspection;
        wrapperRecord.deadline = prjDeadline;
        wrapperRecord.isMilestone = isMilestone;

        Decimal leftW = slotSize;
        Decimal rightW = slotSize;

        if (slotSize == 92) {
            Date newStartDate;
            Date newEndDate;
            Decimal leftQtrs = 0;
            Decimal rightQtrs = 0;
            Date tempStart = sDate;
            tempStart = tempStart.addDays(1);
            sDate = sDate.addDays(1);

            for (Date tDate = tempStart.addMonths(3); tDate <= endDate; tDate = tDate.addMonths(3)) {
                if (tDate <= startDate) {
                    leftQtrs = leftQtrs + 1;

                    if (tDate == startDate) {
                        newStartDate = tDate.addDays(-1);
                    } else {
                        newStartDate = tDate;
                    }
                }
                rightQtrs = rightQtrs + 1;
                if (tDate == endDate) {
                    newEndDate = tDate.addDays(-1);
                } else {
                    newEndDate = tDate;
                }
            }
            
            if (newStartDate != null) {
                Decimal leftTotalDays = sDate.daysBetween(newStartDate);
                Decimal leftAvg = leftTotalDays / leftQtrs;
                leftW = leftAvg;
            } else {
                leftW = 91.4;
            }

            if (newEndDate != null) {
                Decimal rightTotalDays = sDate.daysBetween(newEndDate);
                Decimal rightAvg = rightTotalDays / rightQtrs;
                rightW = rightAvg;
            } else {
                rightW = 91.4;
            }
        }
        if(startDate!=null){
            Decimal leftV = Decimal.valueOf(sDate.daysBetween(startDate)) / leftW;
            wrapperRecord.left = leftV.round(System.RoundingMode.FLOOR);
        }
        if(endDate!=null){
            Decimal rightV = Decimal.valueOf(sDate.daysBetween(endDate)) / rightW;
            wrapperRecord.right = rightV.round(System.RoundingMode.FLOOR);
        }  

        return wrapperRecord;
        }catch (Exception e) {
            List<String> lstOfLogFields = new List<String> {'Apex_Class__c', 'Error_Message__c', 'Method_Name__c'};
            
            //Calling util method to check CRUD
            if (ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')) {
                INSERT new ES_Error_Log__c(Apex_Class__c = 'ES_GanttCtrl', Error_Message__c = e.getMessage(), Method_Name__c = 'getGanttDataWrapper');
            }
            return new GanttDataWrapper();
        }        
    }

    /**********************************************************************
     * Method Name: formatDate
     * Description: It formats date to specific format
     * Parameter : Date and Format string
     * Returns : String
     **********************************************************************/
    private static String formatDate(Date d, String format) {
        if (d == null) {
            return null;
        }
        Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
        return dt.format(format);
    }

    /********************************************************************************************************************************************
     * Method Name:getInspections
     * Description : Search for ES Inspections with search filters
     * Parameter : Inspection Id, Inspection Progress, Inspection Health, systems Impacted, Inspection Category and program to filter records
     * Returns : List of Inspections
     * ******************************************************************************************************************************************/
<<<<<<< HEAD
<<<<<<< HEAD
    private static List < Inspection__c > getInspections(String InspectionId, String InspectionProgress, String InspectionHealth, String systemImpacted, String InspectionCategory, String program) {
=======
    private static List < Inspection__c > getProjects(String projectId, String projectProgress, String projectHealth, String systemImpacted, String projectCategory, String program) {
>>>>>>> 01eee72 (Change2)
=======
    private static List < Inspection__c > getInspections(String InspectionId, String InspectionProgress, String InspectionHealth, String systemImpacted, String InspectionCategory, String program) {
>>>>>>> 3dc5bb9 (change10)
        
        String selectStr = '';
        selectStr = 'SELECT Id,OwnerId, Name, Kickoff_formula__c, Duration__c, Deadline_formula__c,' +
            '  Inspection_Status__c, Inspection_Health__c,Health_Icon__c,Inspection_Category__c,Program_Text__c,SystemsImpacted__c ';
        
        String fromStr = 'FROM Inspection__c';
        boolean isWhere = false;
        String whereStr = '';
        
        whereStr = ' WHERE isTemplate__c=false';
        if (InspectionId != null && InspectionId != '') {
            isWhere = true;
            whereStr = whereStr + ' AND Id=\'' + string.escapeSingleQuotes(InspectionId) + '\'';
            
        }
        
        if (InspectionProgress != null && InspectionProgress != 'All') {
            whereStr = whereStr + ' AND Inspection_Status__c=\'' + string.escapeSingleQuotes(InspectionProgress) + '\'';
        }
        
        if (InspectionHealth != null && InspectionHealth != '' && InspectionHealth != 'All') {
            
            whereStr = whereStr + ' AND Inspection_Health__c=\'' + string.escapeSingleQuotes(InspectionHealth) + '\'';
            
        }
        
        if (systemImpacted != null && systemImpacted != '' && !systemImpacted.contains('All')) {
            
            whereStr = whereStr + ' AND SystemsImpacted__c includes (\'' + string.escapeSingleQuotes(systemImpacted) + '\')';
            
        }
        
        if (InspectionCategory != null && InspectionCategory != '' && InspectionCategory != 'All') {
            
            whereStr = whereStr + ' AND Inspection_Category__c=\'' + string.escapeSingleQuotes(InspectionCategory) + '\'';
            
        }
        
        if (program != null && program != '' && program != 'All') {
            
            whereStr = whereStr + ' AND Program__c=\'' + string.escapeSingleQuotes(program) + '\'';
            
        }
        
        String orderByStr = 'ORDER BY Name, Kickoff_formula__c, Deadline_formula__c  ASC LIMIT 30';
        String query = selectStr + ' ' + fromStr + ' ' + whereStr + ' ' + orderByStr;
        return Database.query(query);
    }

    /*****************************************************************************************************************
     * Method Name:getPhases
     * Description : Search for ES phases related to list of Inspections which is given as input parameter
     * Parameter : List of Inspections Id's
     * Returns : List of ES Phases
     * ***************************************************************************************************************/
    private static Map<Id, ES_Phase__c> getPhases(List<Id> lstOfProjIds) {
        Map<Id, ES_Phase__c> mapOfPhases = new Map<Id, ES_Phase__c>();

<<<<<<< HEAD
<<<<<<< HEAD
        for (ES_Phase__c phaseRec: [SELECT Id, Name, Kickoff_formula__c, Duration__c, ES_Inspection__c, Deadline_formula__c, Health_Icon__c, Inspection__r.Id FROM ES_Phase__c WHERE ES_Inspection__c IN: lstOfProjIds limit: limits.getLimitQueryRows()]) {
=======
        for (ES_Phase__c phaseRec: [SELECT Id, Name, Kickoff_formula__c, Duration__c, Inspection__c, Deadline_formula__c, Health_Icon__c, Inspection__r.Id FROM ES_Phase__c WHERE Inspection__c IN: lstOfProjIds limit: limits.getLimitQueryRows()]) {
>>>>>>> 3dc5bb9 (change10)
=======
        for (ES_Phase__c phaseRec: [SELECT Id, Name, Kickoff_formula__c, Duration__c, ES_Inspection__c, Deadline_formula__c, Health_Icon__c, Inspection__r.Id FROM ES_Phase__c WHERE ES_Inspection__c IN: lstOfProjIds limit: limits.getLimitQueryRows()]) {
>>>>>>> f6a11f4 (change20)
            mapOfPhases.put(phaseRec.Id, phaseRec);
        }

        return mapOfPhases;
    }

    /*********************************************************************************************************
     * Method Name:getTasks
     * Description : Search for ES tasks related to set of phases which is given as input parameter
     * Parameter : Set of phase Id's
     * Returns : List of ES tasks
     * *******************************************************************************************************/
    private static Map<Id, ES_Task__c> getTasks(Set<Id> setOfPhaseIds) {
        Map<Id, ES_Task__c> mapOftasks = new Map<Id, ES_Task__c>();

        for (ES_Task__c taskRec: [SELECT Id, Name, Start_Date__c, Duration__c, Phase__c, Due_Date__c, Status_Icon__c, Phase__r.Inspection__r.Id, Assigned_To1__c, Phase__r.Id, Is_Milestone__c FROM ES_Task__c WHERE Phase__c IN: setOfPhaseIds limit: limits.getLimitQueryRows()]) {
            mapOftasks.put(taskRec.Id, taskRec);
        }

        return mapOftasks;
    }

    /**********************************************************************
     * Method Name: getFollowIds
     * Description: It sets default search options
     * Parameter : List of ES Inspections
     * Returns : Set of follow up Id's
     **********************************************************************/
<<<<<<< HEAD
<<<<<<< HEAD
    private static Set<Id> getFollowIds(List < Inspection__c > Inspections) {
        Set<Id> proIds = new Set<Id>();

        for (Inspection__c p: Inspections) {
=======
    private static Set<Id> getFollowIds(List < Inspection__c > projects) {
        Set<Id> proIds = new Set<Id>();

        for (Inspection__c p: projects) {
>>>>>>> 01eee72 (Change2)
=======
    private static Set<Id> getFollowIds(List < Inspection__c > Inspections) {
        Set<Id> proIds = new Set<Id>();

        for (Inspection__c p: Inspections) {
>>>>>>> 3dc5bb9 (change10)
            proIds.add(p.Id);
        }

        Set<Id> followInspectionId = new Set<Id>();

        List<EntitySubscription> eList = [SELECT Id, ParentId, SubscriberId FROM EntitySubscription WHERE ParentId IN: proIds AND SubscriberId =: UserInfo.getUserId() LIMIT 1000];

        for (EntitySubscription e: eList) {
            followInspectionId.add(e.ParentId);
        }

        return followInspectionId;
    }

    /**********************************************************************
     * Method Name: GanttFliterWrapper is wrapper class
     * Description: It is used to show filters on gantt page    
     **********************************************************************/
    public class GanttFliterWrapper {
        @AuraEnabled
        public List<Filter> prjhealth; // List of Inspection health's available
        
        @AuraEnabled
        public List<Filter> prjcategory; // List of Inspection categories available
        
        @AuraEnabled
        public List<Filter> sysimpacted; // List of values available for system's impacted on Inspection
        
        @AuraEnabled
        public List<Filter> prjprogress; // List of Inspection progress available
    }

    /***************************************************************************************
     * Method Name: Filter is wrapper class
     * Description: It is used for storing value and label of picklist values 
     ***************************************************************************************/
    public class Filter {
        @AuraEnabled
        public string label;

        @AuraEnabled
        public string value;

        public Filter(string label, string value) {
            this.label = label;
            this.value = value;
        }
    }

    /******************************************************************************************************
     * Method Name: getGanttFilters
     * Description: It creates fliters to show on gantt chart as per values available on object fields
     * Parameter : NA
     * Returns : GanttFliterWrapper wrapper instance
     ******************************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static GanttFliterWrapper getGanttFilters() {
        try {
            List<String> lstOfInspectionFields = new List<String> {'Inspection_Health__c', 'Inspection_Category__c', 'SystemsImpacted__c', 'Inspection_Status__c'};
                        
<<<<<<< HEAD
<<<<<<< HEAD
            if (ES_Utility.validateCRUD('Inspection__c', lstOfInspectionFields, 'isAccessible')) {

                List<Filter> prjhealth = new List<Filter>();
                Map<String, String> mapOfHealthValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Health__c');
=======
            if (ES_Utility.validateCRUD('Inspection__c', lstOfprojectFields, 'isAccessible')) {

                List<Filter> prjhealth = new List<Filter>();
                Map<String, String> mapOfHealthValues = ES_Utility.getPicklistValues('Inspection__c', 'Project_Health__c');
>>>>>>> 01eee72 (Change2)
=======
            if (ES_Utility.validateCRUD('Inspection__c', lstOfInspectionFields, 'isAccessible')) {

                List<Filter> prjhealth = new List<Filter>();
                Map<String, String> mapOfHealthValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Health__c');
>>>>>>> 3dc5bb9 (change10)

                for (String key: mapOfHealthValues.keySet()) {
                    prjhealth.add(new Filter(key, mapOfHealthValues.get(key)));
                }

                List<Filter> prjcategory = new List<Filter>();
<<<<<<< HEAD
<<<<<<< HEAD
                Map<String, String> mapOfCategoryValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Category__c');
=======
                Map<String, String> mapOfCategoryValues = ES_Utility.getPicklistValues('Inspection__c', 'Project_Category__c');
>>>>>>> 01eee72 (Change2)
=======
                Map<String, String> mapOfCategoryValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Category__c');
>>>>>>> 3dc5bb9 (change10)

                for (String key: mapOfCategoryValues.keySet()) {
                    prjcategory.add(new Filter(key, mapOfCategoryValues.get(key)));
                }

                List<Filter> sysimpacted = new List<Filter>();
                Map<String, String> mapOfSystemValues = ES_Utility.getPicklistValues('Inspection__c', 'SystemsImpacted__c');

                for (String key: mapOfSystemValues.keySet()) {
                    sysimpacted.add(new Filter(key, mapOfSystemValues.get(key)));
                }

                List<Filter> prjprogress = new List<Filter>();
<<<<<<< HEAD
<<<<<<< HEAD
                Map<String, String> mapOfProgressValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Status__c');
=======
                Map<String, String> mapOfProgressValues = ES_Utility.getPicklistValues('Inspection__c', 'Project_Status__c');
>>>>>>> 01eee72 (Change2)
=======
                Map<String, String> mapOfProgressValues = ES_Utility.getPicklistValues('Inspection__c', 'Inspection_Status__c');
>>>>>>> 3dc5bb9 (change10)

                for (String key: mapOfProgressValues.keySet()) {
                    prjprogress.add(new Filter(key, mapOfProgressValues.get(key)));
                }

                GanttFliterWrapper filter = new GanttFliterWrapper();
                filter.prjhealth = prjhealth;
                filter.prjcategory = prjcategory;
                filter.sysimpacted = sysimpacted;
                filter.prjprogress = prjprogress;

                return filter;
            } else {
                throw new AuraHandledException('You don\'t have access to ES Inspection filters. Please contact system administartor.');
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /************************************************************************************************
     * Method Name: saveTask
     * Description: It Updates ES task start date and due date as updated on gantt chart
     * Parameter : ES Task Id, startDate and endDate
     * Returns : String message
     ************************************************************************************************/
    @AuraEnabled(cacheable = false)
    public static string saveTask(String taskId, Date startDate, Date endDate) {
        try {
            List<String> lstOftasksFields = new List<String> {'Id', 'Start_Date__c', 'Due_Date__c'};
            Id taskRecId = Id.valueOf(taskId);

            if (ES_Utility.validateCRUD('ES_Task__c', lstOftasksFields, 'isAccessible')) {
                ES_Task__c task = new ES_Task__c(Id = taskRecId, Start_Date__c = startDate, Due_Date__c = endDate);

                if (ES_Utility.validateCRUD('ES_Task__c', null, 'isUpdateable')) {
                    update task;
                    return 'Task updated successfully.';
                } else {
                    throw new AuraHandledException('You don\'t have access to update ES Task. Please contact system administartor.');
                }
            } else {
                throw new AuraHandledException('You don\'t have access to ES task. Please contact system administartor.');
            }
        } catch (Exception e) {
            List<String> lstOfLogFields = new List<String> {'Apex_Class__c', 'Error_Message__c', 'Method_Name__c'};
            
            //Calling util method to check CRUD
            if (ES_Utility.validateCRUD('ES_Error_Log__c', lstOfLogFields, 'isCreatable')) {
                INSERT new ES_Error_Log__c(Apex_Class__c = 'ES_GanttCtrl', Error_Message__c = e.getMessage(), Method_Name__c = 'updateTask');
            }
            throw new AuraHandledException(e.getMessage());
        }
    }
}