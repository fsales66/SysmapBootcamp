@isTest
public with sharing class CaseRequestTriggerTest {
  @TestSetup
  static void setupData() {
    List<Case_Request__c> newCases = new List<Case_Request__c>();
    for (Integer i = 0; i < 5; i++) {
      Case_Request__c caseR = new Case_Request__c(
        Name = 'Case ' + i,
        Priority__c = 'Low',
        Subject__c = 'Dado teste',
        Status__c = 'New'
      );
      newCases.add(caseR);
    }
    insert newCases;
  }

  @isTest
  static void test1() {
    List<Case_Request__c> crs = [
      SELECT Id, Name, Status__c, SLA_Deadline__c, Resolution_Notes__c
      FROM Case_Request__c
    ];

    List<Case_Request__c> updateCr = new List<Case_Request__c>();
    for (Case_Request__c cr : crs) {
      cr.Resolution_Notes__c = 'Dados teste';
      updateCr.add(cr);
    }

    Test.startTest();
    update updateCr;
    Test.stopTest();

    List<Case_History__c> newCaseHistories = [
      SELECT Id, Name, Case__c
      FROM Case_History__c
    ];

    //Compara se 5 registros foram criados
    System.assertEquals(
      5,
      updateCr.size(),
      'Quantidade de registros Case Request incorreto'
    );
    System.assertEquals(
      0,
      newCaseHistories.size(),
      'Quantidade de registros Case History incorreto'
    );
  }

  @isTest
  static void test2() {
    List<Case_Request__c> crs = [
      SELECT Id, Name, Status__c, SLA_Deadline__c, Resolution_Notes__c
      FROM Case_Request__c
    ];

    List<Case_Request__c> updateCr = new List<Case_Request__c>();
    for (Case_Request__c cr : crs) {
      cr.Status__c = 'Closed';
      cr.Resolution_Notes__c = 'Dados teste';
      updateCr.add(cr);
    }

    Test.startTest();
    update updateCr;
    Test.stopTest();

    List<Case_History__c> newCaseHistories = [
      SELECT Id, Name, Case__c
      FROM Case_History__c
    ];
    //Compara se 5 registros foram criados
    System.assertEquals(
      5,
      updateCr.size(),
      'Quantidade de registros Case Request incorreto'
    );
    System.assertEquals(
      5,
      newCaseHistories.size(),
      'Quantidade de registros Case History incorreto'
    );
  }

  @isTest
  static void test3() {
    List<Case_Request__c> crs = [
      SELECT Id, Name, Status__c, SLA_Deadline__c, Resolution_Notes__c
      FROM Case_Request__c
    ];

    crs[0].Status__c = 'Closed';
    crs[0].Resolution_Notes__c = 'Dados teste';
    crs[1].Status__c = 'Closed';
    crs[1].Resolution_Notes__c = 'Dados teste';
    crs[2].Status__c = 'Closed';
    crs[2].Resolution_Notes__c = 'Dados teste';

    Test.startTest();
    update crs;
    Test.stopTest();

    List<Case_History__c> newCaseHistories = [
      SELECT Id, Name, Case__c
      FROM Case_History__c
    ];
    //Compara se 5 registros foram criados
    System.assertEquals(
      5,
      crs.size(),
      'Quantidade de registros Case Request incorreto'
    );
    System.assertEquals(
      3,
      newCaseHistories.size(),
      'Quantidade de registros Case History incorreto'
    );
  }
}
