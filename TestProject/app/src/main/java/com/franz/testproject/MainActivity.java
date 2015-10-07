package com.franz.testproject;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ListView;

import com.franz.testproject.helper.Communication;
import com.franz.testproject.helper.adapter.FeedsAdapter;
import com.franz.testproject.model.FeedInfo;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;


public class MainActivity extends ActionBarActivity {

    FeedsAdapter feedsAdapter;
    ArrayList<FeedInfo> arrayOfFeed;
    ProgressDialog progressDialog;
    Communication communication;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        setTitle(R.string.main_title);
        communication = new Communication(this);
        loadFeeds();
    }

    void loadFeeds()
    {
        AsyncTask<Void, Void, JSONObject> getFeedTask = new AsyncTask<Void, Void, JSONObject>() {


            @Override
            protected void onPreExecute() {
                progressDialog = ProgressDialog.show(MainActivity.this, "Loading", "Getting the feeds now...", true);
            }

            @Override
            protected JSONObject doInBackground(Void... params) {
                JSONObject jsonResponse = communication.getJSONFeedResponse();
                return jsonResponse;
            }

            @Override
            protected void onPostExecute(JSONObject result) {
                try {
                    JSONArray jsonFeeds = result.getJSONArray("feeds");
                    makeFeedArray(jsonFeeds);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                progressDialog.dismiss();
            }
        };

        // execute AsyncTask
        getFeedTask.execute(null, null, null);
    }

    void makeFeedArray(JSONArray feeds) throws JSONException {
        arrayOfFeed = new ArrayList<FeedInfo>();
        for (int i = 0; i < feeds.length(); i++) {
            String retailerId = feeds.getJSONObject(i).getString("retailerId");
            String info1 = feeds.getJSONObject(i).getString("title");
            String info2 = feeds.getJSONObject(i).getString("dateValid");

            FeedInfo info = new FeedInfo(retailerId, info1, info2);
            arrayOfFeed.add(info);
        }
        feedsAdapter = new FeedsAdapter(this, arrayOfFeed);

        ListView listView = (ListView) findViewById(R.id.feedsList);
        listView.setAdapter(feedsAdapter);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
