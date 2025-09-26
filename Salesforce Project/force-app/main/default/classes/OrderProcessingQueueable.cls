public class OrderProcessingQueueable implements Queueable, Database.AllowsCallouts {
    private Id orderId;

    public OrderProcessingQueueable(Id orderId) {
        this.orderId = orderId;
    }

    public void execute(QueueableContext qc) {
        // Load minimal order info (adjust fields to your org)
        Order ord = [SELECT Id, Total_Amount__c, AccountId FROM Order WHERE Id = :orderId LIMIT 1];

    // If you call external services here, you must keep an eye on callout timeouts and use Database.AllowsCallouts
    }
}