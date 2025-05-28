@isTest
public with sharing class CaseRequestTriggerTest {
  //Dentro do setupData é criada a base de registros que será utilizada por todos os testes
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

  //test1: os registros são atualizados, porém o status__c não é closed
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
    //Como o status dos casos não mudou para Closed, nenhum registro do tipo Case_History__c foi criado
    System.assertEquals(
      0,
      newCaseHistories.size(),
      'Quantidade de registros Case History incorreto'
    );
  }

  //test2: os registros são atualizados, o status__c é closed em todos os 5 registros
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
    //Como o status dos casos mudou para Closed, 5 registros do tipo Case_History__c devem ter sido criados
    System.assertEquals(
      5,
      newCaseHistories.size(),
      'Quantidade de registros Case History incorreto'
    );
  }

  //test3: os registros são atualizados, o status__c é atualizado para closed em 3 dos 5 registros
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
    //Como apenas 3 dos 5 casos tiveram o status alterado para Closed, apenas 3 registros do tipo Case_History__c devem ter sido criados
    System.assertEquals(
      3,
      newCaseHistories.size(),
      'Quantidade de registros Case History incorreto'
    );
  }

  //test4: verificação se a lógica do SLA_Met está sendo executada corretamente
  @isTest
  static void test4() {
    List<Case_Request__c> crs = [
      SELECT Id, Name, Status__c, SLA_Deadline__c, Resolution_Notes__c
      FROM Case_Request__c
    ];

    //Add um valor de deadline que não conseguiu ser alcançada
    Datetime deadline = DateTime.now().addDays(-1);
    for (Case_Request__c cr : crs) {
      cr.Status__c = 'Closed';
      cr.SLA_Deadline__c = deadline;
      cr.Resolution_Notes__c = 'Dados teste';
    }

    Test.startTest();
    update crs;
    Test.stopTest();

    List<Case_History__c> newCaseHistories = [
      SELECT Id, Name, Case__c, SLA_Met__c
      FROM Case_History__c
    ];

    //Todos os 5 casos não conseguiram ser fechados antes da deadline, SLA_Met deve ser falso
    for (Case_History__c ch : newCaseHistories) {
      System.assertEquals(false, ch.SLA_Met__c, 'SLA_Met deve ser falso');
    }
  }

  //test5: verificação se a lógica do SLA_Met está sendo executada corretamente
  @isTest
  static void test5() {
    List<Case_Request__c> crs = [
      SELECT Id, Name, Status__c, SLA_Deadline__c, Resolution_Notes__c
      FROM Case_Request__c
    ];

    //Add um valor de deadline que foi alcançada
    Datetime deadline = DateTime.now().addDays(1);
    for (Case_Request__c cr : crs) {
      cr.Status__c = 'Closed';
      cr.SLA_Deadline__c = deadline;
      cr.Resolution_Notes__c = 'Dados teste';
    }

    Test.startTest();
    update crs;
    Test.stopTest();

    List<Case_History__c> newCaseHistories = [
      SELECT Id, Name, Case__c, SLA_Met__c
      FROM Case_History__c
    ];

    //Todos os 5 casos conseguiram ser fechados antes da deadline, SLA_Met deve ser true
    for (Case_History__c ch : newCaseHistories) {
      System.assertEquals(true, ch.SLA_Met__c, 'SLA_Met deve ser falso');
    }
  }
}
