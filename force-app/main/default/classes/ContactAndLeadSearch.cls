public with sharing class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(String matchedString) {

        List<List<SObject>> searchList = [FIND :matchedString IN ALL FIELDS 
        RETURNING Lead(LastName),Contact(FirstName,LastName)];

        return searchList;
    }
}