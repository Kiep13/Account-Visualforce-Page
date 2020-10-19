public with sharing class AccountPageController {
    public List<Account> accountList {get;set;}
    public List<SelectOption> accountSelectOptionList {get;set;}
    public List<Contact> contactList {get;set;}
    public String accountId {get;set;}
    public Account account {get;set;}

    public AccountPageController() {

        accountList = [SELECT Id, Name FROM Account ORDER BY Name ASC];
        accountSelectOptionList = new List<SelectOption>();
        accountId = accountList.isEmpty() == FALSE ? accountList[0].Id : NULL;
        
        for(Account item : accountList){
            accountSelectOptionList.add(new SelectOption(item.Id, item.Name));
        }
   
        getAccount();
    }

    public void getAccount(){
        account = [SELECT Id, Name, AccountNumber, 	Type,
                          SLAExpirationDate__c, Phone, Industry, AnnualRevenue,
                          Rating, Fax, NumberOfEmployees,
                          (SELECT Id, Name, Title, Phone, AccountId FROM Contacts) 
                          FROM Account WHERE Id =: accountId LIMIT 1];  
    }
}
