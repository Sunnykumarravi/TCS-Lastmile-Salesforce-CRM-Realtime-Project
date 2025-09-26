trigger OrderDiscountTrigger on Order (before insert) {
    for(Order o : Trigger.new){
        if(o.Order_Date__c <= Date.today() && o.Festival_Offer__c != null){
            o.Total_Amount__c = o.Total_Amount__c * 0.9; // 10% discount
        }
    }
}