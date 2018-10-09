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
    <h4>個人化電子報查詢</h4>
    <hr><br>
    <div id="search_bar"></div>
    <br><br>
    <h4 id="member_id"></h4>
    <br>
    <div id="panel"></div>
    <div class="row">
        <div id="item_id_0"></div>
        <div id="item_id_1"></div>
        <div id="item_id_2"></div>
        <div id="item_id_3"></div>
        <div id="item_id_4"></div>
        <div id="item_id_5"></div>
    </div>
    <br>
    <div class="row">
        <div id="item_id_6"></div>
        <div id="item_id_7"></div>
        <div id="item_id_8"></div>
        <div id="item_id_9"></div>
        <div id="item_id_10"></div>
        <div id="item_id_11"></div>
    </div>
    <br>
    <div class="row">
        <div id="item_id_12"></div>
        <div id="item_id_13"></div>
        <div id="item_id_14"></div>
        <div id="item_id_15"></div>
        <div id="item_id_16"></div>
        <div id="item_id_17"></div>
    </div>
    <br>
    <div class="row">
        <div id="item_id_18"></div>
        <div id="item_id_19"></div>
    </div>
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
    selectMemberIds();

    var memberId = "<%= params.get("member_id") %>";
    console.log(memberId);
    if(memberId=="null" || memberId=="")
        return;

    selectPrediction(memberId);
}

function selectMemberIds(){

    new Vue({
        el: '#search_bar',
        data: {
            keyword: "",
        },
        template: [
            '<input id="keyword_input" v-model="keyword" @keyup.enter="pressEnter" type="text" class="autocomplate form-control" placeholder="搜尋member id">'
        ].join(''),
        methods: {
            pressEnter(){
                try{
                    var keyword = $('#keyword_input').val();
                    var url = "<%= CONTEXT_PATH %>/<%= params.get("env") %>/pedm/"+keyword;
                    console.log(url);
                    window.location.href = url;
                }
                catch{
                    alert("member id錯誤");
                }
            }
        }
    });

    var url = "<%= CONTEXT_PATH %>/<%= params.get("env") %>/pedm/select_members";
    console.log(url);
    Vue.http.get(url).then((rsp)=>{ onSelectMemberIds(rsp['bodyText']);});
}

function onSelectMemberIds(e){
    var data = JSON.parse(e);
    var rows = data.map((r)=>{
        return {label: r, category: "" };
    });
    initAutocomplete(rows);
}

function selectPrediction(memberId){
    try{
        $("#member_id").html(memberId+" 的電子報");
        var url = "<%= CONTEXT_PATH %>/<%= params.get("env") %>/pedm/select_prediction/"+memberId;
        console.log(url);
        Vue.http.get(url).then((rsp)=>{ onSelectPrediction(rsp['bodyText']);});
    }
    catch{
        console.log("fuck");
    }
}

function onSelectPrediction(e){       
    var data = JSON.parse(e);
    console.log(data)
    new Vue({
        el: '#panel',
        data: {
            allData: data
        },
        methods: {
            bought: function(items){
                var joint = items.map((item)=>{
                    return '<a href="#">'+item.smName+'</a>';
                }).join(" ");
                return "因為您喜歡 "+joint+"<br>所以我想向您推薦";
            },
            picHost: function(url){
                return 'https://img.uitox.com'+url;
            }
        },
        template: [
            '<div>',
            '<template v-for="group in allData">',
                '<p v-html="bought(group.becauseOf)"></p>',
                '<div class="row">',
                    '<template v-for="item in group.predictions">',
                        '<div class="col-lg-2">',
                            '<div class="card">',
                                '<img class="card-img-top" :src="picHost(item.smPic)" v-bind:title="item.smName">',
                                '<div class="card-body">',
                                    '<h6>{{item.smName}}</h6>',
                                    '<p>{{item.cpName}}</p>',
                                    '<hr>',
                                    '<p style="font-size:8px;">你買過：{{item.from}}</p>',
                                    '<p style="font-size:8px;">{{item.smSeq}}</p>',
                                    '<p style="font-size:8px;">{{item.ref}}</p>',
                                '</div>',
                            '</div>',
                        '</div>',        
                    '</template>',    
                '</div>',
                '<br><br>',
            '</template>',
            '</div>',
        ].join(''),

    });
}            



// 啟動自動完成
function initAutocomplete(rows){
    $.widget( "custom.catcomplete", $.ui.autocomplete, {
        _create: function() {
            this._super();
            this.widget().menu( "option", "items", "> :not(.ui-autocomplete-category)" );
        },

        _renderMenu: function( ul, items ) {
            var that = this,
            currentCategory = "";
            $.each( items, function( index, item ) {
                // 只顯示20筆
                if(index>=20){
                    return;
                }
                
                var li;
                if ( item.category != currentCategory ) {
                    ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
                    currentCategory = item.category;
                }
                li = that._renderItemData( ul, item );
                if ( item.category ) {
                    li.attr( "aria-label", item.category + " : " + item.label );
                }
            });
        }
    }); 

    $('.autocomplate').catcomplete({
        delay: 0,
        source: rows
    });
}
</script>
</html>