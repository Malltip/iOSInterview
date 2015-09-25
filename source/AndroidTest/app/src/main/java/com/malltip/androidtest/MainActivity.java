package com.malltip.androidtest;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.malltip.androidtest.helper.APIHelper;
import com.malltip.androidtest.model.FeedInfo;
import com.malltip.androidtest.views.FeedsAdapter;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;


public class MainActivity extends AppCompatActivity {

    private JSONArray feedsArray;
    private ProgressDialog progressDialog;

    FeedsAdapter feedsAdapter;
    ArrayList<FeedInfo> feedsArrayList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
//        getWindow().addFlags(WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);
//        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setTitle("Malltip");
        getFeeds();
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

    void getFeeds() {
        AsyncTask<Void, Void, JSONObject> mSignUpTask = new AsyncTask<Void, Void, JSONObject>() {

            @Override
            protected void onPreExecute() {
                progressDialog = ProgressDialog.show(MainActivity.this, "Please wait...", "Fetching Feed data...", true);
            }

            @Override
            protected JSONObject doInBackground(Void... params) {
                JSONObject jsonObject = APIHelper.getFeeds();
                return jsonObject;
            }

            @Override
            protected void onPostExecute(JSONObject result) {
                try {
                    feedsArray = result.getJSONArray("feeds");
                    populateFeeds();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                progressDialog.dismiss();
            }
        };

        // execute AsyncTask
        mSignUpTask.execute(null, null, null);
    }

    void populateFeeds() throws JSONException {
        feedsArrayList = new ArrayList<FeedInfo>();

        for (int i = 0; i < feedsArray.length(); i++) {
            String retailerId = feedsArray.getJSONObject(i).getString("retailerId");
            String imageURL = String.format("https://d2yrj8lu79au2z.cloudfront.net/logos/%s.png", retailerId);
            String title = feedsArray.getJSONObject(i).getString("title");
            String dateValid = feedsArray.getJSONObject(i).getString("dateValid");

            FeedInfo info = new FeedInfo(imageURL, title, dateValid);
            feedsArrayList.add(info);
        }
        feedsAdapter = new FeedsAdapter(this, feedsArrayList);

        ListView listView = (ListView) findViewById(R.id.listView);
        listView.setAdapter(feedsAdapter);
    }
}
