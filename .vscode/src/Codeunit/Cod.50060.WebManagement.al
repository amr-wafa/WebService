codeunit 50060 "Web Management"
{
    trigger OnRun()
    begin

    end;

    procedure CreateStockSync()
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

