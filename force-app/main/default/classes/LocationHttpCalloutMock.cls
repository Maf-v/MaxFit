public class LocationHttpCalloutMock implements HttpCalloutMock {
    private String status;

    public LocationHttpCalloutMock(String setStatus) {
        this.status = setStatus;
    }

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(status == 'OK') {
            response.setBody('{"respuesta":"Respuesta exitosa"}');
            response.setStatusCode(200);
            response.setStatus('OK');
        } else if (status == 'Empty Body') {
            response.setBody('');
            response.setStatusCode(200);
            response.setStatus('OK');
        } else {
            response.setBody('{"respuesta":"Error"}');
            response.setStatusCode(400);
            response.setStatus('Bad Request');
        }
        return response;
    }
}