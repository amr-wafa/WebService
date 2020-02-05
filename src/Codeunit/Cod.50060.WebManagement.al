codeunit 50060 "Web Management"
{
    trigger OnRun()
    begin

    end;

    procedure CreateItemCreationRequest()
    var
        EnvNameSpaceLbl: Label 'http://schemas.xmlsoap.org/soap/envelope/';
        BarcodeNameSpaceLbl: Label 'http://tempuri.org/';
    begin
        Clear(XmlTextG);
        WebServiceSetupG.Get();
        WebServiceSetupG.TestField("Farfetch Item Creation");
        WebServiceTemplateG.Get(WebServiceSetupG."Farfetch Item Creation");
        XmlDocumentG := XmlDocument.Create();
        XmlDomMgmtG.AddDeclaration(XmlDocumentG, '1.0', 'UTF-8', 'no');
        XmlDomMgmtG.AddRootElement(XmlDocumentG, 'Envelope', EnvNameSpaceLbl, EnvelopeXmlNodeG);
        XmlDomMgmtG.AddElement(EnvelopeXmlNodeG, 'Body', '', EnvNameSpaceLbl, EnvelopeXmlNodeG);
        XmlDomMgmtG.AddElement(EnvelopeXmlNodeG, 'BarcodeProcessAbsoluteQuantity', '', BarcodeNameSpaceLbl, EnvelopeXmlNodeG);
        XmlDomMgmtG.AddElement(EnvelopeXmlNodeG, 'Key', WebServiceTemplateG.Password, BarcodeNameSpaceLbl, TempXmlNodeG);
        XmlDomMgmtG.AddElement(EnvelopeXmlNodeG, 'Barcode', '263301701-OS', BarcodeNameSpaceLbl, TempXmlNodeG);
        XmlDomMgmtG.AddElement(EnvelopeXmlNodeG, 'absoluteQuantity', '10', BarcodeNameSpaceLbl, TempXmlNodeG);
        XmlDomMgmtG.AddElement(EnvelopeXmlNodeG, 'ErrMsg', '', BarcodeNameSpaceLbl, TempXmlNodeG);
        XmlDomMgmtG.AddElement(EnvelopeXmlNodeG, 'IsAdjustment', 'false', BarcodeNameSpaceLbl, TempXmlNodeG);
        XmlDomMgmtG.AddElement(EnvelopeXmlNodeG, 'currentStock', '1', BarcodeNameSpaceLbl, TempXmlNodeG);
        XmlDocumentG.WriteTo(XmlTextG);
        PostItemCreationRequest(TransactionLogG.InsertTransactionLog(DirectionG::"Outgoing Request", StatusG::Processed, WebServiceTemplateG."Template Code", 0, XmlTextG), XmlTextG, WebServiceTemplateG.Url, WebServiceTemplateG."Template Code");
    end;

    procedure PostItemCreationRequest(EntryNoP: BigInteger; XmlTextP: Text; UrlP: Text[250]; TemplateCodeP: Code[20])
    begin
        HttpClientG.Clear();
        HttpContentG.WriteFrom(XmlTextP);
        HttpContentG.GetHeaders(HttpHeaderG);
        HttpHeaderG.Remove('Content-Type');
        HttpHeaderG.Add('Content-Type', 'text/xml;charset=utf-8');
        HttpHeaderG.Add('SOAPAction', 'http://tempuri.org/BarcodeProcessAbsoluteQuantity');
        HttpClientG.SetBaseAddress(UrlP);
        //HttpClientG.Send()
        // if HttpClientG.Post(UrlP, HttpContentG, HttpResponseG) then begin
        //     HttpResponseG.Content().ReadAs(ResponseTextG);
        //     TransactionLogG.InsertTransactionLog(DirectionG::"Outgoing Request", StatusG::Processed, TemplateCodeP, 0, ResponseTextG);
        // end else begin
        //     ResponseTextG := HttpResponseG.ReasonPhrase();
        //     HttpResponseG.Content().
        //     ErrorLogG.InsertErrorlog(EntryNoP, ResponseTextG);
        // end
    end;

    procedure CreateXml2()
    var
        XmlDomMgmtL: Codeunit "XML DOM Mgt.";
        XmlDocumentL: XmlDocument;
        EnvelopeXmlNodeL: XmlNode;
        lTempXmlNode: XmlNode;
        EnvNameSpaceLbl: Label 'http://schemas.xmlsoap.org/soap/envelope/';
        BarcodeNameSpaceLbl: Label 'http://tempuri.org/';
        HttpClientL: HttpClient;
        HttpContentL: HttpContent;
        HttpHeaderL: HttpHeaders;
        XmlTextL: Text;
        HttpResponseL: HttpResponseMessage;
        ResponseTextL: Text;
    begin
        XmlDocumentL := XmlDocument.Create();
        XmlDomMgmtL.AddDeclaration(XmlDocumentL, '1.0', 'UTF-8', 'no');
        XmlDomMgmtL.AddRootElement(XmlDocumentL, 'Envelope', EnvNameSpaceLbl, EnvelopeXmlNodeL);
        XmlDomMgmtL.AddElement(EnvelopeXmlNodeL, 'Body', '', EnvNameSpaceLbl, EnvelopeXmlNodeL);
        XmlDomMgmtL.AddElement(EnvelopeXmlNodeL, 'BarcodeProcessAbsoluteQuantity', '', BarcodeNameSpaceLbl, EnvelopeXmlNodeL);
        XmlDomMgmtL.AddElement(EnvelopeXmlNodeL, 'Key', '2/XhsNe63kQ', BarcodeNameSpaceLbl, lTempXmlNode);
        XmlDomMgmtL.AddElement(EnvelopeXmlNodeL, 'Barcode', '263301701-OS', BarcodeNameSpaceLbl, lTempXmlNode);
        XmlDomMgmtL.AddElement(EnvelopeXmlNodeL, 'absoluteQuantity', '10', BarcodeNameSpaceLbl, lTempXmlNode);
        XmlDomMgmtL.AddElement(EnvelopeXmlNodeL, 'ErrMsg', '', BarcodeNameSpaceLbl, lTempXmlNode);
        XmlDomMgmtL.AddElement(EnvelopeXmlNodeL, 'IsAdjustment', 'false', BarcodeNameSpaceLbl, lTempXmlNode);
        XmlDomMgmtL.AddElement(EnvelopeXmlNodeL, 'currentStock', '1', BarcodeNameSpaceLbl, lTempXmlNode);
        XmlDocumentL.WriteTo(XmlTextL);
        HttpClientL.Clear();

        HttpContentL.WriteFrom(XmlTextL);
        HttpContentL.GetHeaders(HttpHeaderL);
        HttpHeaderL.Remove('Content-Type');
        HttpHeaderL.Add('Content-Type', 'text/xml;charset=utf-8');
        HttpHeaderL.Add('SOAPAction', 'http://tempuri.org/BarcodeProcessAbsoluteQuantity');
        HttpClientL.SetBaseAddress('https://rcs02-sales.fftech.info/pub/apistock.asmx');
        if HttpClientL.Post('https://rcs02-sales.fftech.info/pub/apistock.asmx', HttpContentL, HttpResponseL) then
            HttpResponseL.Content().ReadAs(ResponseTextL)
        else
            HttpResponseL.Content().ReadAs(ResponseTextL);
        Message(ResponseTextL);
    end;

    procedure CreateXml1()
    var
        TembBlobL: Codeunit "Temp Blob";
        XmlDocumentL: XmlDocument;
        XmlDeclarationL: XmlDeclaration;
        XmlElementL: XmlElement;
        XmlElement2L: XmlElement;
        OutStr: OutStream;
        InStr: InStream;
        FileName: Text;
    begin

        XmlDocumentL := XmlDocument.Create();
        XmlDeclarationL := XmlDeclaration.Create('1.0', 'UTF-8', 'no');
        XmlDocumentL.SetDeclaration(XmlDeclarationL);

        XmlElementL := XmlElement.Create('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/');

        //XmlElementL.SetAttribute('release', '2.1');
        XmlElement2L := XmlElement.Create('FirstName');
        XmlElement2L.Add(XmlText.Create('Selva'));
        XmlElementL.Add(XmlElement2L);

        XmlElement2L := XmlElement.Create('LastName');
        XmlElement2L.Add(XmlText.Create('T'));
        XmlElementL.Add(XmlElement2L);

        XmlDocumentL.Add(XmlElementL);
        TembBlobL.CreateOutStream(OutStr);
        XmlDocumentL.WriteTo(OutStr);
        TembBlobL.CreateInStream(InStr);
        FileName := 'C:\ss.xml';
        File.DownloadFromStream(InStr, 'Export', '', '', FileName);
    end;

    var
        WebServiceSetupG: Record "Web Service Setup";
        WebServiceTemplateG: Record "Web Service Template";
        TransactionLogG: Record "Web Service Transaction Log";
        ErrorLogG: Record "Web Service Error Log";
        XmlDomMgmtG: Codeunit "XML DOM Mgt.";
        EnvelopeXmlNodeG: XmlNode;
        XmlDocumentG: XmlDocument;
        TempXmlNodeG: XmlNode;
        XmlTextG: Text;
        DirectionG: Option "Incoming Request","Incoming Response","Outgoing Request","Outgoing Response";
        StatusG: Option "To be Processed",Failed,Processed,"Closed Manually","Skip Processing";
        HttpClientG: HttpClient;
        HttpContentG: HttpContent;
        HttpHeaderG: HttpHeaders;
        HttpResponseG: HttpResponseMessage;
        ResponseTextG: Text;

}

