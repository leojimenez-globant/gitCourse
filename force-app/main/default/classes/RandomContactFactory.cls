public with sharing class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numberOfContacts , String lastName) {

        List<Contact> listContact = new List<Contact> ();

        for(Integer i=0;i<numberOfContacts;i++) {
            Contact c = new Contact(FirstName ='Test' + i, LastName = lastName);
            listContact.add(c);
        }

        return listContact;
    }
}