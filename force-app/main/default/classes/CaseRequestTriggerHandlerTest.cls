@isTest
public with sharing class CaseRequestTriggerHandlerTest {
  @TestSetup
  static void setupData() {
    List<Case_Request__c> newCases = new List<Case_Request__c>();
    for (Integer i = 0; i < 5; i++) {
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
  static void test1() {
    List<Case_Request__c> cr = [
      SELECT Id, Name, Status__c, SLA_Deadline__c
      FROM Case_Request__c
    ];
    test.startTest();
    CaseRequestTriggerHandler.createCaseHistory(cr);
    test.stopTest();

    List<Case_History__c> newCaseHistories = [
      SELECT Id, Name, Case__c
      FROM Case_History__c
    ];

    System.assertEquals(
      5,
      cr.size(),
      'Quantidade de registros Case Request incorreto'
    );
    System.assertEquals(
      5,
      newCaseHistories.size(),
      'Quantidade de registros Case History incorreto'
    );
  }
}
