public with sharing class MilkProductionSummary {
    public static void updateFarmerMilkTotals(Set<Id> farmerIds) {
        // Map to store totals per farmer
        Map<Id, Decimal> farmerMilkMap = new Map<Id, Decimal>();

        // Query milk production records
        for (Milk_Production__c mp : [
            SELECT Farmer__c, Quantity__c 
            FROM Milk_Production__c 
            WHERE Farmer__c IN :farmerIds
        ]) {
            if (mp.Farmer__c == null || mp.Quantity__c == null) continue;
            farmerMilkMap.put(
                mp.Farmer__c,
                (farmerMilkMap.containsKey(mp.Farmer__c) ? farmerMilkMap.get(mp.Farmer__c) : 0) + mp.Quantity__c
            );
        }

        // Prepare Farmer updates
        List<Farmer__c> farmsToUpdate = new List<Farmer__c>();
        for (Id farmId : farmerMilkMap.keySet()) {
            farmsToUpdate.add(new Farmer__c(
                Id = farmId,
                Total_Milk__c = farmerMilkMap.get(farmId) // <-- replace with your actual field
            ));
        }

        if (!farmsToUpdate.isEmpty()) {
            update farmsToUpdate;
        }
    }
}