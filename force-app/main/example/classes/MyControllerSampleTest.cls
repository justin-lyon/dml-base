@IsTest
private class MyControllerSampleTest {
  private static final UniversalMocker mockService;
  private static final ContactService mockServiceStub;

  static {
    mockService = UniversalMocker.mock(ContactService.class);
    mockServiceStub = (ContactService) mockService.createStub();
    MyControllerSample.setService(mockServiceStub);
  }

  @IsTest
  static void searchContactsByName_givenString_shouldInvokeService() {
    String mockedMethodName = 'queryByName';
    mockService.when(mockedMethodName).thenReturn(new List<Contact>());

    Test.startTest();

      MyControllerSample.searchContactsByName('anyString');

    Test.stopTest();

    mockService.assertThat().method(mockedMethodName).wasCalled(1);
  }

  @IsTest
  static void saveContact_givenContact_shouldInvokeService() {
    String mockedMethodName = 'insertRecords';
    mockService.when(mockedMethodName).thenReturnVoid();

    Test.startTest();

      MyControllerSample.saveContact(new Contact());

    Test.stopTest();

    mockService.assertThat().method(mockedMethodName).wasCalled(1);
  }
}