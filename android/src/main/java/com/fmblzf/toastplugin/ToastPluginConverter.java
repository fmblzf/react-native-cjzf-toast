package com.fmblzf.toastplugin;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

/**
 * Created by fmblzf on 2016/12/24.
 */
public class ToastPluginConverter {

    /**
     * 将react-native传过来的对象转化成JSON对象
     * @param map
     * @return
     * @throws JSONException
     */
    static JSONObject reactToJSON(ReadableMap map) throws JSONException{
        JSONObject jsonObject = new JSONObject();
        ReadableMapKeySetIterator iterator = map.keySetIterator();
        while (iterator.hasNextKey()){
            String key = iterator.nextKey();
            ReadableType type = map.getType(key);
            switch (type){
                case Null:
                    jsonObject.put(key,JSONObject.NULL);
                    break;
                case Boolean:
                    jsonObject.put(key, map.getBoolean(key));
                    break;
                case Number:
                    jsonObject.put(key, map.getDouble(key));
                    break;
                case String:
                    jsonObject.put(key, map.getString(key));
                    break;
                case Map:
                    jsonObject.put(key, reactToJSON(map.getMap(key)));
                    break;
                case Array:
                    jsonObject.put(key, reactToJSON(map.getArray(key)));
                    break;

            }
        }
        return jsonObject;
    }

    /**
     * 将react native 传过来的数组转化成json数组
     * @param array
     * @return
     * @throws JSONException
     */
    static JSONArray reactToJSON(ReadableArray array)throws JSONException{

        JSONArray jsonArray = new JSONArray();
        for (int i = 0;i<array.size();i++){
            ReadableType type = array.getType(i);
            switch (type){
                case Null:
                    jsonArray.put(JSONObject.NULL);
                    break;
                case Boolean:
                    jsonArray.put(array.getBoolean(i));
                    break;
                case Number:
                    jsonArray.put(array.getDouble(i));
                    break;
                case String:
                    jsonArray.put(array.getString(i));
                    break;
                case Map:
                    jsonArray.put(reactToJSON(array.getMap(i)));
                    break;
                case Array:
                    jsonArray.put(reactToJSON(array.getArray(i)));
                    break;
            }
        }
        return jsonArray;
    }

    /**
     * 将本地JSON对象转化成React对象
     * @param jsonObject
     * @return
     * @throws JSONException
     */
    static WritableMap jsonToReact(JSONObject jsonObject)throws JSONException{
        WritableMap writableMap = Arguments.createMap();
        Iterator iterator = jsonObject.keys();
        while(iterator.hasNext()) {
            String key = (String) iterator.next();
            Object value = jsonObject.get(key);
            if (value instanceof Float || value instanceof Double) {
                writableMap.putDouble(key, jsonObject.getDouble(key));
            } else if (value instanceof Number) {
                writableMap.putDouble(key, jsonObject.getLong(key));
            } else if (value instanceof String) {
                writableMap.putString(key, jsonObject.getString(key));
            } else if (value instanceof JSONObject) {
                writableMap.putMap(key,jsonToReact(jsonObject.getJSONObject(key)));
            } else if (value instanceof JSONArray){
                writableMap.putArray(key, jsonToReact(jsonObject.getJSONArray(key)));
            } else if (value == JSONObject.NULL){
                writableMap.putNull(key);
            }
        }
        return writableMap;
    }

    /**
     * 将本地JSON数组转化成对应的React对象
     * @param jsonArray
     * @return
     * @throws JSONException
     */
    static WritableArray jsonToReact(JSONArray jsonArray) throws JSONException {
        WritableArray writableArray = Arguments.createArray();
        for(int i=0; i < jsonArray.length(); i++) {
            Object value = jsonArray.get(i);
            if (value instanceof Float || value instanceof Double) {
                writableArray.pushDouble(jsonArray.getDouble(i));
            } else if (value instanceof Number) {
                writableArray.pushDouble(jsonArray.getLong(i));
            } else if (value instanceof String) {
                writableArray.pushString(jsonArray.getString(i));
            } else if (value instanceof JSONObject) {
                writableArray.pushMap(jsonToReact(jsonArray.getJSONObject(i)));
            } else if (value instanceof JSONArray){
                writableArray.pushArray(jsonToReact(jsonArray.getJSONArray(i)));
            } else if (value == JSONObject.NULL){
                writableArray.pushNull();
            }
        }
        return writableArray;
    }
}
