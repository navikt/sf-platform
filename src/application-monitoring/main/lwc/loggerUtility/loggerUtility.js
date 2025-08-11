import singleLog from "@salesforce/apex/LoggerUtility.singleLog";

export default class LoggerUtility {
  static logError(domain, category, error, message, recordId) {
    singleLog({
      domain: domain,
      category: category,
      payload: JSON.stringify(error),
      logLevel: "Error",
      recordId: recordId,
      message: message,
    });
  }

  static logInfo(domain, category, error, message, recordId) {
    singleLog({
      domain: domain,
      category: category,
      payload: JSON.stringify(error),
      logLevel: "Info",
      recordId: recordId,
      message: message,
    });
  }
}
