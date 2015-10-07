package com.franz.testproject.helper;

import android.content.Context;

import com.squareup.okhttp.Cache;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;

/**
 * Created by Franz on 10/7/2015.
 */
public class Communication {
//    private static String FEEDS_URL = "https://m.malltip.com/api/v1/mall/4170/feed/offset/0";
    private static String FEEDS_URL = "https://m.malltip.com/api/v1/mall/4168/feed/offset/0";
    public Context context;
    OkHttpClient client;

    public Communication(Context con) {
        this.context = con;
        client = new OkHttpClient();
        File cacheDirectory = new File(con.getCacheDir(), "http");
        int cacheSize = 10 * 1024 * 1024;
        Cache cache = new Cache(cacheDirectory, cacheSize);
        client.setCache(cache);
    }

    public JSONObject getJSONFeedResponse()
    {
        Request request = new Request.Builder()
                .url(FEEDS_URL)
                .build();

        Response response = null;
        try {
            response = client.newCall(request).execute();
            String feedResponse = response.body().string();
            try {
                JSONObject jsonResponse = new JSONObject(feedResponse);
                return new JSONObject(feedResponse);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
