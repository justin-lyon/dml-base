public with sharing class ContactService extends DmlBase {
  public List<Contact> queryByName(final String name) {
    return [
      SELECT Id, Name, FirstName, LastName, Email
      FROM Contact
      WHERE Name = :name
    ];
  }
}