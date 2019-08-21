/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
*/
package org.apache.cordova.inappbrowser;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.webkit.GeolocationPermissions.Callback;
import android.webkit.JsPromptResult;
import android.webkit.PermissionRequest;
import android.webkit.WebChromeClient;
import android.webkit.WebStorage;
import android.webkit.WebView;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.LOG;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class InAppChromeClient extends WebChromeClient {

    private CordovaWebView webView;
    private Activity activity;
    private CordovaInterface cordova;
    private InAppBrowser inAppBrowser;
    private String LOG_TAG = "InAppChromeClient";
    private long MAX_QUOTA = 100 * 1024 * 1024;
    private PermissionRequest myRequest;
    private Callback mGeoLocationCallback;
    private String mGeoLocationRequestOrigin;
    private int CAMERA_REQUEST_CODE = 1235;
    private int LOCATION_REQUEST_CODE = 1236;

    public InAppChromeClient(CordovaWebView webView, Activity activity, CordovaInterface cordova, InAppBrowser inAppBrowser) {
        super();
        this.webView = webView;
        this.activity = activity;
        this.cordova = cordova;
        this.inAppBrowser = inAppBrowser;
    }
    /**
     * Handle database quota exceeded notification.
     *
     * @param url
     * @param databaseIdentifier
     * @param currentQuota
     * @param estimatedSize
     * @param totalUsedQuota
     * @param quotaUpdater
     */
    @Override
    public void onExceededDatabaseQuota(String url, String databaseIdentifier, long currentQuota, long estimatedSize,
            long totalUsedQuota, WebStorage.QuotaUpdater quotaUpdater)
    {
        LOG.d(LOG_TAG, "onExceededDatabaseQuota estimatedSize: %d  currentQuota: %d  totalUsedQuota: %d", estimatedSize, currentQuota, totalUsedQuota);
        quotaUpdater.updateQuota(MAX_QUOTA);
    }

    /**
     * Instructs the client to show a prompt to ask the user to set the Geolocation permission state for the specified origin.
     *
     * @param origin
     * @param callback
     */
    @Override
    public void onGeolocationPermissionsShowPrompt(String origin, Callback callback) {
        Log.d("PermissionsShowPrompt", "Invoked");
        mGeoLocationRequestOrigin = null;
        mGeoLocationCallback = null;
        askLocationPermission(LOCATION_REQUEST_CODE, origin, callback);
    }


    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onPermissionRequest(PermissionRequest request) {
        Log.d("onPermissionRequest", "Invoked");
        myRequest = request;
        String[] permissions = request.getResources();
        boolean found = false;
        for (int ind =0 ; ind < permissions.length ; ind++) {
            if (permissions[ind].equals(PermissionRequest.RESOURCE_VIDEO_CAPTURE)){
                askCameraPermission(CAMERA_REQUEST_CODE);
                found = true;
            }
        }

        if (!found) {
            myRequest.grant(request.getResources());
        }
    }


    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public final void askCameraPermission(int requestCode) {
        if (ContextCompat.checkSelfPermission(activity, "android.permission.CAMERA") != 0) {
            cordova.requestPermissions(inAppBrowser , requestCode, new String[]{"android.permission.CAMERA"});
        } else {
            activity.runOnUiThread((() -> {
                if (myRequest !=null)
                    myRequest.grant(myRequest.getResources());

            }));
        }

    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public final void askLocationPermission(int requestCode, final String origin, final Callback callback) {
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_FINE_LOCATION) != 0) {
            mGeoLocationRequestOrigin = origin;
            mGeoLocationCallback = callback;
            cordova.requestPermissions(inAppBrowser,requestCode, new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION});
        } else {
            activity.runOnUiThread((() -> {
                if (callback != null) {
                    callback.invoke(origin, true, true);
                }
            }));
        }

    }

    public void onRequestPermissionsResult(int requestCode, String[] permissions,  int[] grantResults) {
        if (requestCode == this.CAMERA_REQUEST_CODE) {
            this.resolveCameraRequest(grantResults);
        } else if (requestCode == this.LOCATION_REQUEST_CODE) {
            this.resolveLocationRequest(grantResults);
        }

    }

    private final void resolveLocationRequest(int[] grantResults) {
        if (grantResults.length > 0 && grantResults[0] == 0) {
            activity.runOnUiThread((() -> {
                if (mGeoLocationCallback != null) {
                    mGeoLocationCallback.invoke(mGeoLocationRequestOrigin, true, true);
                    inAppBrowser.inAppWebView.reload();
                }

            }));
        } else {
            if (mGeoLocationCallback != null) {
                mGeoLocationCallback.invoke(this.mGeoLocationRequestOrigin, false, false);
            }
        }

    }

    @TargetApi(21)
    private final void resolveCameraRequest(int[] grantResults) {
        Log.d("WebView", "PERMISSION FOR CAMERA");
        if (grantResults.length > 0 && grantResults[0] == 0) {
            activity.runOnUiThread((() -> {
                PermissionRequest var10000 = myRequest;
                if (myRequest != null) {
                    myRequest.grant(myRequest.getResources());
                }

            }));
        }
    }

    /**
     * Tell the client to display a prompt dialog to the user.
     * If the client returns true, WebView will assume that the client will
     * handle the prompt dialog and call the appropriate JsPromptResult method.
     *
     * The prompt bridge provided for the InAppBrowser is capable of executing any
     * oustanding callback belonging to the InAppBrowser plugin. Care has been
     * taken that other callbacks cannot be triggered, and that no other code
     * execution is possible.
     *
     * To trigger the bridge, the prompt default value should be of the form:
     *
     * gap-iab://<callbackId>
     *
     * where <callbackId> is the string id of the callback to trigger (something
     * like "InAppBrowser0123456789")
     *
     * If present, the prompt message is expected to be a JSON-encoded value to
     * pass to the callback. A JSON_EXCEPTION is returned if the JSON is invalid.
     *
     * @param view
     * @param url
     * @param message
     * @param defaultValue
     * @param result
     */
    @Override
    public boolean onJsPrompt(WebView view, String url, String message, String defaultValue, JsPromptResult result) {
        // See if the prompt string uses the 'gap-iab' protocol. If so, the remainder should be the id of a callback to execute.
        if (defaultValue != null && defaultValue.startsWith("gap")) {
            if(defaultValue.startsWith("gap-iab://")) {
                PluginResult scriptResult;
                String scriptCallbackId = defaultValue.substring(10);
                if (scriptCallbackId.startsWith("InAppBrowser")) {
                    if(message == null || message.length() == 0) {
                        scriptResult = new PluginResult(PluginResult.Status.OK, new JSONArray());
                    } else {
                        try {
                            scriptResult = new PluginResult(PluginResult.Status.OK, new JSONArray(message));
                        } catch(JSONException e) {
                            scriptResult = new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.getMessage());
                        }
                    }
                    this.webView.sendPluginResult(scriptResult, scriptCallbackId);
                    result.confirm("");
                    return true;
                }
            }
            else
            {
                // Anything else with a gap: prefix should get this message
                LOG.w(LOG_TAG, "InAppBrowser does not support Cordova API calls: " + url + " " + defaultValue); 
                result.cancel();
                return true;
            }
        }
        return false;
    }

}
