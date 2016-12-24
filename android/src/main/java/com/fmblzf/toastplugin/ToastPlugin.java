package com.fmblzf.toastplugin;

import android.content.Context;
import android.util.Log;
import android.view.Gravity;
import android.widget.Toast;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Created by fmblzf on 2016/12/24.
 */
public class ToastPlugin extends ReactContextBaseJavaModule {

    Context context;

    int DEFAULT_DISPLAY_DURATION = 2;

    public ToastPlugin(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext;
    }

    @Override
    public String getName() {
        return "ToastPlugin";
    }

    @ReactMethod
    public void show(ReadableMap args){
        JSONArray params = new JSONArray();
        try {
            params.put(ToastPluginConverter.reactToJSON(args));
            JSONObject object = params.getJSONObject(0);
            showToast(object);
        } catch (Exception e) {
            Log.e("ToastPlugin",e.getMessage());
        }

    }

    /**
     * 显示android toast
     * @param object
     */
    private void showToast(JSONObject object) throws Exception{
        String message = "";
        if (object.has("message")){
            message = object.getString("message");
        }
        if (message.isEmpty()){
            message = "";
        }
        int duration = DEFAULT_DISPLAY_DURATION;
        if(object.has("duration")){
            duration = object.getInt("duration");
        }
        if (duration>DEFAULT_DISPLAY_DURATION){
            duration = Toast.LENGTH_LONG;
        }else{
            duration = Toast.LENGTH_SHORT;
        }
        Toast toast = Toast.makeText(context,message,duration);
        String location = "";
        if (object.has("location")){
            location = object.getString("location");
        }
        if (location.isEmpty() || location.equalsIgnoreCase("bottom")){
            toast.setGravity(Gravity.BOTTOM,0,50);
        }else if (location.equalsIgnoreCase("center")){
            toast.setGravity(Gravity.CENTER,0,0);
        }else if (location.equalsIgnoreCase("top")){
            toast.setGravity(Gravity.TOP,0,50);
        }
        toast.show();
    }
}
