@isTest
private class MilkProductionBatchTest {
    @isTest static void testMilkBatch() {
        // Step 1: Create test cattle
        List<Cattle__c> cattleList = new List<Cattle__c>();
        cattleList.add(new Cattle__c(Name='Cow A', Milk_Quantity__c=1));  // Low
        cattleList.add(new Cattle__c(Name='Cow B', Milk_Quantity__c=9));  // High
        insert cattleList;

        // Step 2: Run batch
        Test.startTest();
        Database.executeBatch(new MilkProductionBatch(), 2);
        Test.stopTest();

        // Step 3: Query updated cattle
        Map<String, Cattle__c> cows = new Map<String, Cattle__c>(
            [SELECT Name, Milk_Quantity__c, Health_Status__c FROM Cattle__c WHERE Name IN ('Cow A','Cow B')]
        );

        // Step 4: Assert based on logic
        System.assertEquals('Needs Attention', cows.get('Cow A').Health_Status__c, 'Cow A should be flagged');
        System.assertEquals('Healthy', cows.get('Cow B').Health_Status__c, 'Cow B should be marked Healthy');
    }
}