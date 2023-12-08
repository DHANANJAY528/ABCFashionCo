@RestResource(urlMapping='/dmlRecords/*')
global without sharing class DmlOperationHelper {
    @HttpPost 
    global static Id createAccount(){
        
        Id recId;
        Savepoint sp = Database.setSavepoint();
        try{
            system.debug('rest class');
            String RequestedBody = ''; 
            RestResponse res = RestContext.response;
            RestRequest r = RestContext.request; 
            RequestedBody = r.requestBody.toString();
            Object bodyRequest = JSON.deserializeUntyped(RequestedBody);
            system.debug('bodyRequest--->'+bodyRequest);
            
            Map<String,Object> Requestedmap = (Map<String,Object>) bodyRequest;
            Object obj = (object) Requestedmap.get('sObjectList');
            
            List<sObject> accObj = (List<sObject>)Json.deserialize(JSON.serialize(obj),List<sObject>.class);
            if(Schema.sObjectType.Account.isCreateable() ){
            	upsert accObj;
                recId=accObj[0].Id;
            }
            else{
                return null;
            }
            
        }catch(exception ex){ 
            system.debug('Error: '+ex.getMessage() + 'Line Number-->' + ex.getLineNumber());
            RestContext.response.statusCode = 500;
            throw ex;
        }
        return recId;
    } 
}
