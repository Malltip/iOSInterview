package com.franz.testproject.helper.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.franz.testproject.R;
import com.franz.testproject.model.FeedInfo;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

/**
 * Created by Franz on 10/7/2015.
 */
public class FeedsAdapter extends ArrayAdapter<FeedInfo> {


    public FeedsAdapter(Context context, ArrayList<FeedInfo> feeds) {
        super(context, 0, feeds);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        ImageView logoImageView = null;

        FeedInfo feedInfo = getItem(position);
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.cell_feed, parent, false);
            logoImageView = (ImageView) convertView.findViewById(R.id.logoImage);
            convertView.setTag(logoImageView);
        } else
        {
            logoImageView = (ImageView)convertView.getTag();
        }

        TextView feedInfoText1 = (TextView) convertView.findViewById(R.id.feedInfo1);
        feedInfoText1.setText(feedInfo.feedInfo1);
        TextView feedInfoText2 = (TextView) convertView.findViewById(R.id.feedInfo2);
        feedInfoText2.setText(feedInfo.feedInfo2);

        String logoImageURL = "https://d2yrj8lu79au2z.cloudfront.net/logos/" + feedInfo.retailerId + ".png";
        Picasso.with(getContext()).load(logoImageURL).into(logoImageView);

        return convertView;
    }
}
