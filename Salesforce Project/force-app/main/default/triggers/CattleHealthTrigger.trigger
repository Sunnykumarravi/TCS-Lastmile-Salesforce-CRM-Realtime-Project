trigger CattleHealthTrigger on Cattle__c (after update) {
    List<Task> tasksToCreate = new List<Task>();
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    for(Cattle__c c : Trigger.new) {
        Cattle__c oldC = Trigger.oldMap.get(c.Id);
        if(c.Health_Status__c == 'Critical' && oldC.Health_Status__c != 'Critical'){
            // Create Vet Task
            Task t = new Task(
                WhatId = c.Id,
                OwnerId = [SELECT Id FROM User WHERE Profile.Name='Farm Manager' LIMIT 1].Id,
                Subject = 'Vet Check Required',
                Priority = 'High',
                Status = 'Not Started'
            );
            tasksToCreate.add(t);

            // Send Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {'farmmanager@example.com'});
            mail.setSubject('Critical Health Alert for ' + c.Name);
            mail.setPlainTextBody('Cattle ' + c.Name + ' is in critical health. Please check immediately.');
            emails.add(mail);
        }
    }

    if(!tasksToCreate.isEmpty()) insert tasksToCreate;
    if(!emails.isEmpty()) Messaging.sendEmail(emails);
}