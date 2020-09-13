package com.example.shoppinglist;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import java.util.ArrayList;

//DataSource setting is following the template in the textbook Chapter5

public class ShoppingListDataSource {
    private SQLiteDatabase database;
    private ShoppingListDBHelper dbHelper;

    public ShoppingListDataSource(Context context){
        dbHelper = new ShoppingListDBHelper(context);
    }
    public void open() throws SQLException {database = dbHelper.getWritableDatabase();}
    public void close(){dbHelper.close();}

    public boolean insertShopping(ShoppingItem item){
        boolean sucess = false;
        try{
            ContentValues initialValues = new ContentValues();
            initialValues.put("name", item.getName());
            initialValues.put("cost", item.getCost());
            initialValues.put("description", item.getDescription());
            initialValues.put("purchased", item.getPurchased());
            initialValues.put("category", item.getCategory());
            initialValues.put("showDescription", item.getShow());
            sucess = database.insert("shoppinglist", null, initialValues)>0;
        }catch (Exception e){}
        return  sucess;
    }

    public boolean updateShopping(ShoppingItem item){
        boolean sucess = false;
        try{
            ContentValues updateValues = new ContentValues();
            Long id = (long)item.getItemId();
            updateValues.put("name", item.getName());
            updateValues.put("cost", item.getCost());
            updateValues.put("description", item.getDescription());
            updateValues.put("purchased", item.getPurchased());
            updateValues.put("category", item.getCategory());
            updateValues.put("showDescription", item.getShow());
            sucess = database.update("shoppinglist", updateValues, "_id="+id, null)>0;
        }catch (Exception e){}
        return  sucess;
    }

    public boolean deleteShopping(int itemId){
        boolean delete = false;
        try {
            delete = database.delete("shoppinglist", "_id="+itemId,null)>0;
        }catch (Exception e){}
        return delete;
    }

    public ArrayList<ShoppingItem> getShoppingItems(){
        ArrayList<ShoppingItem> items = new ArrayList<ShoppingItem>();
        try{
            String query = "SELECT * FROM shoppinglist";
            Cursor cursor = database.rawQuery(query,null);
            ShoppingItem item;
            cursor.moveToFirst();
            while(!cursor.isAfterLast()){
                item = new ShoppingItem();
                item.setItemId(cursor.getInt(0));
                item.setName(cursor.getString(1));
                item.setCost(cursor.getInt(2));
                item.setDescription(cursor.getString(3));
                item.setPurchased(cursor.getInt(4));
                item.setCategory(cursor.getString(5));
                item.setShow(cursor.getInt(6));
                items.add(item);
                cursor.moveToNext();
            }
            cursor.close();
        }catch (Exception e){}
        return items;
    }

    public ArrayList<ShoppingItem> getShoppingItems(String sortBy, String sortOrder){
        ArrayList<ShoppingItem> items = new ArrayList<ShoppingItem>();
        try{
            String query = "SELECT * FROM shoppinglist ORDER BY " + sortBy + " " + sortOrder ;
            Cursor cursor = database.rawQuery(query,null);
            ShoppingItem item;
            cursor.moveToFirst();
            while(!cursor.isAfterLast()){
                item = new ShoppingItem();
                item.setItemId(cursor.getInt(0));
                item.setName(cursor.getString(1));
                item.setCost(cursor.getInt(2));
                item.setDescription(cursor.getString(3));
                item.setPurchased(cursor.getInt(4));
                item.setCategory(cursor.getString(5));
                item.setShow(cursor.getInt(6));
                items.add(item);
                cursor.moveToNext();
            }
            cursor.close();
        }catch (Exception e){}
        return items;
    }

    public ShoppingItem getSpecificItem(int itemId){
        ShoppingItem item = new ShoppingItem();
        String query ="SELECT * FROM shoppinglist WHERE _id=" + itemId;
        Cursor cursor = database.rawQuery(query, null);
        if(cursor.moveToFirst()){
            item.setItemId(cursor.getInt(0));
            item.setName(cursor.getString(1));
            item.setCost(cursor.getInt(2));
            item.setDescription(cursor.getString(3));
            item.setPurchased(cursor.getInt(4));
            item.setCategory(cursor.getString(5));
            item.setShow(cursor.getInt(6));
            cursor.close();
        }
        return item;
    }

    public int getLastContactID(){
        int lastId;
        try{
            String query = "Select MAX(_id) from shoppinglist";
            Cursor cursor = database.rawQuery(query, null);
            cursor.moveToFirst();
            lastId = cursor.getInt(0);
            cursor.close();
        }
        catch (Exception e){
            lastId = -1;
        }
        return lastId;
    }


}
