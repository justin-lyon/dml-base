@IsTest
private class DmlBaseTest_Insert {
  private class DmlBaseStub extends DmlBase {}
  private static final DmlBase sut;
  static {
    sut = new DmlBaseStub();
  }

  private static final String ACCOUNT_NAME_TO_INSERT = 'Common - I Used to Love Her (Shin-Ski Blend)';

  @IsTest
  static void insertRecords_givenOneRecord_shouldInsertTheRecord() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);

    Test.startTest();

      sut.insertRecords(acc);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void insertRecords_givenOneBadRecord_shouldThrowDmlException() {
    Account acc = new Account();

    Boolean isSuccess = false;
    Test.startTest();

      try {
        sut.insertRecords(acc);

      } catch (DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void insertRecords_givenListRecords_shouldInsertRecords() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);

    Test.startTest();

      sut.insertRecords(new List<Account> { acc });

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void insertRecords_givenListBadRecords_shouldThrowDmlException() {
  Account acc = new Account();

    Boolean isSuccess = false;
    Test.startTest();

      try {
        sut.insertRecords(new List<Account> { acc });

      } catch (DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void insertRecordsResult_givenOneRecordAllOrNoneTrue_shouldInsertRecord() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);

    Test.startTest();

      sut.insertRecordsResult(acc, true);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void insertRecordsResult_givenOneBadRecordAllOrNoneTrue_shouldThrowAndWarn() {
    Account acc = new Account();
    Boolean isSuccess = false;

    Test.startTest();

      try {
        sut.insertRecordsResult(acc, true);
      } catch(DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();
    System.assert(isSuccess, 'Should have caught a DML Exception.');

    assertNebulaWarning();
  }

  @IsTest
  static void insertRecordsResult_givenOneBadRecordAllOrNoneFalse_shouldWarn() {
    Account acc = new Account();

    Test.startTest();

      sut.insertRecordsResult(acc, false);

    Test.stopTest();

    assertNebulaWarning();
  }

  @IsTest
  static void insertRecordsResult_givenListRecordAllOrNoneTrue_shouldInsertRecord() {
  Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);

    Test.startTest();

      sut.insertRecordsResult(new List<Account> { acc }, true);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void insertRecordsResult_givenOneRecordWithOptions_shouldInsertRecord() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);
    Database.DMLOptions options = new Database.DMLOptions();

    Test.startTest();

      sut.insertRecordsResult(acc, options);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
    System.assertEquals(acc.Id, actual.Id);
  }

  @IsTest
  static void insertRecordsResult_givenOneBadRecordWithOptionsAllOrNoneTrue_shouldThrowAndWarn() {
    Account acc = new Account();
    Database.DMLOptions options = new Database.DMLOptions();
    options.OptAllOrNone = true;
    Boolean isSuccess = false;

    Test.startTest();

      try {
        sut.insertRecordsResult(acc, options);
      } catch(DmlException dmle) {
        isSuccess = true;
      }

    Test.stopTest();

    System.assert(isSuccess, 'Exceptions should bubble up.');

    assertNebulaWarning();
  }

  @IsTest
  static void insertRecordsResult_givenOneBadRecordWithOptionsAllOrNoneFalse_shouldShouldWarn() {
    Account acc = new Account();
    Database.DMLOptions options = new Database.DMLOptions();
    options.OptAllOrNone = false;
    Boolean isSuccess = false;

    Test.startTest();

      sut.insertRecordsResult(acc, options);

    Test.stopTest();

    assertNebulaWarning();
  }

  @IsTest
  static void insertRecordsResult_givenListRecordsWithOptions_shouldInsertRecord() {
    Account acc = new Account(Name = ACCOUNT_NAME_TO_INSERT);
    Database.DMLOptions options = new Database.DMLOptions();

    Test.startTest();

      sut.insertRecordsResult(new List<Account> { acc }, options);

    Test.stopTest();

    Account actual = queryOneAccountByName(ACCOUNT_NAME_TO_INSERT);

    System.assertNotEquals(null, actual.Id);
    System.assertEquals(ACCOUNT_NAME_TO_INSERT, actual.Name);
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