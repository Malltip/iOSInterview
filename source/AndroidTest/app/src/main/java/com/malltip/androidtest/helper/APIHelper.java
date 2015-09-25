package com.malltip.androidtest.helper;

import org.json.JSONObject;

/**
 * Created by nerdynerd on 9/25/15.
 */
public class APIHelper {
    private static String FeedsURL = "https://m.malltip.com/api/v1/mall/4168/feed/offset/0";

    public static JSONObject getFeeds() {
        JSONParser jsonParser = new JSONParser();
        JSONObject json = jsonParser.getJSONFromUrlAndJSONGet(FeedsURL, new JSONObject());
        return  json;
    }
}
