codeunit 80001 groceryCodeunit
{

    procedure CallAPI(GStrore: record GroceryStore)
    var

        GClient: HttpClient;
        GResponse: HttpResponseMessage;
        Gcontent: HttpContent;
        GResult: text;

        JsonObject: JsonObject;
        JsonToken: JsonToken;
        Jsonarray: JsonArray;
        JsonToken1: JsonToken;
        JsonToken2: JsonToken;
        JsonToken3: JsonToken;
        JsonToken4: JsonToken;

    begin

        GClient.Get('http://simple-grocery-store-api.online/products', GResponse);

        if GResponse.IsSuccessStatusCode then begin
            Gcontent := GResponse.Content;
            Gcontent.ReadAs(GResult);
            // Message('%1', GResult);
        end;
        if Jsonarray.ReadFrom(GResult) then begin
            foreach JsonToken in Jsonarray do begin
                JsonObject := JsonToken.AsObject();
                if (JsonObject.Get('id', JsonToken1)) AND (JsonObject.Get('category', JsonToken2)) AND (JsonObject.Get('name', JsonToken3)) AND (JsonObject.Get('inStock', JsonToken4)) then begin
                    GStrore.Reset();
                    GStrore.Init();
                    GStrore.id := JsonToken1.AsValue().AsInteger();
                    GStrore.category := JsonToken2.AsValue().AsText();
                    GStrore.name := JsonToken3.AsValue().AsText();
                    GStrore.inStock := JsonToken4.AsValue().AsText();
                    GStrore.Insert();
                end;
            end;
        end;
        Dialog.Message('%1 \ %2 \ %3 \ %4', GStrore.id, GStrore.category, GStrore.name, GStrore.inStock);
    end;

    var
        myInt: Integer;
}