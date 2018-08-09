<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map" %>
<%  final Map<String,String> params = (Map<String,String>)request.getAttribute("params"); %>
<%  final String CONTEXT_PATH = params.get("__path__"); %>

<!doctype html>
<html>
<head>
    <title>Analysis</title>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- bootstrap css -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
    
    <!-- bootstrap js -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>

    <!-- vue js -->
    <script src="https://cdn.jsdelivr.net/npm/vue@2.5.16/dist/vue.js"></script>

</head>
<body>
<div class="container-fluid">    
    <%@ include file="/views/Header.jsp" %>  
    <br><br>
    <h1>預測紀錄</h1>
    <br><br>
    <div id="histories_table"></div>
</div>
</body>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script language="javascript">
google.charts.load('current', {'packages':['table']});
google.charts.setOnLoadCallback(onGoogleChartReady);

function onGoogleChartReady(){
    var obj = JSON.parse('<%= params.get("entries") %>');

    var columns =[
        {type:'number', id:'id', label:'流水號'},
        {type:'string', id:'edit', label:''},
        {type:'string', id:'download', label:''},
        {type:'string', id:'file_name', label:'檔案名稱'},
        {type:'string', id:'platform', label:'平台'},
        {type:'string', id:'row_count', label:'資料筆數'},
        {type:'string', id:'began_at', label:'開始時間'},
        {type:'string', id:'finished_at', label:'結束時間'},
    ];

    var data = obj.map((row)=>{
        return columns.map((c)=>{
            if(c['id']=='id'){
                return parseInt(row[c['id']]);
            }
            else if(c['id']=='edit'){
                return '<a target="_blank" href="<%= CONTEXT_PATH %>/show_predictions/'+row['id']+'">編輯</a>';
            }
            else if(c['id']=='download'){
                return '<a target="_blank" href="<%= CONTEXT_PATH %>/download_excel/'+row['id']+'">下載</a>';
            }
            else{ 
                return row[c['id']]==null? "":row[c['id']]; 
            }
        });
    });

    console.log(data);

    var dt = new google.visualization.DataTable();
    columns.forEach((c)=>{dt.addColumn(c['type'],  c['label'], c['id'] );});
    dt.addRows(data);

    
    var table = new google.visualization.Table(document.getElementById('histories_table'));
    table.draw(dt, {showRowNumber: true, width: '100%', height: '100%', allowHtml: true});

}

</script>
</html>