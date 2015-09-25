package com.malltip.androidtest.views;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.malltip.androidtest.R;
import com.malltip.androidtest.model.FeedInfo;
import com.squareup.picasso.Picasso;

import org.w3c.dom.Text;

import java.util.ArrayList;

/**
 * Created by nerdynerd on 9/25/15.
 */
public class FeedsAdapter extends ArrayAdapter<FeedInfo> {
    public FeedsAdapter(Context context, ArrayList<FeedInfo> feeds) {
        super(context, 0, feeds);
    }

    private static class Holder {
        public ImageView imageView;
        public TextView titleText;
        public TextView dateValidText;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Holder holder = null;
        FeedInfo feedInfo = getItem(position);
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.feed_item, parent, false);

            holder = new Holder();
            holder.imageView = (ImageView) convertView.findViewById(R.id.retailerLogoImageView);
            holder.titleText = (TextView) convertView.findViewById(R.id.titleTextView);
            holder.dateValidText = (TextView) convertView.findViewById(R.id.dateValidTextView);

            convertView.setTag(holder);
        } else
        {
            holder = (Holder)convertView.getTag();
        }

        holder.titleText.setText(feedInfo.title);
        holder.dateValidText.setText(feedInfo.dateValid);

        String imageURL = feedInfo.imageURL;
        Picasso.with(getContext()).load(imageURL).into(holder.imageView);

        return convertView;
    }
}