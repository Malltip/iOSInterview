package com.franz.testproject.model;

/**
 * Created by Franz on 10/7/2015.
 */
public class FeedInfo {
    public String retailerId;
    public String feedInfo1, feedInfo2;

    public FeedInfo() { retailerId = feedInfo1 = feedInfo2 = ""; }
    public FeedInfo(String id, String info1, String info2)
    {
        this.retailerId = id;
        this.feedInfo1 = info1;
        this.feedInfo2 = info2;
    }
}
