package com.example.shoppinglist;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

//DBHelper setting is following the template in the textbook Chapter5

public class ShoppingListDBHelper extends SQLiteOpenHelper {
    private static final String DATABASE_NAME = "shoppinglist.db";
    private static final int DATABASE_VERSION = 1;
    private static final String CREATE_TABLE_SHOPPING_LIST = "create table shoppinglist(_id integer primary key autoincrement," +
            "name text not null, cost integer not null, description text, purchased integer not null, category text not null, showDescription integer not null);";

    public ShoppingListDBHelper(Context context){
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(CREATE_TABLE_SHOPPING_LIST);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }
}
