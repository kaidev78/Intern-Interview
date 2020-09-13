package com.example.shoppinglist;

import androidx.appcompat.app.AppCompatActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;

public class ShoppingListSettingActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shopping_list_setting);
        initBackButton();
        initSettings();
        initSortByClick();
        initSortOrderClick();
    }

    public void initBackButton(){
        Button backbtn = findViewById(R.id.buttonBack);
        backbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ShoppingListSettingActivity.this, MainActivity.class);
                intent.setFlags((Intent.FLAG_ACTIVITY_CLEAR_TOP));
                startActivity(intent);
            }
        });
    }

    //following the template usage of SharedPreferences in Chapter5
    //Setting page is following the template in Chapter5 as well
    private  void initSettings(){
        String sortBy = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortfield","name");
        String sortOrder = getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortorder", "ASC");

        RadioButton rbName = findViewById(R.id.radioSortByName);
        RadioButton rbPrice = findViewById(R.id.radioSortByPrice);
        RadioButton rbPurchase = findViewById(R.id.radioSortByPurchase);

        if(sortBy.equalsIgnoreCase("name")){
            rbName.setChecked(true);
        }
        else if (sortBy.equalsIgnoreCase("cost")){
            rbPrice.setChecked(true);
        }
        else{
            rbPurchase.setChecked(true);
        }

        RadioButton rbAscending = findViewById(R.id.radioOrderByASC);
        RadioButton rbDescending = findViewById(R.id.radioOrderByDESC);
        if(sortOrder.equalsIgnoreCase("ASC")){
            rbAscending.setChecked(true);
        }
        else{
            rbDescending.setChecked(true);
        }
    }

    private void initSortByClick(){
        RadioGroup rgSortBy = findViewById(R.id.radioGroupSortBy);
        rgSortBy.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                RadioButton rbName = findViewById(R.id.radioSortByName);
                RadioButton rbCity = findViewById(R.id.radioSortByPrice);
                if(rbName.isChecked()){
                    getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).edit().putString("sortfield", "name").apply();
                }
                else if(rbCity.isChecked()){
                    getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).edit().putString("sortfield", "cost").apply();
                }
                else{
                    getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).edit().putString("sortfield", "purchased").apply();
                }
            }
        });
    }

    private void initSortOrderClick(){
        RadioGroup rgSortOrder = findViewById(R.id.radioGroupOrderBy);
        rgSortOrder.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                RadioButton rbAscending = findViewById(R.id.radioOrderByASC);
                if(rbAscending.isChecked()){
                    getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).edit().putString("sortorder", "ASC").apply();
                }
                else{
                    getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).edit().putString("sortorder", "DESC").apply();
                }
            }
        });
    }
}
