package com.example.shoppinglist;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.Spinner;
import androidx.fragment.app.DialogFragment;


public class ListEditFragment extends DialogFragment {
    private ShoppingItem currentItem;
    private Context context;
    private String[] categories = {"FOOD", "BOOK", "ELECTRONIC", "CLOTHING", "SPORT"};
    private ArrayAdapter<String> adapter;
    public ListEditFragment(Context contextConstruct){
        context = contextConstruct;
    }
    public ListEditFragment(Context contextConstruct, ShoppingItem item){
        context = contextConstruct;
        currentItem = item;
    }
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        final View view = inflater.inflate(R.layout.list_item_edit, container);
        initNameChangeEvent(view);
        initCostChangeEvent(view);
        initNameChangeEvent(view);
        initPurchaseChangeEvent(view);
        initDescriptionChangeEvent(view);
        initCategoryChangeEvent(view);
        Button savebtn = view.findViewById(R.id.buttonEditSave);
        savebtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                saveItem(currentItem);
            }
        });
        if(currentItem != null){
            renderExistItem(view, currentItem);
        }
        else{
            currentItem = new ShoppingItem();
        }
        return view;
    }

    private void initNameChangeEvent(View view){
        final EditText etName = view.findViewById(R.id.editItemName);
        etName.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                String name = etName.getText().toString();
                if(name.isEmpty()){name="My Shopping";}
                currentItem.setName(name);
            }
        });
    }
    private void initCostChangeEvent(View view){
        final EditText etCost = view.findViewById(R.id.editItemCost);
        etCost.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                int cost;
                String coststr = etCost.getText().toString();
                if(coststr.isEmpty()){cost = 0;}
                else{cost = Integer.parseInt(coststr);}
                currentItem.setCost(cost);
            }
        });
    }

    private void initDescriptionChangeEvent(View view){
        final EditText etDescription = view.findViewById(R.id.editItemDescription);
        etDescription.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                currentItem.setDescription(etDescription.getText().toString());
            }
        });
    }

    private void initPurchaseChangeEvent(View view){
        final CheckBox purchased = view.findViewById(R.id.checkEditPurchase);
        purchased.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked){
                    currentItem.setPurchased(1);
                }
                else{
                    currentItem.setPurchased(0);
                }
            }
        });
    }

    private void initCategoryChangeEvent(View view){
        final Spinner spinner = view.findViewById(R.id.spinnerCategory);
        adapter = new ArrayAdapter<String>(context, R.layout.support_simple_spinner_dropdown_item, categories);
        spinner.setAdapter(adapter);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String selectItem = parent.getItemAtPosition(position).toString();
                currentItem.setCategory(selectItem);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
    }

    private void renderExistItem(View view, ShoppingItem item){
        EditText etName = view.findViewById(R.id.editItemName);
        EditText etCost = view.findViewById(R.id.editItemCost);
        EditText etDescription = view.findViewById(R.id.editItemDescription);
        CheckBox purchasedBox = view.findViewById(R.id.checkEditPurchase);
        Spinner spinner = view.findViewById(R.id.spinnerCategory);
        etName.setText(item.getName());
        etCost.setText(Integer.toString(item.getCost()));
        etDescription.setText(item.getDescription());
        if(item.getPurchased()==1){purchasedBox.setChecked(true);}
        else{purchasedBox.setChecked(false);}
        int pos = adapter.getPosition(item.getCategory());
        spinner.setSelection(pos);
    }

    private void saveItem(ShoppingItem item){
        MainActivity main = (MainActivity) getActivity();
        main.saveItem(item);
        getDialog().dismiss();
    }

}
