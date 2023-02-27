public with sharing class AccountHandler {
    public static Account insertNewAccount(String nombre) {
        
        Account acc = new Account(Name = nombre);

        try {
            insert acc;
            return acc;
        } catch (Exception e) {
            return null;
        }

    }
}