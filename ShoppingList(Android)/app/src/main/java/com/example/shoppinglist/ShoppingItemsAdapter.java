package com.example.shoppinglist;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;

public class ShoppingItemsAdapter extends RecyclerView.Adapter {

    public interface OnNoteListener{
        void onNoteClick(int position);
    }

    private ArrayList<ShoppingItem> itemsData;
    private Context context;
    public ShoppingItemsAdapter(ArrayList<ShoppingItem> items, Context context){
        itemsData = items;
        this.context = context;
    }
    public ArrayList<ShoppingItem> getItemsData(){
        return itemsData;
    }
    public class ItemViewHolder extends RecyclerView.ViewHolder{
        private TextView textDescription;
        private TextView itemName;
        private TextView cost;
        private CheckBox purchased;
        private ImageView imageCategory;
        private Button editBtn;
        private Button hideBtn;
        private Button deleteBtn;
        public ItemViewHolder(@NonNull View itemView) {
            super(itemView);
            textDescription = itemView.findViewById(R.id.textDescription);
            itemName = itemView.findViewById(R.id.textName);
            cost = itemView.findViewById(R.id.textPrice);
            purchased = itemView.findViewById(R.id.checkPurchase);
            imageCategory = itemView.findViewById(R.id.imageCategory);
            editBtn = itemView.findViewById(R.id.buttonItemEdit);
            hideBtn = itemView.findViewById(R.id.buttonhide);
            deleteBtn = itemView.findViewById(R.id.buttonDelete);
            itemView.setTag(this);
        }
        public TextView getTextDescription(){
            return textDescription;
        }
        public TextView getItemName(){
            return itemName;
        }
        public TextView getCost(){
            return cost;
        }
        public CheckBox getPurchased(){
            return purchased;
        }
        public ImageView getImageCategory(){return imageCategory;}
        public Button getEditButton(){return editBtn;}
        public Button getHideButton(){return hideBtn;}
        public Button getDeleteButton(){return deleteBtn;}
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.list_item, parent, false);
        return new ItemViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, final int position) {
        ItemViewHolder ivh = (ItemViewHolder) holder;
        ivh.getTextDescription().setText(itemsData.get(position).getDescription());
        ivh.getItemName().setText(itemsData.get(position).getName());
        ivh.getCost().setText("$"+itemsData.get(position).getCost());
        int purchased = itemsData.get(position).getPurchased();
        if(purchased==1){ivh.getPurchased().setChecked(true);}
        else {ivh.getPurchased().setChecked(false);}
        setImageSrc(ivh, itemsData.get(position).getCategory());
        final Button editBtn = ivh.getEditButton();
        editBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                editItem(position);
            }
        });
        CheckBox purchaseCheckBox = ivh.getPurchased();
        purchaseCheckBox.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                changePurchaseStatus(position);
            }
        });
        Button hideBtn = ivh.getHideButton();
        hideBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                hideDetail(position);
            }
        });
        int show = itemsData.get(position).getShow();
        if(ivh.getTextDescription().getText().toString().isEmpty()){ivh.getTextDescription().setVisibility(View.GONE);}
        else if(show == 1){
            ivh.getTextDescription().setVisibility(View.VISIBLE);
            hideBtn.setText("HIDE DETAILS");
        }
        else{
            ivh.getTextDescription().setVisibility(View.GONE);
            hideBtn.setText("SHOW DETAILS");
        }
        Button deleteBtn = ivh.getDeleteButton();
        deleteBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                deleteItem(position);
            }
        });
    }

    @Override
    public int getItemCount() {
        return itemsData.size();
    }

    public void setImageSrc(ItemViewHolder ivh, String category){
        ImageView imgview = ivh.getImageCategory();
        if(category.equalsIgnoreCase("FOOD")){
            imgview.setImageResource(R.drawable.food);
        }
        else if(category.equalsIgnoreCase("BOOK")){
            imgview.setImageResource(R.drawable.book);
        }
        else if(category.equalsIgnoreCase("ELECTRONIC")){
            imgview.setImageResource(R.drawable.electronic);
        }
        else if(category.equalsIgnoreCase("CLOTHING")){
            imgview.setImageResource(R.drawable.clothing);
        }
        else {
            imgview.setImageResource(R.drawable.sport);
        }
    }


    public void editItem(int position){
        FragmentManager fm = ((AppCompatActivity)context).getSupportFragmentManager();
        ListEditFragment frag = new ListEditFragment(context, itemsData.get(position));
        frag.show(fm, "editWindow");
    }

    public void changePurchaseStatus(int position){
        ShoppingItem item = itemsData.get(position);
        int checked = item.getPurchased();
        ShoppingListDataSource ds = new ShoppingListDataSource(context);
        String sortby = context.getSharedPreferences("MyShoppingListPreferences", Context.MODE_PRIVATE).getString("sortfield","name");
        if(sortby.equalsIgnoreCase("purchased")){
            int id = item.getItemId();
            ((MainActivity)context).purchaseClick(id);
        }
        else{
            int purchased;
            if(checked==0){
                purchased = 1;
            }
            else{
                purchased = 0;
            }
            item.setPurchased(purchased);
            ds.open();
            boolean sucess = ds.updateShopping(item);
            ds.close();
            if(sucess){
                itemsData.get(position).setPurchased(purchased);
                notifyDataSetChanged();
            }
            else{
                Toast.makeText(context, "update failed!", Toast.LENGTH_LONG).show();
            }
        }
    }

    public void hideDetail(int position){
        ShoppingItem item = itemsData.get(position);
        ShoppingListDataSource ds = new ShoppingListDataSource(context);
        try{
            int show = item.getShow();
            if (show == 1) {
                show = 0;
            } else {
                show = 1;
            }
            item.setShow(show);
            ds.open();
            boolean sucess = ds.updateShopping(item);
            ds.close();
            if(sucess){
                itemsData.get(position).setShow(show);
                notifyDataSetChanged();
            }else {
                Toast.makeText(context, "update failed!", Toast.LENGTH_LONG).show();
            }
        }catch (Exception e){}
    }

    public void deleteItem(int position){
        ShoppingItem item = itemsData.get(position);
        ShoppingListDataSource ds = new ShoppingListDataSource(context);
        try{
            ds.open();
            boolean sucess = ds.deleteShopping(item.getItemId());
            ds.close();
            if(sucess){
                itemsData.remove(position);
                notifyDataSetChanged();
            }else {
                Toast.makeText(context, "delete failed!", Toast.LENGTH_LONG).show();
            }
        }catch (Exception e){}
    }
}
