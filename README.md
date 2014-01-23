iOS Programming Task
================================

In order to be considered for the iOS position, you must complete the following steps.

*Note: This task should take no longer than 30 minutes to 1 hour at most.*

Prerequisites
=============

* Please note that this will require knowledge of objective C
* You will need to know how to consume a Restful API and how to implement Table Views
* You will need to have iOS SDK, XCode and a github account

Task
====

1. Fork this repository
2. Create a *source* folder to contain your code
3. In the *source* directory, please create an iOS app that accomplishes the following:
  * Connect to the Malltip feed API endpoint (see API section below for details) with mallId **4168** and offset **0**
  * Create a TableView that displays a list of feeds retrieved from feed API response
  * [Click here](https://github.com/Malltip/iOSInterview/blob/master/example.png) for a screenshot mockup of what the final product should look like. Note that the exact feeds you retrieve may differ from screenshot
4. Commit and Push your code to your new repository
5. Send us a pull request, we will review your code and get back to you

API Description
===============

The feed API request must be of the following form:

`https://m.malltip.com/api/v1/mall/[mallId]/feed/offset/[offset]`

This endpoint returns a *maximum* of 20 feeds that can be found in the specified mall.

**Required parameters**

* **[mallId]** - the id of the mall whose feed you want to retrieve
* **[offset]** - a feed id that determines where in the list to offset. If 0, the first 20 feeds are returned.


**JSON Output Format**

In this example, the feed API requests a json response for mallId **4170** and offset **0**

`https://m.malltip.com/api/v1/mall/4170/feed/offset/0`

The JSON returned by this request is shown below. Note that actual JSON may contain less whitespace.

```JSON
{
  "feeds":[{
      "feedId":12499,
      "retailerId":54520,
      "retailerName":"GameStop",
      "title":"Video Games Up to 50% Off!",
      "dateValid":"Limited Time Only",
      "EndDate":"0001-01-01T00:00:00Z",
      "hasLogo":true,
      "isInMall":true,
      "MallNameId":"",
      "approved":true,
      "isSaved":false,
      "isValid":true
    },
    {
      "feedId":12461,
      "retailerId":54995,
      "retailerName":"Justice",
      "title":"Girls Clothes 40% Off!",
      "dateValid":"Jan 21 - Feb 05",
      "EndDate":"0001-01-01T00:00:00Z",
      "hasLogo":true,"isInMall":true,
      "MallNameId":"",
      "approved":true,
      "isSaved":false,
      "isValid":true
    },
    ...],
  "offset":11652
}
```

Note that the JSON response contains two root elements:

* "feeds" contains an array of deals for the mall specified
* "offset" contains the feedId of the last feed in the feeds array 

**Retailer Logo** images can be obtained from 

`https://d2yrj8lu79au2z.cloudfront.net/logos/[retailerId].png`

where [retailerId] is the retailerId obtained from the feed API request.
