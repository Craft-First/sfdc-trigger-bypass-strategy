@IsTest
private class TriggerBypassStrategyTest {

    @isTest
    private static void shouldNotBeDisabledWithNoSetting() {
        final User runningUser = createUser('FirstName', 'LastName');
        Boolean isDisabled;
        System.runAs(runningUser) {
            isDisabled = new TriggerBypassStrategy().isDisabled();
        }

        System.assert(!isDisabled, 'Is Disabled should be false');
    }

    @IsTest
    private static void shouldNotBeDisabledWithSettingFalse() {
        final User runningUser = createUser('FirstName2', 'LastName2');
        final BypassTriggers__c setting = new BypassTriggers__c(
            SetupOwnerId = runningUser.Id,
            Bypass__c = false
        );

        insert setting;
        Boolean isDisabled;
        System.runAs(runningUser) {
            isDisabled = new TriggerBypassStrategy().isDisabled();
        }

        System.assert(!isDisabled, 'Is Disabled should be false');
    }

    @IsTest
    private static void shouldBeDisabledWithSettingTrue() {
        final User runningUser = createUser('FirstName2', 'LastName2');
        final BypassTriggers__c setting = new BypassTriggers__c(
            SetupOwnerId = runningUser.Id,
            Bypass__c = true
        );
        insert setting;
        Boolean isDisabled;
        System.runAs(runningUser) {
            isDisabled = new TriggerBypassStrategy().isDisabled();
        }

        System.assert(isDisabled, 'Is Disabled should be true');
    }

    private static User createUser(String fName, String lName) {
        @SuppressWarnings('sf:shortVariable')
        final User u = new User(
            LastName = lName,
            FirstName = fName,
            Email = 'testing@test.com',
            Alias = 'TestAl',
            Username = 'testing@test.com' + System.currentTimeMillis(),
            TimeZoneSidKey = 'Australia/Sydney',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_AU',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id
        );
        insert u;
        return u;
    }
}
