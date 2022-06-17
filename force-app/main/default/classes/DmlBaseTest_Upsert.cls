@IsTest
private class DmlBaseTest_Upsert {
  private class DmlBaseStub extends DmlBase {}
  private static final DmlBase sut;
  static {
    sut = new DmlBaseStub();
  }

  private static final String ACCOUNT_NAME_TO_INSERT = 'Common - I Used to Love Her (Shin-Ski Blend)';
  private static final String ACCOUNT_NAME_NEW = 'Mos Def - Mathamatics (Dok2 Blend)';
  private static final String ACCOUNT_NAME_OLD = 'Jurassic Five - Quality Control (Dynamic Duo Blend)';
  // BH_ID4Migration__c
  private static final String EXTERNAL_ID = 'InntimateSound';

  @TestSetup
  static void setupData() {
    Account acc = new Account(Name = ACCOUNT_NAME_OLD);
    insert acc;
  }

  @IsTest
  static void upsertRecords_givenOneRecord_shouldUpsertTheRecord() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);

    Test.startTest();

      sut.upsertRecords(acc);

    Test.stopTest();

    Account actual = [
      SELECT Id, Name
      FROM Account
      WHERE Name = :ACCOUNT_NAME_TO_INSERT
      LIMIT 1];

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void upsertRecords_givenOneBadRecord_shouldThrowAndWarn() {
    Account acc = new Account();
    Boolean isSuccess = false;
    Test.startTest();

      try {
        sut.upsertRecords(acc);

      } catch (DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void upsertRecordsResult_givenOneNewRecord_shouldInsert() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);
    Test.startTest();

      sut.upsertRecordsResult(acc, true);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void upsertRecordsresult_givenGivenOneOldRecord_shouldUpdate() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_OLD);
    acc.Name = ACCOUNT_NAME_NEW;

    Test.startTest();

      sut.upsertRecordsResult(acc, true);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_NEW);
    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_NEW, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void upsertRecordsResult_givenOneBadRecordAllOrNoneTrue_shouldThrowAndWarn() {
    Account acc = new Account();
    Boolean isSuccess = false;

    Test.startTest();

      try {
        sut.upsertRecordsResult(acc, true);

      } catch (DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void upsertRecordsResult_givenOneBadRecordAllOrNoneFalse_shouldWarn() {
    Account acc = new Account();
    Boolean isSuccess = false;

    Test.startTest();

      sut.upsertRecordsResult(acc, false);

    Test.stopTest();

    assertNebulaWarning();
  }

  @IsTest
  static void upsertRecordsResult_givenListRecords_shouldInsert() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);
    Test.startTest();

      sut.upsertRecordsResult(new List<Account> { acc }, true);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void upsertRecordsResult_givenOneExternalRecord_shouldInsert() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);
    acc.BH_ID4Migration__c = EXTERNAL_ID;
    Test.startTest();

      sut.upsertRecordsResult(acc, Account.BH_ID4Migration__c, true);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.BH_ID4Migration__c, actual.BH_ID4Migration__c);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void upsertRecordsResult_givenOneBadExternalRecordAllOrNoneTrue_shouldThrowAndWarn() {
    Account acc = new Account();
    acc.BH_ID4Migration__c = EXTERNAL_ID;
    Boolean isSuccess = false;

    Test.startTest();

      try {
        sut.upsertRecordsResult(acc, Account.BH_ID4Migration__c, true);

      } catch (DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void upsertRecordsResult_givenOneBadExternalRecordAllorNoneFalse_shouldWarn() {
    Account acc = new Account();
    acc.BH_ID4Migration__c = EXTERNAL_ID;
    Test.startTest();

      sut.upsertRecordsResult(acc, Account.BH_ID4Migration__c, false);

    Test.stopTest();

    assertNebulaWarning();
  }

  @IsTest
  static void upsertRecordsResult_givenListExternalRecord_shouldInsert() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);
    acc.BH_ID4Migration__c = EXTERNAL_ID;
    Test.startTest();

      sut.upsertRecordsResult(new List<Account> { acc }, Account.BH_ID4Migration__c, true);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.BH_ID4Migration__c, actual.BH_ID4Migration__c);
    System.assertEquals(acc.Id, actual.Id);
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
      SELECT Id, Name, BH_ID4Migration__c
      FROM Account
      WHERE Name = :name
      LIMIT 1];
  }
}