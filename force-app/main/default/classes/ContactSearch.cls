public with sharing class ContactSearch {
        
        public static List<Contact> searchForContacts(String lastName , String mailingPostal) {
        
            List<Contact> lContact = new List<Contact>();

            for(Contact lC : [SELECT Id, Name FROM Contact WHERE LastName = :lastName AND MailingPostalCode = :mailingPostal]){
                lContact.add(lC);
            }
            return lContact;
    }
}