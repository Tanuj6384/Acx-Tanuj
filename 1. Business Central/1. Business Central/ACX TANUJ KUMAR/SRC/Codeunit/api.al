codeunit 50013 StoreAPIS
{
    trigger OnRun()
    begin
        ProductsAPI;
    end;
 
    procedure ProductsAPI()
    var
        JObjectArray: JsonArray;
        JObjectToken: JsonToken;
        JobjectChild: JsonObject;
        ResponseText: Text;
        recProduct: Record Products;
        JChildToken: JsonToken; 
    begin
        Clear(HttpClient1);
        Clear(HttpContent1);
        Clear(HttpHeaders1);
        Clear(HttpReqMessage);
        Clear(HttpResponse);

        //Setting Up The Request
        HttpReqMessage.SetRequestUri(StoreURL + '/products?results=2'); //We can use any 3 Query Params Like:
                                                                        //category,results,available
        HttpReqMessage.Method := 'GET';

        //Sending the Request and Processing the Response
        if HttpClient1.Send(HttpReqMessage, HttpResponse) then begin
            if HttpResponse.IsSuccessStatusCode then begin
                HttpResponse.Content.ReadAs(ResponseText);

                //Parsing The Json Response
                JObjectArray.ReadFrom(ResponseText);

                //Extracting list of products from the inventory.
                foreach JobjectToken in JObjectArray do begin
                    JobjectChild := JObjectToken.AsObject();

                    recProduct.Init();
                    if JobjectChild.Get('id', JChildToken) then 
                        if not JChildToken.AsValue().IsNull then begin
                            recProduct.ID := JChildToken.AsValue().AsInteger();
                        end;
                    if JobjectChild.Get('category', JChildToken) then
                        if not JChildToken.AsValue().IsNull then begin
                            recProduct.Category := JChildToken.AsValue().AsText();
                        end;

                    if JobjectChild.Get('name', JChildToken) then
                        if not JChildToken.AsValue().IsNull then begin
                            recProduct.Name := JChildToken.AsValue().AsText();
                        end;
                    if JobjectChild.Get('inStock', JChildToken) then
                        if not JChildToken.AsValue().IsNull then begin
                            recProduct.InStock := JChildToken.AsValue().AsBoolean();
                        end;
                    recProduct.Insert();
                end;
            end;
        end;
    end;

    var
        StoreURL: Label 'https://simple-grocery-store-api.glitch.me';
        HttpClient1: HttpClient;
        HttpContent1: HttpContent;
        HttpHeaders1: HttpHeaders;
        HttpReqMessage: HttpRequestMessage;
        HttpResponse: HttpResponseMessage;
}