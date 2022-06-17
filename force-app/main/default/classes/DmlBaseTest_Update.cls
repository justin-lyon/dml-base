@IsTest
private class DmlBaseTest_Update {
  private class DmlBaseStub extends DmlBase {}
  private static final DmlBase sut;
  static {
    sut = new DmlBaseStub();
  }

  private static final String ACCOUNT_NAME_TO_INSERT = 'Common - I Used to Love Her (Shin-Ski Blend)';
  private static final String ACCOUNT_NAME_NEW = 'Mos Def - Mathamatics (Dok2 Blend)';

  @TestSetup
  static void setupData() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);
    insert acc;
  }

  @IsTest
  static void updateRecords_givenOneRecord_shouldInsertTheRecord() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
    acc.Name = ACCOUNT_NAME_NEW;

    Test.startTest();

      sut.updateRecords(acc);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_NEW);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_NEW, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void updateRecords_givenOneBadRecord_shouldThrowDmlException() {
    Account acc = new Account();

    Boolean isSuccess = false;
    Test.startTest();

      try {
        sut.updateRecords(acc);

      } catch (DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void updateRecords_givenListRecords_shouldUpdateRecords() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
    acc.Name = ACCOUNT_NAME_NEW;

    Test.startTest();

      sut.updateRecords(new List<Account> { acc });

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_NEW);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_NEW, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void updateRecords_givenListBadRecords_shouldThrowDmlException() {
  Account acc = new Account();

    Boolean isSuccess = false;
    Test.startTest();

      try {
        sut.updateRecords(new List<Account> { acc });

      } catch (DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void updateRecordsResult_givenOneRecordAllOrNoneTrue_shouldInsertRecord() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
    acc.Name = ACCOUNT_NAME_NEW;

    Test.startTest();

      sut.updateRecordsResult(acc, true);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_NEW);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_NEW, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void updateRecordsResult_givenOneBadRecordAllOrNoneTrue_shouldThrowAndWarn() {
    Account acc = new Account();
    Boolean isSuccess = false;

    Test.startTest();

      try {
        sut.updateRecordsResult(acc, true);
      } catch(DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();
    System.assert(isSuccess, 'Should have caught a DML Exception.');

    assertNebulaWarning();
  }

  @IsTest
  static void updateRecordsResult_givenOneBadRecordAllOrNoneFalse_shouldWarn() {
    Account acc = new Account();

    Test.startTest();

      sut.updateRecordsResult(acc, false);

    Test.stopTest();

    assertNebulaWarning();
  }

  @IsTest
  static void updateRecordsResult_givenListRecordAllOrNoneTrue_shouldInsertRecord() {
  Account acc = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
  acc.Name = ACCOUNT_NAME_NEW;

    Test.startTest();

      sut.updateRecordsResult(new List<Account> { acc }, true);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_NEW);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_NEW, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void updateRecordsResult_givenOneRecordWithOptions_shouldInsertRecord() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
    acc.Name = ACCOUNT_NAME_NEW;
    Database.DMLOptions options = new Database.DMLOptions();

    Test.startTest();

      sut.updateRecordsResult(acc, options);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_NEW);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_NEW, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void updateRecordsResult_givenOneBadRecordWithOptionsAllOrNoneTrue_shouldThrowAndWarn() {
    Account acc = new Account();
    Database.DMLOptions options = new Database.DMLOptions();
    options.OptAllOrNone = true;
    Boolean isSuccess = false;

    Test.startTest();

      try {
        sut.updateRecordsResult(acc, options);
      } catch(DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void updateRecordsResult_givenOneBadRecordWithOptionsAllOrNoneFalse_shouldShouldWarn() {
    Account acc = new Account();
    Database.DMLOptions options = new Database.DMLOptions();
    options.OptAllOrNone = false;
    Boolean isSuccess = false;

    Test.startTest();

      sut.updateRecordsResult(acc, options);

    Test.stopTest();

    assertNebulaWarning();
  }

  @IsTest
  static void updateRecordsResult_givenListRecordsWithOptions_shouldInsertRecord() {
    Account acc = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);
    acc.Name = ACCOUNT_NAME_NEW;
    Database.DMLOptions options = new Database.DMLOptions();

    Test.startTest();

      sut.updateRecordsResult(new List<Account> { acc }, options);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_NEW);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_NEW, actual.Name);
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
      SELECT Id, Name
      FROM Account
      WHERE Name = :name
      LIMIT 1];
  }
}