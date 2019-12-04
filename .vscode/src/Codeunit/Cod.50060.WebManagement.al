codeunit 50060 "Web Management"
{
    trigger OnRun()
    begin
        CreateXml2();
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
            ResponseTextL := HttpResponseL.ReasonPhrase();
        Message(ResponseTextL);
    end;

    procedure CreateXml1()
    var
        TempBlob: Record TempBlob;
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
        TempBlob.Blob.CreateOutStream(OutStr, TextEncoding::UTF8);
        XmlDocumentL.WriteTo(OutStr);
        TempBlob.Blob.CreateInStream(InStr, TextEncoding::UTF8);
        FileName := 'C:\ss.xml';
        File.DownloadFromStream(InStr, 'Export', '', '', FileName);
    end;
}

