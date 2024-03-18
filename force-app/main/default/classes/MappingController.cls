public class MappingController {
    
    @AuraEnabled 
    public static List<ObjectWrapper> getObjects(){
        List<ObjectWrapper> owList = new List<ObjectWrapper>();
        //Map<String,String> objectMap = new Map<String,String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            String name = objTyp.getDescribe().getName();
            String label = objTyp.getDescribe().getLabel();
            if(!name.containsignorecase('history') && !name.containsignorecase('tag') &&
               !name.containsignorecase('share') && !name.containsignorecase('feed') && 
               !name.containsignorecase('group') && !name.containsignorecase('public') &&
               !objTyp.getDescribe().isCustomSetting() && objTyp.getDescribe().isCreateable() &&
               objTyp.getDescribe().getRecordTypeInfos().size() > 0){      
                   //objectMap.put(name,label);
                   ObjectWrapper ow = new ObjectWrapper();
                   ow.objectApi = name;
                   ow.objectName = label;
                   owList.add(ow);
               }
        }
        System.debug(owList);
        if(owList != null && owList.size() > 0){
            return owList;   
        }else{
            return null;
        }
    }
    
    @AuraEnabled 
    public static List<FieldWrapper> getFieldList(String selectedSObject){
        //map<string, string> fieldList = new map<string, string>();
        List<FieldWrapper> fwList = new List<FieldWrapper>();
        if(selectedSObject != null){
            map<string,SObjectField> fList = schema.getGlobalDescribe().get(selectedSObject).getDescribe().fields.getMap();
            for(string str: fList.keySet()){
                FieldWrapper fw = new FieldWrapper();
                if(!str.containsignorecase('id') && fList.get(str).getDescribe().getLabel()!=null && str !=null){
                    fw.fieldName = fList.get(str).getDescribe().getLabel();
                    fw.fieldApi = str;
                    fwList.add(fw);
                }
                //fieldList.put(str, fList.get(str).getDescribe().getLabel());                
            }
        }else{
            return null;
        }
        system.debug(fwList);
        return fwList;
    }
    
    @AuraEnabled 
    public static OnboardedOAuth__c insertAuthMapping(string name, string apiKey){
        
        List<OnboardedOAuth__c> obList = [SELECT Id, Name, API_key__c FROM OnboardedOAuth__c where Name=:name];
        system.debug(obList);    
        if(obList.isEmpty()){
            OnboardedOAuth__c em = new OnboardedOAuth__c();
            em.name = name;
            em.API_key__c = apiKey;
            insert em;
            return em;
        }else{
            return null;
        }
        
    }
    
    @AuraEnabled 
    public static EmployeeMapping__c insertCandidateMapping(String Name, String sfObject, String onboardName, map<String,String> jsonMapping){
        EmployeeMapping__c om = new EmployeeMapping__c();
        List<EmployeeMapping__c> mapList = [SELECT Id, Name, OnBoard_Object__c, Salesforce_Object__c, first_name__c, middle_name__c, last_name__c, email__c, phone__c, date_of_birth__c, social_security_number__c, has_middle_name__c, street__c, secondary__c, city__c, state__c, zip__c, country__c FROM EmployeeMapping__c where name=:Name];
        system.debug(JSON.serialize(jsonMapping));
        if(!mapList.IsEmpty() && mapList.size() > 0){
            for(EmployeeMapping__c maoObj : mapList){
                if(maoObj.Name =='EmployeeMapping'){
                    om.id = maoObj.Id;
                    om.Salesforce_Object__c = sfObject;
                    om.OnBoard_Object__c = onboardName;
                    om.Name = Name;
                    om.first_name__c= jsonMapping.get('first_name') !=null ? jsonMapping.get('first_name') : '';
                    om.middle_name__c= jsonMapping.get('middle_name') !=null ? jsonMapping.get('middle_name') : '';
                    om.last_name__c= jsonMapping.get('last_name') !=null ? jsonMapping.get('last_name') : '';
                    om.email__c= jsonMapping.get('email') !=null ? jsonMapping.get('email') : '';
                    om.phone__c= jsonMapping.get('phone') !=null ? jsonMapping.get('phone') : '';
                    om.date_of_birth__c= jsonMapping.get('date_of_birth') !=null ? jsonMapping.get('date_of_birth') : '';
                    om.social_security_number__c= jsonMapping.get('social_security_number') !=null ? jsonMapping.get('social_security_number') : '';
                    om.has_middle_name__c= boolean.valueOf(jsonMapping.get('has_middle_name'));
                    om.street__c= jsonMapping.get('street') !=null ? jsonMapping.get('street') : '';
                    om.secondary__c= jsonMapping.get('secondary') !=null ? jsonMapping.get('secondary') : '';
                    om.city__c= jsonMapping.get('city') !=null ? jsonMapping.get('city') : '';
                    om.state__c= jsonMapping.get('state') !=null ? jsonMapping.get('state') : '';
                    om.zip__c= jsonMapping.get('zip') !=null ? jsonMapping.get('zip') : '';
                    om.country__c=jsonMapping.get('country') !=null ? jsonMapping.get('country') : '';
                    update om;
                    system.debug('Updated :: '+JSON.serialize(om));
                }
            }
            
        }else{
            if(Name =='EmployeeMapping'){
                om.Salesforce_Object__c = sfObject;
                om.OnBoard_Object__c = onboardName;
                om.Name = Name;
                om.first_name__c= jsonMapping.get('first_name') !=null ? jsonMapping.get('first_name') : '';
                om.middle_name__c= jsonMapping.get('middle_name') !=null ? jsonMapping.get('middle_name') : '';
                om.last_name__c= jsonMapping.get('last_name') !=null ? jsonMapping.get('last_name') : '';
                om.email__c= jsonMapping.get('email') !=null ? jsonMapping.get('email') : '';
                om.phone__c= jsonMapping.get('phone') !=null ? jsonMapping.get('phone') : '';
                om.date_of_birth__c= jsonMapping.get('date_of_birth') !=null ? jsonMapping.get('date_of_birth') : '';
                om.social_security_number__c= jsonMapping.get('social_security_number') !=null ? jsonMapping.get('social_security_number') : '';
                om.has_middle_name__c= boolean.valueOf(jsonMapping.get('has_middle_name'));
                om.street__c= jsonMapping.get('street') !=null ? jsonMapping.get('street') : '';
                om.secondary__c= jsonMapping.get('secondary') !=null ? jsonMapping.get('secondary') : '';
                om.city__c= jsonMapping.get('city') !=null ? jsonMapping.get('city') : '';
                om.state__c= jsonMapping.get('state') !=null ? jsonMapping.get('state') : '';
                om.zip__c= jsonMapping.get('zip') !=null ? jsonMapping.get('zip') : '';
                om.country__c=jsonMapping.get('country') !=null ? jsonMapping.get('country') : '';
                insert om;
                system.debug('Inserted :: '+om);
                
            }
            
        }
        return om;
    }
    
    @AuraEnabled 
    public static EmployerMapping__c insertEmployerMapping(String Name, String sfObject, String onboardName, map<String,String> jsonMapping){
        EmployerMapping__c om = new EmployerMapping__c();
        List<EmployerMapping__c> mapList = [SELECT Id, Name, name__c, phone__c, dba_name__c, employee_count__c, entity_structure__c, naics_code__c, street__c, state__c, city__c, zip__c, country__c, ein__c, OnBoard_Object__c, Salesforce_Object__c FROM EmployerMapping__c where name=:Name];
        system.debug(JSON.serialize(jsonMapping));
        if(!mapList.IsEmpty() && mapList.size() > 0){
            for(EmployerMapping__c maoObj : mapList){
                if(maoObj.Name =='EmployerMapping'){
                    om.id = maoObj.Id;
                    om.Salesforce_Object__c = sfObject;
                    om.OnBoard_Object__c = onboardName;
                    om.Name = Name;
                    om.name__c= jsonMapping.get('name') !=null ? jsonMapping.get('name') : '';
                    om.ein__c= jsonMapping.get('ein') !=null ? jsonMapping.get('ein') : '';
                    om.dba_name__c= jsonMapping.get('dba_name') !=null ? jsonMapping.get('dba_name') : '';
                    om.employee_count__c= jsonMapping.get('employee_count') !=null ? jsonMapping.get('employee_count') : '';
                    om.phone__c= jsonMapping.get('phone') !=null ? jsonMapping.get('phone') : '';
                    om.entity_structure__c= jsonMapping.get('entity_structure') !=null ? jsonMapping.get('entity_structure') : '';
                    om.naics_code__c= jsonMapping.get('naics_code') !=null ? jsonMapping.get('naics_code') : '';
                    om.street__c= jsonMapping.get('street') !=null ? jsonMapping.get('street') : '';
                    om.city__c= jsonMapping.get('city') !=null ? jsonMapping.get('city') : '';
                    om.state__c= jsonMapping.get('state') !=null ? jsonMapping.get('state') : '';
                    om.zip__c= jsonMapping.get('zip') !=null ? jsonMapping.get('zip') : '';
                    om.country__c=jsonMapping.get('country') !=null ? jsonMapping.get('country') : '';
                    update om;
                    system.debug('Updated :: '+JSON.serialize(om));
                }
            }
            
        }else{
            if(Name =='EmployerMapping'){
                om.Salesforce_Object__c = sfObject;
                    om.OnBoard_Object__c = onboardName;
                    om.Name = Name;
                    om.name__c= jsonMapping.get('name') !=null ? jsonMapping.get('name') : '';
                    om.ein__c= jsonMapping.get('ein') !=null ? jsonMapping.get('ein') : '';
                    om.dba_name__c= jsonMapping.get('dba_name') !=null ? jsonMapping.get('dba_name') : '';
                    om.employee_count__c= jsonMapping.get('employee_count') !=null ? jsonMapping.get('employee_count') : '';
                    om.phone__c= jsonMapping.get('phone') !=null ? jsonMapping.get('phone') : '';
                    om.entity_structure__c= jsonMapping.get('entity_structure') !=null ? jsonMapping.get('entity_structure') : '';
                    om.naics_code__c= jsonMapping.get('naics_code') !=null ? jsonMapping.get('naics_code') : '';
                    om.street__c= jsonMapping.get('street') !=null ? jsonMapping.get('street') : '';
                    om.city__c= jsonMapping.get('city') !=null ? jsonMapping.get('city') : '';
                    om.state__c= jsonMapping.get('state') !=null ? jsonMapping.get('state') : '';
                    om.zip__c= jsonMapping.get('zip') !=null ? jsonMapping.get('zip') : '';
                    om.country__c=jsonMapping.get('country') !=null ? jsonMapping.get('country') : '';
                insert om;
                system.debug('Inserted :: '+om);
                
            }
            
        }
        return om;
    }

    @AuraEnabled 
    public static ClientMapping__c insertClientMapping(String Name, String sfObject, String onboardName, string clientname){
        ClientMapping__c om = new ClientMapping__c();
        List<ClientMapping__c> mapList = [SELECT Id, Name, Salesforce_Object__c, OnBoard_Object__c, name__c FROM ClientMapping__c where name=:Name];

        if(!mapList.IsEmpty() && mapList.size() > 0){
            for(ClientMapping__c maoObj : mapList){
                if(maoObj.Name =='ClientMapping'){
                    om.id = maoObj.Id;
                    om.Salesforce_Object__c = sfObject;
                    om.OnBoard_Object__c = onboardName;
                    om.Name = Name;
                    om.name__c= clientname !=null ? clientname : '';
                    update om;
                    system.debug('Updated :: '+JSON.serialize(om));
                }
            }
            
        }else{
            if(Name =='ClientMapping'){
                om.Salesforce_Object__c = sfObject;
                om.OnBoard_Object__c = onboardName;
                om.Name = Name;
                om.name__c= clientname !=null ? clientname : '';
                insert om;
                system.debug('Inserted :: '+om);
                
            }
            
        }
        return om;
    }
    
    @AuraEnabled 
    public static JobMapping__c insertJobMapping(String Name, String sfObject, String onboardName, map<String,String> jsonMapping){
        JobMapping__c om = new JobMapping__c();
        List<JobMapping__c> mapList = [SELECT Id, Name, name__c, OnBoard_Object__c, Salesforce_Object__c FROM JobMapping__c where name=:Name];

        if(!mapList.IsEmpty() && mapList.size() > 0){
            for(JobMapping__c maoObj : mapList){
                if(maoObj.Name =='JobMapping'){
                    om.id = maoObj.Id;
                    om.Salesforce_Object__c = sfObject;
                    om.OnBoard_Object__c = onboardName;
                    om.Name = Name;
                    om.name__c= jsonMapping.get('name') !=null ? jsonMapping.get('name') : '';
                    om.secondary__c= jsonMapping.get('secondary') !=null ? jsonMapping.get('secondary') : '';
                    om.street__c= jsonMapping.get('street') !=null ? jsonMapping.get('street') : '';
                    om.city__c= jsonMapping.get('city') !=null ? jsonMapping.get('city') : '';
                    om.state__c= jsonMapping.get('state') !=null ? jsonMapping.get('state') : '';
                    om.zip__c= jsonMapping.get('zip') !=null ? jsonMapping.get('zip') : '';
                    om.country__c=jsonMapping.get('country') !=null ? jsonMapping.get('country') : '';
                    update om;
                    system.debug('Updated :: '+JSON.serialize(om));
                }
            }
            
        }else{
            if(Name =='JobMapping'){
                om.Salesforce_Object__c = sfObject;
                om.OnBoard_Object__c = onboardName;
                om.Name = Name;
                om.name__c= jsonMapping.get('name') !=null ? jsonMapping.get('name') : '';
                om.secondary__c= jsonMapping.get('secondary') !=null ? jsonMapping.get('secondary') : '';
                om.street__c= jsonMapping.get('street') !=null ? jsonMapping.get('street') : '';
                om.city__c= jsonMapping.get('city') !=null ? jsonMapping.get('city') : '';
                om.state__c= jsonMapping.get('state') !=null ? jsonMapping.get('state') : '';
                om.zip__c= jsonMapping.get('zip') !=null ? jsonMapping.get('zip') : '';
                om.country__c=jsonMapping.get('country') !=null ? jsonMapping.get('country') : '';
                insert om;
                system.debug('Inserted :: '+om);
                
            }
            
        }
        return om;
    }
    
    @AuraEnabled 
    public static List<Sobject> getMappings(string name){
        
        List<Sobject> em =  new List<Sobject>();
        try{
            
            if(name =='EmployeeMapping'){
                em = [SELECT Id, Name, OnBoard_Object__c, Salesforce_Object__c, first_name__c, middle_name__c, last_name__c, email__c, phone__c, date_of_birth__c, social_security_number__c, has_middle_name__c, street__c, secondary__c, city__c, state__c, zip__c, country__c FROM EmployeeMapping__c where Name=:name limit 1];        
                
            }else if(name =='Authentication'){
                em = [SELECT Id, Name, API_key__c FROM OnboardedOAuth__c where Name=:name limit 1];
            }
            else if(name =='EmployerMapping'){
                em = [SELECT Id, Name, name__c, phone__c, dba_name__c, employee_count__c, entity_structure__c, naics_code__c, street__c, state__c, city__c, zip__c, country__c, ein__c, OnBoard_Object__c, Salesforce_Object__c FROM EmployerMapping__c where Name=:name limit 1];
            }
            else if(name =='ClientMapping'){
                em = [SELECT Id, Name, Salesforce_Object__c, OnBoard_Object__c, name__c FROM ClientMapping__c where Name=:name limit 1];
            }
            else if(name =='JobMapping'){
                em = [SELECT Id, Name, name__c,street__c, secondary__c, city__c, state__c, zip__c, country__c, OnBoard_Object__c, Salesforce_Object__c FROM JobMapping__c where Name=:name limit 1];
            }
             
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
        }
        system.debug('getMappings:: '+em);
        return  em;
        
    }
    
    @AuraEnabled 
    public static void deleteMapping(String name){
        if(name =='EmployeeMapping'){
            EmployeeMapping__c obj = [SELECT Id, Name FROM EmployeeMapping__c where name = : name limit 1];
            if(obj !=null){
                delete obj;
            }
        } 
        else if(name =='Authentication'){
            OnboardedOAuth__c obj = [SELECT Id, Name FROM OnboardedOAuth__c where name = : name limit 1];
            system.debug(obj);
            if(obj !=null){
                delete obj;
            }
        }
        else if(name =='EmployerMapping'){
            EmployerMapping__c obj = [SELECT Id, Name, name__c, phone__c, dba_name__c, employee_count__c, entity_structure__c, naics_code__c, street__c, state__c, city__c, zip__c, country__c, ein__c, OnBoard_Object__c, Salesforce_Object__c FROM EmployerMapping__c where name = : name limit 1];
            system.debug(obj);
            if(obj !=null){
                delete obj;
            }
        }
        else if(name =='ClientMapping'){
            ClientMapping__c obj = [SELECT Id, Name, Salesforce_Object__c, OnBoard_Object__c, name__c FROM ClientMapping__c where name = : name limit 1];
            system.debug(obj);
            if(obj !=null){
                delete obj;
            }
        }
        else if(name =='JobMapping'){
            JobMapping__c obj = [SELECT Id, Name, name__c, OnBoard_Object__c, Salesforce_Object__c FROM JobMapping__c where name = : name limit 1];
            system.debug(obj);
            if(obj !=null){
                delete obj;
            }
        }
    }    
    
    public class ObjectWrapper{
        @AuraEnabled
        Public string objectName ='';
        @AuraEnabled
        Public string objectApi='';
    }  
    
    public class FieldWrapper{
        @AuraEnabled
        Public string fieldName ='';
        @AuraEnabled
        Public string fieldApi='';
    }  
}