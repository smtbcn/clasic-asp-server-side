<% 
' Veritabanı bağlantı bilgileri.
Dim host, dbuser, dbsifre, db
host = ""
dbuser = ""
dbsifre = ""
db = ""

' Veritabanı bağlantısı
Dim conn
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open "DRIVER={MySQL ODBC 3.51 Driver}; SERVER=" & host & "; UID=" & dbuser & "; pwd=" & dbsifre & "; db=" & db & "; option=16387;"

' Gelen isteği işle
Dim draw, start, length, searchValue, searchParams, columnIndex, columnDir, columnOrder
draw = CInt(Request.Form("draw"))
start = CInt(Request.Form("start"))
length = CInt(Request.Form("length"))
searchValue = Request.Form("search[value]")
searchParams = Array("musteri_adi", "urun_adi", "teslim_eden")
columnIndex = CInt(Request.Form("order[0][column]"))
columnDir = Request.Form("order[0][dir]")
columnOrder = Request.Form("columns[" & columnIndex & "][data]")

' Arama sorgusu
searchQuery = " WHERE teslimatdurumu=1 "
If Len(searchValue) > 0 Then
    searchQuery = " WHERE teslimatdurumu=1 AND ("
    For i = 0 To UBound(searchParams)
        searchQuery = searchQuery & searchParams(i) & " LIKE '%" & searchValue & "%'"
        If i < UBound(searchParams) Then
            searchQuery = searchQuery & " OR "
        End If
    Next
    searchQuery = searchQuery & ")"
End If

' Tablo adı
tableName = "content"

' SQL sorgusu için parametreler
Dim cmd, param1, param2, param3, param4
Set cmd = Server.CreateObject("ADODB.Command")
cmd.ActiveConnection = conn
cmd.CommandType = 1 ' adCmdText

' Parametreleri oluştur
Set param1 = cmd.CreateParameter("searchValue", 200, 1, 255, searchValue)
Set param2 = cmd.CreateParameter("columnIndex", 3, 1, , columnIndex)
Set param3 = cmd.CreateParameter("columnDir", 200, 1, 3, columnDir)
Set param4 = cmd.CreateParameter("columnOrder", 200, 1, 255, columnOrder)

' Parametreleri sorguya ekle
cmd.Parameters.Append param1
cmd.Parameters.Append param2
cmd.Parameters.Append param3
cmd.Parameters.Append param4

' SQL sorgusu
sql = "SELECT COUNT(*) FROM " & tableName & searchQuery
cmd.CommandText = sql
Set rs = cmd.Execute()

' Toplam kayıt sayısını kaydet
totalRecords = rs(0).Value

' Sıralama sorgusu
orderQueryvalue = "ORDER BY STR_TO_DATE(CONCAT(musteri_teslim_tarihi, ' ', musteri_teslim_tarihi), '%d.%m.%Y %H:%i:%s') DESC"

' Sayfalama sorgusu
pageQuery = " LIMIT " & length & " OFFSET " & start

' Ana SQL sorgusu
sql = "SELECT musteri_adi, urun_adi, mevcut_depo, teslim_deposu, urun_adet, teslim_tarih, teslimatdurumu, musteri_teslim_tarihi, teslim_eden, cikis_deposu FROM " & tableName & searchQuery & orderQueryvalue & pageQuery

' Veri alma
Set rs = conn.Execute(sql)

' Sonuçları JSON olarak oluştur
Dim jsonArray
Set jsonArray = Server.CreateObject("Scripting.Dictionary")

If Not rs.EOF Then
    Dim columnNames
    columnNames = Array("musteri_adi", "urun_adi", "urun_adet", "musteri_teslim_tarihi", "teslim_eden", "teslimatdurumu", "cikis_deposu", "teslim_deposu")

    Do Until rs.EOF
        Dim data
        ReDim data(UBound(columnNames))

        For i = 0 To UBound(columnNames)
            Dim columnName
            columnName = columnNames(i)

            ' POST verisinden ilgili sütun adına karşılık gelen veriyi al
            Dim columnValue
            columnValue = CStr(rs(columnName))

            ' MySQL sütun adıyla eşleşen değeri ata ve çift tırnak içine al
            data(i) = """" & columnName & """: """ & columnValue & """"

        Next

        jsonArray.Add jsonArray.Count, "{" & Join(data, ", ") & "}"
        rs.MoveNext
    Loop
End If

' JSON dönüşünü oluştur
Dim resultJson
Set resultJson = Server.CreateObject("Scripting.Dictionary")
resultJson.Add "data", "[" & Join(jsonArray.Items(), ", ") & "]"
resultJson.Add "draw", draw
resultJson.Add "recordsTotal", totalRecords
resultJson.Add "recordsFiltered", totalRecords

' JSON çıktısını oluştur
Dim jsonOutput
jsonOutput = ConvertToJsonString(resultJson)

Response.ContentType = "application/json"
Response.Write(jsonOutput)


' JSON dönüşü için yardımcı fonksiyon
Function ConvertToJsonString(obj)
    Dim json, key, value
    json = "{"
    For Each key In obj.Keys
        value = obj(key)
        If Len(json) > 1 Then
            json = json & ","
        End If
        json = json & """" & key & """:"
            json = json & value
    Next
    json = json & "}"
    ConvertToJsonString = json
End Function

%>