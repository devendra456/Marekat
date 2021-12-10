class AppConfig {
  static String app_name = "Marekat"; //this shows in the splash screen

  //configure this
  static const bool HTTPS = true;

  //configure this
  static const DOMAIN_PATH = "marekat.com";
  static const SLUG_URL = "https://demo.marekat.com/product/";
  static const GOOGLE_API_KEY = "AIzaSyAIySYF5ZwWZyBj6bHICn3Ut5xYfg8ilSs";

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PUBLIC_FOLDER = "public";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";

  //configure this if you are using amazon s3 like services
  //give direct link to file like https://[[bucketname]].s3.ap-southeast-1.amazonaws.com/
  //otherwise do not change anythink
  static const String BASE_PATH = "$RAW_BASE_URL/$PUBLIC_FOLDER/";
}
