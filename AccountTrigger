trigger AccountTrigger on Account (before insert,before update,after insert) {
  
    AccountTriggerHandler.newList = trigger.new;
    AccountTriggerHandler.oldList = trigger.old;
    AccountTriggerHandler.newMap = trigger.newMap;
    AccountTriggerHandler.oldMap = trigger.oldMap;
    
    
   	if(Trigger.isBefore){
        if(Trigger.isUpdate){
            AccountTriggerHandler.beforeUpdate();
        }else if(Trigger.isInsert){
            //AccountTriggerHandler.beforeInsert();
        }  
    }
    
   	if(Trigger.isAfter){
        if(Trigger.isUpdate){
           // AccountTriggerHandler.beforeUpdate();
        }else if(Trigger.isInsert){
            AccountTriggerHandler.afterInsert();
        }  
    }
    
    

}
