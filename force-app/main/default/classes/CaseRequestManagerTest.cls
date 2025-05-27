@isTest
public with sharing class CaseRequestManagerTest {
  @TestSetup
  static void dataSetup() {
    List<Case_Request__c> newCases = new List<Case_Request__c>();
    for (Integer i = 0; i < 2; i++) {
      Case_Request__c caseR = new Case_Request__c(
        Name = 'Case ' + i,
        Priority__c = 'Low',
        Subject__c = 'Dado teste',
        Status__c = 'Closed',
        Resolution_Notes__c = 'Dados teste'
      );
      newCases.add(caseR);
    }
    insert newCases;
  }

  @isTest
  public static void test1() {
    Case_Request__c cr = [
      SELECT Id, Status__c, (SELECT Id, SLA_Met__c FROM Case_Histories__r)
      FROM Case_Request__c
    ];

    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/Case_Request__c/' + cr.Id;
    req.httpMethod = 'Get';

    RestContext.request = req;
    RestContext.response = res;
    Test.startTest();
    CaseRequestManager.getCaseRequestById();
    Test.stopTest();
  }
}
