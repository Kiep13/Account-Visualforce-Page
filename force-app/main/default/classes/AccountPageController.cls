public with sharing class AccountPageController {
    public static Integer PAGE_NUMBER = 10;

    public List<Account> accountList {get;set;}
    public List<SelectOption> accountSelectOptionList {get;set;}
    public List<Contact> contactList {get;set;}
    public String accountId {get;set;}
    public Account account {get;set;}
    public List<Contact> contacts {get;set;}
    public Contact newContact {get; set;}
    public Account newAccount {get; set;}

    public Boolean isAccountAddForm {get;set;}
    public Boolean isContactAddForm {get;set;}

    public ApexPages.StandardSetController contactsConroller {get;set;}
    public Integer pageNumber {get;set;}

    public Boolean hasPrevious {
        get {
            return contactsConroller.getHasPrevious();
        }
        set;
    }

    public Boolean hasNext {
        get {
            return contactsConroller.getHasNext();
        }
        set;
    }

    public AccountPageController() {

        accountList = [SELECT Id, Name FROM Account ORDER BY Name ASC];
        accountSelectOptionList = new List<SelectOption>();
        accountId = accountList.isEmpty() == FALSE ? accountList[0].Id : NULL;
        
        for(Account item : accountList){
            accountSelectOptionList.add(new SelectOption(item.Id, item.Name));
        }
   
        isAccountAddForm = false;
        isContactAddForm = false;

        newContact = new Contact();
        newAccount = new Account();

        getAccount();
    }

    public void getAccount(){
        account = [SELECT Id, Name, AccountNumber, 	Type,
                          SLAExpirationDate__c, Phone, Industry, AnnualRevenue,
                          Rating, Fax, NumberOfEmployees,
                          (SELECT Id, Name, Title, Phone, AccountId FROM Contacts) 
                          FROM Account WHERE Id =: accountId LIMIT 1];  

        contactsConroller = new ApexPages.StandardSetController(Database.getQueryLocator(
            [SELECT Id, Name, Title, Phone, AccountId FROM Contact WHERE AccountId = :account.Id]));
        contactsConroller.setPageSize(10);

        pageNumber = 1;

        getContactsPage();
    }

    public void getContactsPage() {
        contactsConroller.setPageNumber(pageNumber);
        contacts = contactsConroller.getRecords();
    }

    public void previousContactsPage() {
        if(contactsConroller.getHasPrevious()) {
            pageNumber--;
            getContactsPage();
        }
    }

    public void nextContactsPage() {
        if(contactsConroller.getHasNext()) {
            pageNumber++;
            getContactsPage();
        }
    }

    public void openAccountForm() {
        isAccountAddForm = true;
        newAccount = new Account();
    }

    public void openContactForm() {
        isContactAddForm = true;
        newContact = new Contact();
    }

    public void closeAccountForm() {
        isAccountAddForm = false;
    }

    public void closeContactForm() {
        isContactAddForm = false;
    }

    public void saveAccount() {
        insert newAccount;
        accountSelectOptionList.add(new SelectOption(newAccount.Id, newAccount.Name));
        this.closeAccountForm();
        newAccount = new Account();
    }

    public void saveContact() {
        newContact.AccountId = account.Id;
        insert newContact;
        this.getAccount();
        this.closeContactForm();
        newContact = new Contact();
    }
}
