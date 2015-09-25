package com.malltip.androidtest.model;

/**
 * Created by nerdynerd on 9/25/15.
 */
public class FeedInfo
{
    public String imageURL;
    public String title;
    public String dateValid;

    public FeedInfo(String imageURL, String title, String dateValid) {
        this.imageURL = imageURL;
        this.title = title;
        this.dateValid = dateValid;
    }
}
