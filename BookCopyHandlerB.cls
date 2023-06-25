public class BookCopyHandlerB {

    // method to update Book_Copy_Number_D__c, Loan_Status__c
    public static void updateBookCopyDetails(List<Book_Copy__c> copies) {
        Set<Id> bookIds = new Set<Id>();

        // find the book copy in [Book__c] and add it
        for (Book_Copy__c copy : copies) {
            if (copy.Book__c != null) {
                bookIds.add(copy.Book__c);
            }
        }

        Map<Id, Book__c> booksMap = new Map<Id, Book__c>([SELECT Id, Number_of_Copies__c FROM Book__c WHERE Id IN :bookIds]);

        for (Book_Copy__c copy : copies) {
            if (copy.Book__c != null) {
                Book__c book = booksMap.get(copy.Book__c);
                if (book != null) {

                    // increment copy number by 1 for that book title
                    copy.Book_Copy_Number_D__c = book.Number_of_Copies__c + 1;
                    // copy.Name = 'name test' + book.Name;

                    // insert status
                    copy.Loan_Status__c = 'Checked In'; 
                    // insert date for first check-in
                    // need this for placing book into circulation for first time
                    copy.Last_Checked_In__c = Date.today(); 
                }
            }
        }
    }
}