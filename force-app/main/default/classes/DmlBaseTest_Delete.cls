@IsTest
private class DmlBaseTest_Delete {
  private class DmlBaseStub extends DmlBase {}
  private static final DmlBase sut;
  static {
    sut = new DmlBaseStub();
  }

  private static final String ACCOUNT_NAME_OLD = 'Jurassic Five - Quality Control (Dynamic Duo Blend)';
  // BH_ID4Migration__c
  private static final String EXTERNAL_ID = 'InntimateSound';

  @TestSetup
  static void setupData() {
    Account acc = new Account(Name = ACCOUNT_NAME_OLD);
    insert acc;
  }

  @IsTest
  static void deleteRecords_givenOneRecord_shouldDelete() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    Test.startTest();

      sut.deleteRecords(acc);

    Test.stopTest();

    List<Account> accounts = queryAccountsByName(ACCOUNT_NAME_OLD);
    System.assert(accounts.isEmpty());
  }

  @IsTest
  static void deleteRecords_givenOneBadRecord_shouldThrowAndWarn() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    delete acc;

    Boolean isSuccess = false;
    Test.startTest();

      try {
        sut.deleteRecords(acc);
      } catch(Exception exc) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void deleteRecords_givenListRecords_shouldDelete() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    Test.startTest();

      sut.deleteRecords(new List<Account> { acc });

    Test.stopTest();

    List<Account> accounts = queryAccountsByName(ACCOUNT_NAME_OLD);
    System.assert(accounts.isEmpty());
  }

  @IsTest
  static void deleteRecordsResult_givenOneRecord_shouldDelete() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    Test.startTest();

      sut.deleteRecordsResult(acc, true);

    Test.stopTest();

    List<Account> accounts = [SELECT Id FROM Account WHERE Name = :ACCOUNT_NAME_OLD];
    System.assert(accounts.isEmpty());
  }

  @IsTest
  static void deleteRecordsResult_givenOneBadRecordAllOrNoneTrue_shouldThrowAndWarn() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    delete acc;

    Boolean isSuccess = false;
    Test.startTest();

      try {
        sut.deleteRecordsResult(acc, true);
      } catch(Exception exc) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void deleteRecordsResult_givenOneBadRecordAllOrNoneFalse_shouldWarn() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    delete acc;

    Test.startTest();

      sut.deleteRecordsResult(acc, false);

    Test.stopTest();

    assertNebulaWarning();
  }

  @IsTest
  static void deleteRecordsResult_givenListRecords_shouldDelete() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    Test.startTest();

      sut.deleteRecordsResult(new List<Account> { acc }, true);

    Test.stopTest();

    List<Account> accounts = queryAccountsByName(ACCOUNT_NAME_OLD);
    System.assert(accounts.isEmpty());
  }

  @IsTest
  static void deleteRecordsResult_givenOneId_shouldDelete() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    Id accountId = acc.Id;
    Test.startTest();

      sut.deleteRecordsResult(accountId, true);

    Test.stopTest();

    List<Account> accounts = queryAccountsByName(ACCOUNT_NAME_OLD);
    System.assert(accounts.isEmpty());
  }

  @IsTest
  static void deleteRecordsResult_givenOneBadIdAllOrNoneTrue_shouldThrowAndWarn() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    Id accountId = acc.Id;
    delete acc;

    Boolean isSuccess = false;
    Test.startTest();

      try {
        sut.deleteRecordsResult(accountId, true);
      } catch(Exception exc) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void deleteRecordsResult_givenOneBadIdAllOrNoneFalse_shouldWarn() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    Id accountId = acc.Id;
    delete acc;

    Test.startTest();

      sut.deleteRecordsResult(accountId, false);

    Test.stopTest();

    assertNebulaWarning();
  }

  @IsTest
  static void deleteRecordsResult_givenListId_shouldDelete() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    Id accountId = acc.Id;
    Test.startTest();

      sut.deleteRecordsResult(new List<Id> { accountId }, true);

    Test.stopTest();

    List<Account> accounts = queryAccountsByName(ACCOUNT_NAME_OLD);
    System.assert(accounts.isEmpty());
  }

  private static void assertNebulaWarning() {
    List<Nebula__LogEntry__c> logEvents = [
      SELECT Id, Nebula__ExceptionMessage__c, Nebula__ExceptionStackTrace__c, Nebula__LoggingLevel__c, Nebula__Message__c
      FROM Nebula__LogEntry__c];

    System.assertEquals(1, logEvents.size());
    Nebula__LogEntry__c warning = logEvents.get(0);
    System.assertEquals(warning.Nebula__LoggingLevel__c, LoggingLevel.WARN.name());
  }

  private static Account queryOneAccountByName(final String name) {
    return [
      SELECT Id, Name
      FROM Account
      WHERE Name = :name
      LIMIT 1
    ];
  }

  private static List<Account> queryAccountsByName(final String name) {
    return [
      SELECT Id
      FROM Account
      WHERE Name = :name
    ];
  }
}