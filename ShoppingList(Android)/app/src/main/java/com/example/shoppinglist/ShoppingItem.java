package com.example.shoppinglist;

public class ShoppingItem {
    private int itemId;
    private String name;
    private int cost;
    private String description;
    private String category;
    private int purchased;
    private int show;

    public ShoppingItem(){
        itemId = -1;
        show = 1;
        name = "My Shopping";
        cost = 0;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getPurchased() {
        return purchased;
    }

    public void setPurchased(int purchased) {
        this.purchased = purchased;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCost() {
        return cost;
    }

    public void setCost(int cost) {
        this.cost = cost;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getShow() {
        return show;
    }

    public void setShow(int show) {
        this.show = show;
    }
}
