@IsTest
private class MicrosoftGraphServiceTest {
    @IsTest
    static void shouldGetGroupIdsWhenNoPaging() {
        //Arrange
        String body = '{"@odata.context":"https://graph.microsoft.com/v1.0/$metadata#directoryObjects(id)","value":[{"@odata.type":"#microsoft.graph.group","id":"1b961619-2a3c-45d6-8ca1-0ae12b3c935f"},{"@odata.type":"#microsoft.graph.group","id":"30b83849-8695-4de4-a69d-917cd41ce1c8"},{"@odata.type":"#microsoft.graph.group","id":"fb8ffc82-b404-4dd4-86d2-94c2a97ed229"}]}';
        SingleRequestMock httpMock = new SingleRequestMock(
            200,
            'Success',
            body,
            null
        );
        Test.setMock(HttpCalloutMock.class, httpMock);

        MicrosoftGraphService.MicrosoftGraphResponse result;
        MicrosoftGraphService service = new MicrosoftGraphService();

        //Act
        Test.startTest();
        result = service.getMyMemberGroups('token');
        Test.stopTest();

        //Assert
        Assert.areNotEqual(null, result);
        Assert.isTrue(result.success);
        Assert.isNull(result.nextlink);
        Assert.areEqual(3, result.groupIds.size());
        Assert.areEqual(
            '1b961619-2a3c-45d6-8ca1-0ae12b3c935f',
            result.groupIds[0]
        );
        Assert.isNull(result.errorMessage);
    }

    @IsTest
    static void shouldGetGroupIWhenPaging() {
        //Act
        String body = '{"@odata.context":"https://graph.microsoft.com/v1.0/$metadata#directoryObjects(id)","@odata.nextLink":"https://graph.microsoft.com/v1.0/me/memberOf?$top=3&$select=id&$securityEnabled=true&$skiptoken=RFNwdAoAAQAAAAAAAAAAFAAAAKzVZgBsfKpIsTt-ntTuOqcBAAAAAAAAAAAAAAAAAAAXMS4yLjg0MC4xMTM1NTYuMS40LjIzMzEGAAAAAAABYIllzAN7m0ClfcbIsfndBwENAQAAAQIAAAA","value":[{"@odata.type":"#microsoft.graph.group","id":"1b961619-2a3c-45d6-8ca1-0ae12b3c935f"},{"@odata.type":"#microsoft.graph.group","id":"30b83849-8695-4de4-a69d-917cd41ce1c8"},{"@odata.type":"#microsoft.graph.group","id":"fb8ffc82-b404-4dd4-86d2-94c2a97ed229"}]}';
        SingleRequestMock httpMock = new SingleRequestMock(
            200,
            'Success',
            body,
            null
        );
        Test.setMock(HttpCalloutMock.class, httpMock);

        MicrosoftGraphService.MicrosoftGraphResponse result;
        MicrosoftGraphService service = new MicrosoftGraphService();

        //Arrange
        Test.startTest();
        result = service.getMyMemberGroups('token');
        Test.stopTest();

        //Assert
        Assert.areNotEqual(null, result);
        Assert.isTrue(result.success);
        String expectedOdataNextlink = 'https://graph.microsoft.com/v1.0/me/memberOf?$top=3&$select=id&$securityEnabled=true&$skiptoken=RFNwdAoAAQAAAAAAAAAAFAAAAKzVZgBsfKpIsTt-ntTuOqcBAAAAAAAAAAAAAAAAAAAXMS4yLjg0MC4xMTM1NTYuMS40LjIzMzEGAAAAAAABYIllzAN7m0ClfcbIsfndBwENAQAAAQIAAAA';
        Assert.areEqual(expectedOdataNextlink, result.nextlink);
        Assert.areEqual(153, result.groupIds.size());
        Assert.isNull(result.errorMessage);
    }

    @IsTest
    static void shouldGetErrorWhen404() {
        //Arrange
        SingleRequestMock httpMock = new SingleRequestMock(
            404,
            'Not Found',
            '',
            null
        );
        Test.setMock(HttpCalloutMock.class, httpMock);

        MicrosoftGraphService.MicrosoftGraphResponse result;
        MicrosoftGraphService service = new MicrosoftGraphService();

        //Act
        Test.startTest();
        result = service.getMyMemberGroups('token');
        Test.stopTest();

        //Assert
        Assert.areEqual(false, result.success, 'Expected to get a failure');
        Assert.areEqual(0, result.groupIds.size());
        Assert.areEqual(
            true,
            String.isNotBlank(result.errorMessage),
            'Expected an error message to be set'
        );
    }

    @IsTest
    static void shouldGetErrorWhen500() {
        //Arrange
        SingleRequestMock httpMock = new SingleRequestMock(
            500,
            'Internal Server Error',
            '',
            null
        );
        Test.setMock(HttpCalloutMock.class, httpMock);

        MicrosoftGraphService.MicrosoftGraphResponse result;
        MicrosoftGraphService service = new MicrosoftGraphService();

        //Act
        Test.startTest();
        result = service.getMyMemberGroups('token');
        Test.stopTest();

        //Assert
        Assert.areEqual(false, result.success, 'Expected to get a failure');
        Assert.areEqual(0, result.groupIds.size());
        Assert.areEqual(
            true,
            String.isNotBlank(result.errorMessage),
            'Expected an error message to be set'
        );
    }
}
