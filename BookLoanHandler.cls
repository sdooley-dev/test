public class BookLoanHandler {
    public static void updateBookCopy(List<Book_Loan__c> loanRecords) {
        Set<String> bookCopyNumbers = new Set<String>();
        
        // Collect Book_Copy_Number_Loan__c values from Book_Loan__c records
        for (Book_Loan__c loan : loanRecords) {
            if (loan.Book_Copy_Number_Loan__c != null) {
                bookCopyNumbers.add(loan.Book_Copy_Number_Loan__c);
            }
        }
        
        // Convert Book_Copy_Number_Loan__c values to Decimal
        Set<Decimal> decimalBookCopyNumbers = new Set<Decimal>();
        for (String bookCopyNumber : bookCopyNumbers) {
            decimalBookCopyNumbers.add(Decimal.valueOf(bookCopyNumber));
        }
        
        // Query Book_Copy__c records matching Book_Copy_Number_D__c values
        List<Book_Copy__c> bookCopies = [SELECT Id, Last_Checked_Out__c, Last_Checked_In__c, Loan_Status__c FROM Book_Copy__c WHERE Book_Copy_Number_D__c IN :decimalBookCopyNumbers];
        
        // Update Book_Copy__c records based on matching values
        for (Book_Copy__c copy : bookCopies) {
            for (Book_Loan__c loan : loanRecords) {
                if (loan.Book_Copy_Number_Loan__c != null && copy.Book_Copy_Number_D__c == Decimal.valueOf(loan.Book_Copy_Number_Loan__c)) {
                    copy.Last_Checked_Out__c = loan.Checked_Out__c;
                    copy.Last_Checked_In__c = loan.Checked_In__c;
                    copy.Loan_Status__c = loan.Loan_Status__c;
                    break;
                }
            }
        }
        
        // Update the Book_Copy__c records
        update bookCopies;
    }
}
