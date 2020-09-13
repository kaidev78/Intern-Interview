package com.example.shoppinglist;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;


import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {
    private ArrayList<ShoppingItem> items;
    private ShoppingItemsAdapter adapter;
    private RecyclerView rvShoppingList;
    private RecyclerView.LayoutManager layoutManager;

    //following the template usage of SharedPreferences in Chapter5

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initAddButton();
        initSettingButton();
        ShoppingListDataSource ds = new ShoppingListDataSource(this);
        try{
            ds.open();
            String sortby = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortfield","name");
            String sortorder = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortorder", "ASC");
            items = ds.getShoppingItems(sortby, sortorder);
            ds.close();
            rvShoppingList = findViewById(R.id.rvShoppingList);
            layoutManager = new LinearLayoutManager(this);
            adapter = new ShoppingItemsAdapter(items, MainActivity.this);
            rvShoppingList.setLayoutManager(layoutManager);
            rvShoppingList.setAdapter(adapter);
        }catch (Exception e){}
    }

    @Override
    public void onResume(){
        super.onResume();
        String sortby = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortfield","name");
        String sortorder = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortorder", "ASC");
        ShoppingListDataSource ds = new ShoppingListDataSource(this);
        try{
            ds.open();
            items = ds.getShoppingItems(sortby, sortorder);
            ds.close();
            rvShoppingList.setLayoutManager(layoutManager);
            adapter = new ShoppingItemsAdapter(items, this);
            rvShoppingList.setAdapter(adapter);
        }catch (Exception e){}
    }

    public void initAddButton(){
        FloatingActionButton add = findViewById(R.id.floatingActionButtonAdd);
        add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FragmentManager fm = getSupportFragmentManager();
                ListEditFragment edit = new ListEditFragment(MainActivity.this);
                edit.show(fm,"addtolist");
            }
        });
    }

    public void saveItem(ShoppingItem item){
        ShoppingListDataSource ds = new ShoppingListDataSource(MainActivity.this);
        try{
            ds.open();
            if(item.getItemId() == -1){
                ds.insertShopping(item);
                item.setItemId(ds.getLastContactID());
            }
            else{
                ds.updateShopping(item);
            }
            String sortby = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortfield","name");
            String sortorder = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortorder", "ASC");
            items = ds.getShoppingItems(sortby, sortorder);
            adapter = new ShoppingItemsAdapter(items, this);
            rvShoppingList.setAdapter(adapter);
            ds.close();
        }catch (Exception e){}
    }

    public void initSettingButton(){
        Button settingbtn = findViewById(R.id.buttonSetting);
        settingbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, ShoppingListSettingActivity.class);
                intent.setFlags((Intent.FLAG_ACTIVITY_CLEAR_TOP));
                startActivity(intent);
            }
        });
    }

    public void purchaseClick(int id){
        ShoppingListDataSource ds = new ShoppingListDataSource(MainActivity.this);
        try{
            ds.open();
            ShoppingItem item = ds.getSpecificItem(id);
            int checked = item.getPurchased();
            if(checked==0){item.setPurchased(1);}
            else{item.setPurchased(0);}
            ds.updateShopping(item);
            String sortby = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortfield","name");
            String sortorder = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortorder", "ASC");
            items = ds.getShoppingItems(sortby, sortorder);
            adapter = new ShoppingItemsAdapter(items, this);
            rvShoppingList.setAdapter(adapter);
            ds.close();
        }catch (Exception e){}
    }
}
