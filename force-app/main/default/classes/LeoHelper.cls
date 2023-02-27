public with sharing class LeoHelper {
    public static Map<String, Schema.SObjectType> schemaObjectGlobalDescribe;
	public static Map<String, Schema.SObjectField> sObjectFieldMap;
	public static Schema.SObjectType sObjectType;
    
    public LeoHelper() {
	}

    public static void FieldMapInitialize(String objectName) {
		schemaObjectGlobalDescribe = Schema.getGlobalDescribe();
		sObjectType = schemaObjectGlobalDescribe.get(objectName);
		sObjectFieldMap = sObjectType.getDescribe().fields.getMap();
	}
    public static Map<String,String> FieldsFromFieldSet(String fieldSetName) {
        Map<String,String> mapLabelFieldPath = new Map<String, String>();
        System.debug(fieldSetName);
        System.debug(sObjectType);
		if(!String.isEmpty(fieldSetName)){
			List<Schema.FieldSetMember> fieldSetMember = sObjectType.getDescribe()
				.fieldSets
				.getMap()
				.get(fieldSetName)
				.getFields();

            for(Schema.FieldSetMember test : fieldSetMember){
                if(!mapLabelFieldPath.containsKey(test.getLabel())){
                    mapLabelFieldPath.put(test.getLabel(), test.getFieldPath());
                }
            }
            return mapLabelFieldPath;
		}
		return null;
	}
    @AuraEnabled
    public static Map<String,String> RetrieveFieldMap(String objectName, String fieldSetName){
        FieldMapInitialize(objectName);
        return FieldsFromFieldSet(fieldSetName);
    }
}