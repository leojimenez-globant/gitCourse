public with sharing class StringArrayTest {
    
    public static List<string> generateStringArray(Integer sizeOfArray) {

        List<String> lString = new List<String>();

        for (Integer i = 0; i < sizeOfArray; i++) {
            lString.add('Test ' + i);
        }

        return lString;
    }
}