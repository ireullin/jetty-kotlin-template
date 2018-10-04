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
    <h4>相關商品查詢</h4>
    <hr><br>
    <div id="search_bar"></div>
    <br><br>
    <div id="main_item"></div>
    <br><br>
    <div id="suggest_panel"></div>
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
    selectItems();

    var smSeq = "<%= params.get("sm_seq") %>";
    console.log(smSeq);
    if(smSeq=="null" || smSeq=="")
        return;

    selectSmSeq(smSeq);
}

function selectItems(){

    new Vue({
        el: '#search_bar',
        data: {
            keyword: "",
        },
        template: [
            '<input id="keyword_input" v-model="keyword" @keyup.enter="pressEnter" type="text" class="autocomplate form-control" placeholder="搜尋商品">'
        ].join(''),
        methods: {
            pressEnter(){
                try{
                    
                    var keyword = $('#keyword_input').val();
                    var smSeq = keyword.split(' ')[0];
                    var url = "<%= CONTEXT_PATH %>/<%= params.get("env") %>/related_items/"+smSeq;
                    console.log(url);
                    window.location.href = url;
                }
                catch{
                    alert("sm_seq錯誤");
                }
            }
        }
    });

    var url = "<%= CONTEXT_PATH %>/<%= params.get("env") %>/related_items/select_items";
    console.log(url);
    Vue.http.get(url).then((rsp)=>{ onSelectItems(rsp['bodyText']);});
}

function onSelectItems(e){
    var data = JSON.parse(e);
    var rows = data.map((r)=>{
        return {label: r.smSeq+" "+r.smName, category: r.cpName };
    });
    // console.log(rows);

    initAutocomplete(rows);
}

function selectSmSeq(smSeq){
    try{
        var url = "<%= CONTEXT_PATH %>/<%= params.get("env") %>/related_items/select_prediction/"+smSeq;
        console.log(url);
        Vue.http.get(url).then((rsp)=>{ onSelectSmSeq(rsp['bodyText']);});
    }
    catch{
        console.log("fuck");
    }
}

function onSelectSmSeq(e){       
    console.log(e);
    var data = JSON.parse(e);
    newPanel();
    var algs = ['av','lcs'];
    for(var i=0; i<algs.length; i++ ){
        var alg = algs[i];
        // newPanel(data['relatedItems'][alg]);
        for(var j=0; j<data['relatedItems'][alg].length; j++ ){
            if(j>=12)
                break

            var id = "item_id_"+i+"_"+j;
            newRelatedItem(id, data['relatedItems'][alg][j])
        }
    }
    
    newMainItem(data['mainItem'],data['createdAt'],data['trainingId']);
}            

function newPanel(){
    return new Vue({
        el: '#suggest_panel',
        data: {},
        computed: {},
        template: [
            '<div id="suggest_panel">',
                '<h4>其他人也看了</h4>',
                '<div class="row">',
                    '<template v-for="i in 12">',
                        '<div :id="\'item_id_0_\'+(i-1)"></div>',
                    '</template>',
                '</div>',
                '<br>',
                '<h4>我覺得你應該喜歡</h4>',
                '<div class="row">',
                    '<template v-for="i in 12">',
                        '<div :id="\'item_id_1_\'+(i-1)"></div>',
                    '</template>',
                '</div>',
            '</div>'
        ].join(''),

    });
}


function newMainItem(item, createdAt, trainingId){
    return new Vue({
        el: '#main_item',
        data: {
            smSeq: item['smSeq'],
            smName: item['smName'],
            smPic: 'https://img.uitox.com'+item['smPic'],
            cpName: item['cpName'],
            trainingId: trainingId,
            createdAt: createdAt,
        },
        template: [
            '<div class="row">',
                '<div class="col-lg-2">',
                    '<img class="card-img-top" :src="smPic">',
                '</div>',
                '<div class="col-lg-10">',
                    '<h4>{{cpName}}</h4>',
                    '<h5>{{smName}}</h5>',
                    '<br><p>{{smSeq}}</p>',
                    '<p>trainingId:{{trainingId}}</p>',
                    '<p>{{createdAt}}</p>',
                '</div>',
            '</div>'
        ].join(''),
    });
}

function newRelatedItem(id, item){
    console.log(id,item)
    return new Vue({
        el: '#'+id,

        data: {
            smSeq: item['smSeq'],
            smName: item['smName'],
            smPic: 'https://img.uitox.com'+item['smPic'],
            cpName: item['cpName'],
            ref: item['ref'],
            score: item['score']
        },

        computed: {
            shortName: function(){return this.smName.substr(0,15);},
            shortScore: function(){return (this.score+"").substr(0,6);}
        },

        template: [
            '<div class="col-lg-1">',
                '<div class="card">',
                    '<img class="card-img-top" :src="smPic" :title="smName">',
                    '<div class="card-body">',
                        '<p style="font-size:8px;">{{cpName}}',
                        '<br>{{shortName}}</p>',
                        '<p style="font-size:8px;">score:{{shortScore}}</p>',
                        '<p style="font-size:8px;">{{smSeq}}</p>',
                    '</div>',
                '</div>',
            '</div>'
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