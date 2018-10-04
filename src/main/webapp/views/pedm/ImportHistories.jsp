<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map" %>
<%  final Map<String,String> params = (Map<String,String>)request.getAttribute("params"); %>
<%  final String CONTEXT_PATH = params.get("__path__"); %>

<!doctype html>
<html>
<head>
    <title>RelatedItems</title>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

    <style>
        .ui-autocomplete-category {
            font-weight: bold;
            padding: .2em .4em;
            margin: .8em 0 .2em;
            line-height: 1.5;
        }
    </style>

    <!-- bootstrap css -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
    
    <!-- bootstrap js -->
    <script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js" integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T" crossorigin="anonymous"></script>
    

    
    <!-- <script src="https://code.jquery.com/jquery-1.12.1.js"></script>-->
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <!-- vue js -->
    <script src="https://cdn.jsdelivr.net/npm/vue@2.5.16/dist/vue.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/vue-resource/1.5.1/vue-resource.js"></script>

</head>
<body>
<div class="container-fluid">    
    <%@ include file="/views/Header.jsp" %>  
    <br><br>
    <h4>交易資料匯入紀錄</h4>
    <hr><br>
    <div id="histories_table"></div>
    <br><br>
</div>
<br>
<br>
</body>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script language="javascript">
google.charts.load('current', {'packages':['table']});
google.charts.setOnLoadCallback(onGoogleChartReady);

function onGoogleChartReady(){
    var obj = JSON.parse('<%= params.get("histories") %>');

    var columns =[
        {type:'string', id:'id', label:'id'},
        {type:'string', id:'solr_updated_at', label:'solr updated at'},
        {type:'string', id:'solr_count', label:'solr count'},
        {type:'string', id:'raw_count', label:'raw count'},
        {type:'string', id:'transaction_count', label:'transaction count'},
        {type:'string', id:'created_at', label:'created at'},
    ];

    var data = obj.map((row)=>{
        return columns.map((c)=>{
            return row[c['id']]==null? "":row[c['id']]; 
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