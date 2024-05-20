trigger PatchingFileVerification on ContentDocumentLink ( after insert, after update, after delete ) {

    List<ContentDocumentLink> cdls = ( Trigger.new == null ? Trigger.old : Trigger.new );

    Set<ID> parentIds = new Set<ID>();

    for (ContentDocumentLink cdl : cdls) {

        parentIds.add( cdl.LinkedEntityId );

    }

    for (List<Case> cases : [SELECT Id, (SELECT Id FROM ContentDocumentLinks LIMIT 1) 

                                  FROM Case WHERE Id IN :parentIds]) {

        for (Case c : cases) {

            if(c.Type_of_Support__c == 'Patching')
            {
            	c.isThereFiles__c = ( c.ContentDocumentLinks.size() > 0 );
            }
        }

        UPDATE cases;   

    }   

}