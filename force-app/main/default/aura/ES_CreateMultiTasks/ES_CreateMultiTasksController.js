({
	doInit: function (component, event, helper) {        
        //this block to fetch picklist values
        helper.getPicklists(component);
        helper.addTaskRecord(component); //add one initial row in the component
     },
    
    addRow: function(component, event, helper) {
        component.set("v.isCreated", false);
        helper.addTaskRecord(component, event);
    },
     
    removeRow: function(component, event, helper) {
        //Get the Phase list
        var taskList = component.get("v.taskList");
        //Get the target object
        var selectedItem = event.currentTarget;
        //Get the selected item index
        var index = selectedItem.dataset.record;
        //Release 1.0
        //Bug Fix : Create task, Phases button when nothing added still submit button shown and clickable with success message.
        if(taskList.length>1){
            taskList.splice(index, 1);
        	component.set("v.taskList", taskList);
        }
        else{
            helper.showToast("Warning", "Cannot remove the last row.");
        }
        
    },
     
    save: function(component, event, helper) {
        component.set("v.isCreated", false);
        if (helper.validateTaskList(component, event)) {
            helper.saveTaskList(component, event);
        }
    },
    
    closeQuickAction : function(component, event, helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})