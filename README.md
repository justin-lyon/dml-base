# dml-base

DmlBase class is a layer around Salesforce Database class adding Nebula Logger logging to any errors on Insert, Update, Upsert, and Delete methods.

It is an abstract class that is designed to be extended onto SObject Service classes. This way SObject Service classes can focus on just writing queries.

This Pattern is only possible because of community developments in mocking. Namely [UniversalMock](https://github.com/surajp/universalmock).

# Example

See force-app/main/example for an example of Property Injection for use with stateless Lightning Component Controllers.