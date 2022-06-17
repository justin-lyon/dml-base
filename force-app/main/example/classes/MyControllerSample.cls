public with sharing class MyControllerSample {
  // Allow Dependency Injection during Testing
  private static ContactService service = new ContactService();
  @TestVisible
  private static void setService(ContactService cs) {
    service = cs;
  }

  // Calls query method directly on the Service.
  public static List<Contact> searchContactsByName(final String name) {
    return service.queryByName(name);
  }

  // Calls insert method inherited by the service from DmlBase
  public static void saveContact(Contact newContact) {
    service.insertRecords(newContact);
  }
}