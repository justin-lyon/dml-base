/**
 * @author Justin Lyon
 * @date 2019-08-15
 *
 * @group data-layer
 *
 * @description Data Layer Base class for Generic SObject DML.
 *		While methods accept Generic SObject Lists,
 *		the runtime implementation must pass a list of a concrete SObject Type.
 */
public abstract class DmlBase {
  // INSERT Operations
  public void insertRecords(SObject record) {
    insertRecords(new List<SObject> { record });
  }

  public void insertRecords(List<SObject> recordsToInsert) {
    try {
      insert recordsToInsert;
    } catch (Exception exc) {
      Nebula.Logger.warn('Exception during insert', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }
  }

  public Database.SaveResult insertRecordsResult(SObject recordToInsert, Boolean allOrNone) {
    return insertRecordsResult(new List<SObject> { recordToInsert }, allOrNone).get(0);
  }

  public List<Database.SaveResult> insertRecordsResult(List<SObject> recordsToInsert, Boolean allOrNone) {
    Database.DMLOptions options = new Database.DMLOptions();
    options.OptAllOrNone = allOrNone;
    return insertRecordsResult(recordsToInsert, options);
  }

  public Database.SaveResult insertRecordsResult(SObject recordToInsert, Database.DMLOptions options) {
    return insertRecordsResult(new List<SObject> { recordToInsert }, options).get(0);
  }

  public List<Database.SaveResult> insertRecordsResult(List<SObject> recordsToInsert, Database.DMLOptions options) {
    List<Database.SaveResult> results = new List<Database.SaveResult>();
    try {
      results = Database.insert(recordsToInsert, options);

    } catch(Exception exc) {
      Nebula.Logger.warn('Exception during insert', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }

    handleSaveResults(results);
    return results;
  }

  // UPDATE Operations
  public void updateRecords(SObject recordToUpdate) {
    updateRecords(new List<SObject> { recordToUpdate });
  }

  public void updateRecords(List<SObject> recordsToUpdate) {
    try {
      update recordsToUpdate;
    } catch(Exception exc) {
      Nebula.Logger.warn('Exception during update', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }
  }

  public Database.SaveResult updateRecordsResult(SObject recordToUpdate, Boolean allOrNone) {
    return updateRecordsResult(new List<SObject> { recordToUpdate }, allOrNone).get(0);
  }

  public List<Database.SaveResult> updateRecordsResult(List<SObject> recordsToUpdate, Boolean allOrNone) {
    Database.DMLOptions options = new Database.DMLOptions();
    options.OptAllOrNone = allOrNone;
    return updateRecordsResult(recordsToUpdate, options);
  }

  public Database.SaveResult updateRecordsResult(SObject recordToUpdate, Database.DMLOptions options) {
    return updateRecordsResult(new List<SObject> { recordToUpdate }, options).get(0);
  }

  public List<Database.SaveResult> updateRecordsResult(List<SObject> recordsToUpdate, Database.DMLOptions options) {
    List<Database.SaveResult> results = new List<Database.SaveResult>();
    try {
      results = Database.update(recordsToUpdate, options);

    } catch(Exception exc) {
      Nebula.Logger.warn('Exception during update', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }

    handleSaveResults(results);
    return results;
  }

  // UPSERT Operations
  public void upsertRecords(SObject recordToUpsert) {
    upsertRecords(new List<SObject> { recordToUpsert });
  }

  public void upsertRecords(List<SObject> recordsToUpsert) {
    try {
      upsert recordsToUpsert;
    } catch(Exception exc) {
      Nebula.Logger.warn('Exception during upsert', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }
  }

  public Database.UpsertResult upsertRecordsResult(SObject recordToUpsert, Boolean allOrNone) {
    return upsertRecordsResult(new List<SObject> { recordToUpsert }, allOrNone).get(0);
  }

  public List<Database.UpsertResult> upsertRecordsResult(List<SObject> recordsToUpsert, Boolean allOrNone) {
    List<Database.UpsertResult> results = new List<Database.UpsertResult>();
    try {
      results = Database.upsert(recordsToUpsert, allOrNone);

    } catch(Exception exc) {
      Nebula.Logger.warn('Exception during upsert', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }

    handleUpsertResults(results);
    return results;
  }

  // Database.upsert will throw if externalIdField is Null
  public Database.UpsertResult upsertRecordsResult(SObject recordToUpsert, Schema.SObjectField externalIdField, Boolean allOrNone) {
    return upsertRecordsResult(new List<SObject>{ recordToUpsert }, externalIdField, allOrNone).get(0);
  }

  public List<Database.UpsertResult> upsertRecordsResult(List<SObject> recordsToUpsert, Schema.SObjectField externalIdField, Boolean allOrNone) {
    List<Database.UpsertResult> results = new List<Database.UpsertResult>();
    try {
      results = Database.upsert(recordsToUpsert, externalIdField, allOrNone);

    } catch(Exception exc) {
      Nebula.Logger.warn('Exception during upsert', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }

    handleUpsertResults(results);
    return results;
  }

  // DELETE Operations
  public void deleteRecords(SObject recordToDelete) {
    deleteRecords(new List<SObject> { recordToDelete });
  }

  public void deleteRecords(List<SObject> recordsToDelete) {
    try {
      delete recordsToDelete;
    } catch(Exception exc) {
      Nebula.Logger.warn('Exception during delete', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }
  }

  public Database.DeleteResult deleteRecordsResult(SObject recordToDelete, Boolean allOrNone) {
    return deleteRecordsResult(new List<SObject> { recordToDelete }, allOrNone).get(0);
  }

  public List<Database.DeleteResult> deleteRecordsResult(List<SObject> recordsToDelete, Boolean allOrNone) {
    List<Database.DeleteResult> results = new List<Database.DeleteResult>();
    try {
      results = Database.delete(recordsToDelete, allOrNone);

    } catch(Exception exc) {
      Nebula.Logger.warn('Exception during delete', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }

    handleDeleteResults(results);
    return results;
  }

  public Database.DeleteResult deleteRecordsResult(Id recordIdToDelete, Boolean allOrNone) {
    return deleteRecordsResult(new List<Id> { recordIdToDelete }, allOrNone).get(0);
  }

  public List<Database.DeleteResult> deleteRecordsResult(List<Id> recordIdsToDelete, Boolean allOrNone) {
    List<Database.DeleteResult> results = new List<Database.DeleteResult>();
    try {
      results = Database.delete(recordIdsToDelete, allOrNone);

    } catch(Exception exc) {
      Nebula.Logger.warn('Exception during delete', exc);
      Nebula.Logger.saveLog();
      throw exc;
    }

    handleDeleteResults(results);
    return results;
  }

  // Result Logging
  private void handleSaveResults(List<Database.SaveResult> results) {
    for (Database.SaveResult r : results) {
      if (!r.isSuccess()) {
        Nebula.Logger.warn('Exception during save (insert or update).', r);
      }
    }
    Nebula.Logger.saveLog();
  }

  private void handleUpsertResults(List<Database.UpsertResult> results) {
    for (Database.UpsertResult r : results) {
      if (!r.isSuccess()) {
        Nebula.Logger.warn('Exception during upsert.', r);
      }
    }
    Nebula.Logger.saveLog();
  }

  private void handleDeleteResults(List<Database.DeleteResult> results) {
    for (Database.DeleteResult r : results) {
      if (!r.isSuccess()) {
        Nebula.Logger.warn('Exception during delete.', r);
      }
    }
    Nebula.Logger.saveLog();
  }
}