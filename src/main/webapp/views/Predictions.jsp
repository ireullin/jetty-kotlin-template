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
    <h1>預測結果</h1>
    <br><br>
    <div id="top_pagger"></div>
    <br><br>
    <div id="predicted_table"></div>
    <br><br>
    <div id="bottom_pagger"></div>
</div>
</body>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script language="javascript">
google.charts.load('current', {'packages':['table']});
google.charts.setOnLoadCallback(onGoogleChartReady);

var g_classifiedCategoies = classify();
var g_paggers = null;

function classify(){
    var obj = JSON.parse('["1189_★韓系品牌>MISSHA","253510_★香水香氛>香氛禮盒","1160_★MIT+口碑品牌> CITYCOLOR","250_★時尚彩妝>素顏霜｜氣墊粉餅｜粉底液","1184_★MIT+口碑品牌>lijay 琍睫","71021_★婦幼品牌>Natures Care 納維康","243_★時尚彩妝>粉撲 | 刷具 | 化妝棉","43377_★生活百貨>3C週邊小物","253450_★生活百貨>收納｜掛勾|衣架","56015_★專櫃品牌>BIOTHERM 碧兒泉","3952_★MIT+口碑品牌>BEVY C.","242_★時尚彩妝>彩妝輔助小物","244859_★健康保健>衛生棉|衛生紙|濕紙巾","5705_★韓系品牌>It\'s skin","1158_★韓系品牌>YET","1013_★婦幼品牌>VIGILL 婦潔","73395_★專櫃品牌>KIEHL\'S契爾氏","204074_★品牌旗艦>Wonjin Effct","240_★臉部保養>眼膜｜唇膜","236_★品牌旗艦>YOKO","248_★日系品牌>ROHTO肌研","245_★美體保養>身體去角質｜手足膜","8408_★臉部保養>洗面乳｜潔面皂","10514_★日系品牌>Bi Sachi 美肌幸","1938_★韓系品牌>CLIO 珂莉奧","17763_★熱搜品牌>innisfree","249_★時尚彩妝>防曬｜妝前隔離｜BB霜","36093_★MIT+口碑品牌>Schwarzkopf 施華蔻","56010_★專櫃品牌>CLINIQUE 倩碧","253468_★臉部保養>修容小物","253421_★流行配件>短襪|絲襪","1404_★造型美髮>染髮｜造型品","797_★生活百貨>★生活家電","251156_★健康保健>口腔護理","62170_★婦幼品牌>婦幼用品","1475_★MIT+口碑品牌>Sexylook","1961_★MIT+口碑品牌>babyou姊妹淘","1806_★日系品牌>SANA 莎娜","1011_★MIT+口碑品牌>LULUR 露露 ","91app","95166_★生活百貨>露營專區","1523_★MIT+口碑品牌>北緯23.5","1579_★臉部保養>乳液｜乳霜｜凝露","244860_★健康保健>成人用品","18360_★醫美品牌>NEO-TEC妮傲絲翠|UNITEC彤妍","1583_★美甲指彩>指甲貼紙 | 貼片","4532_★日系品牌>BN","1402_★美體保養>沐浴乳｜ 泡澡｜香皂","6624_★臉部保養>牙齒亮白｜美齒貼片 ","13403_★休閒零食>各國零食大集合","84720_★婦幼品牌>誰是寶貝","30337_★休閒零食>沖泡|飲品大集合","74260_★專櫃品牌>SHU UEMURA 植村秀","9842_★MIT+口碑品牌>+ONE% 歐恩伊","1893_★美體保養>體香｜止汗｜除毛","252_★時尚彩妝>睫毛膏｜睫毛夾｜眼影","43379_★生活百貨>創意辦公文具","28655_★品牌旗艦>INNER SKIN","90305_★熱搜品牌>LANEIGE 蘭芝","8863_★熱搜品牌>1028","1194_★韓系品牌>TONY MOLY","6627_★塑身美體>緊實按摩霜 | 美胸霜","15268_★品牌旗艦>HANAKA 花戀肌","251197_★臉部保養>超值套組｜旅行組","8414_★韓系品牌>BELLEME 百麗","1519_★臉部保養>化妝水｜噴霧","4552_★塑身美體>保健｜食品區","239_★臉部保養>面膜｜凍膜","1599_★MIT+口碑品牌>COSMOS","244858_★健康保健>口罩","253_★時尚彩妝>唇彩｜唇蜜｜護唇膏","1458_★造型美髮>髮梳｜電棒捲｜美髮器材","56008_★專櫃品牌>Elizabeth Arden","1010_★MIT+口碑品牌>美肌之誌","56009_★專櫃品牌>LOCCITANE 歐舒丹","246_★美體保養>身體乳｜按摩油","1476_★MIT+口碑品牌>UNT","1779_★韓系品牌>SCINIC","1554_★熱搜品牌>ETUDE HOUSE","253515_★香水香氛>薰香|蠟燭","1645_★日系品牌>Kanebo 佳麗寶","1322_★日系品牌>SONY CP ","58590_★品牌旗艦>SCENTIO","1159_★熱搜品牌>3CE(3CONCEPT EYES)","1196_★韓系品牌>LIOELE","28551_★休閒零食>各國泡麵大集合","2964_★韓系品牌>SECRET KEY","6628_★塑身美體>美身小物 | 輔助器材","5508_★塑身美體>塑身美胸衣｜提臀褲","231_★塑身美體>塑身衣褲｜機能褲襪","52866_★品牌旗艦>NARUKO 牛爾親研","247_★造型美髮>定型｜髮蠟｜蓬鬆水","244_★時尚彩妝>假睫毛︱雙眼皮貼","238_★臉部保養>去角質｜去粉刺｜抗痘","1166_★日系品牌>Candy Doll","1974_★韓系品牌>DERMAL","1195_★韓系品牌>L&P","235_★品牌旗艦>V.VIENNA 微微安娜","84014_★婦幼品牌>Naturaverde 自然之綠","1535_★韓系品牌>MIZON","244849_★香水香氛>香膏|香包","8379_★MIT+口碑品牌>My Scheming 我的心機","253453_★流行配件>泳衣|戲水裝備","253447_★生活百貨>收納｜外出提袋|旅行用品","1556_★婦幼品牌>TS6 護一生","16237_★美體保養>身體防曬｜身體噴霧","1162_★日系品牌>CEZANNE","5096_★品牌旗艦>CREMORLAB水麗妍","1071_★造型美髮>洗髮｜潤髮","18077_★時尚彩妝>腮紅｜修容｜提亮","1331_★日系品牌>BCL","1480_★熱搜品牌>KOSE 高絲","11636_★品牌旗艦>FEAZAC舒科","43382_★生活百貨>居家生活｜清潔","244857_★健康保健>痘痘貼|OK繃|腳跟足貼","1664_★美體保養>私密清潔保養","56012_★專櫃品牌>AVON 雅芳","253419_★流行配件>太陽眼鏡|眼鏡配件","244846_★香水香氛>名品香水","4010_★品牌旗艦>Crystal Dia","92440_★醫美品牌>Sebamed施巴","8407_★時尚彩妝>眉筆 ｜ 眉膠筆 ｜眉粉","1009_★MIT+口碑品牌>Kido 奇朵","180638_★品牌旗艦>Santa Marche","1403_★造型美髮>頭皮護理 | 增髮調理","1585_★臉部保養>精華液｜眼霜","1007_★MIT+口碑品牌>R.rouge 愛美肌","244848_★香水香氛>小香|噴霧","1478_★熱搜品牌>SHISEIDO 資生堂","3789_★品牌旗艦>Candy Love、Pury5","1477_★MIT+口碑品牌>LSY 林三益 刷具","253420_★流行配件>腰帶|腰封","14828_★生活百貨>居家生活｜小物","1928_★日系品牌>NARIS UP 娜麗絲","1164_★日系品牌>MAJORCA 戀愛魔鏡","15282_★MIT+口碑品牌>Glamour Sky 魔法天空","1584_★美甲指彩>美甲工具｜去光水","1161_★MIT+口碑品牌>SOLONE","1172_★熱搜品牌>花王","15563_★美體保養>休足︱舒緩貼布","251_★時尚彩妝>眼線液｜眼線膠|筆","56011_★專櫃品牌>Dior 迪奧","6432_★韓系品牌>VDL","253490_★時尚彩妝>彩妝收納","1321_★日系品牌>Mentholatum曼秀雷敦 ","1188_★韓系品牌> Peripera","244850_★香水香氛>空間芳香|衣物芳香|鞋蜜粉","1338_★臉部保養>卸妝油乳水｜眼唇卸妝","233_★品牌旗艦>Miss Hana花娜小姐","253422_★流行配件>零錢包|皮夾","1815_★MIT+口碑品牌>BONANZA 寶藝","1337_★韓系品牌>too cool for school","1006_★MIT+口碑品牌>EJG 伊澤靚","1008_★MIT+口碑品牌>Miss bowbow 撥撥小姐","1534_★日系品牌>D.U.P","1192_★韓系品牌>Holika Holika魔法公主","234_★品牌旗艦>Cle de CHARM","8380_★臉部保養>洗臉刷｜清潔工具 ","1582_★美甲指彩>指甲油","220078_★歐美品牌>L\'Oreal","1191_★韓系品牌>Nature Republic","30338_★休閒零食>各國糖果大集合","56013_★專櫃品牌>LANCOME 蘭蔻","253494_★時尚彩妝>定妝噴霧|蜜粉|蜜粉餅","1193_★韓系品牌>LJH 麗緻韓","15305_★美體保養>防蚊｜舒緩軟膏","4510_★韓系品牌>The Face Shop","1080_★造型美髮>髮膜｜免沖洗","11907_★韓系品牌>LadyKin","1780_★美體保養>護手足霜｜肘膝修護","1190_★韓系品牌>Sunwoo Cosme","253442_★生活百貨>雨傘|雨鞋|雨具","1918_★生活百貨>收納｜罝物盒|收納包","1163_★日系品牌>Kiss Me 奇士美","4529_★熱搜品牌>我的美麗日記","253418_★流行配件>髮飾|髮帶","253441_★生活百貨>居家生活｜餐具","25574_★MIT+口碑品牌>iFit推薦 微卡"]');
    var buff =[]
    for(var i=0; i<obj.length; i++){
        var c1 = obj[i].split(">");
        var c2 = c1[0].split("_");

        if(!c2[1]){
            buff.push({label:obj[i], category: ''});    
        }
        else if(!c1[1]){
            buff.push({label:obj[i], category: c2[1]});    
        }
        else if(!c1[2]){
            buff.push({label:obj[i], category: c2[1] + ">" + c1[1]});    
        }
        else{
            var bigCategory = c2[1] + ">" + c1[1]+ ">" + c1[2];
            buff.push({label:obj[i], category: bigCategory});
        }
    }

    return buff;
}

function onGoogleChartReady(){
    refreshPage(1);
}

function refreshPage(page){
    var url = "<%= CONTEXT_PATH %>/select_predictions/<%= params.get("id") %>/"+page;
    // console.log(url);
    Vue.http.get(url).then((rsp)=>{ onRecvData(rsp['bodyText']);});
}



function onRecvData(e){       
    // console.log(e);
    var data = JSON.parse(e);
    
    if(g_paggers==null){
        g_paggers =[
            newPagger('top_pagger',   data['body']['page'],data['body']['total_page']),
            newPagger('bottom_pagger',data['body']['page'],data['body']['total_page'])
        ];
    }
    
    
    var docs = data['body']['docs'];
    
    var dt = new google.visualization.DataTable();

    // add columns
    columns().forEach((c)=>{dt.addColumn(c['type'],  c['label'], c['id'] );});

    // add rows
    var docarr = docs.map((doc)=>genRow(doc));
    dt.addRows(docarr);

    
    var table = new google.visualization.Table(document.getElementById('predicted_table'));
    table.draw(dt, {showRowNumber: true, width: '100%', height: '100%', allowHtml: true});

    var optionsOfCoategoris = docs.map((doc)=>{newOptions(doc);});

    initAutocomplete();
}            


function newPagger(id, page, totalPage){
    return new Vue({
        el: '#'+id,

        data: {
            'page': page,
            'totalPage': totalPage
        },

        template: [
            '<div>',
            '<a href="#" v-show="page!=1" v-on:click.prevent="page-=1"><< 上一頁</a>&nbsp;&nbsp;',
            '<select v-model="page">',
                '<template v-for="i in (1, totalPage)">',
                    '<option :value="i" >{{i}}</option>',
                '</template>',
            '</select>',
            '&nbsp;&nbsp;<a href="#" v-show="page!=totalPage" v-on:click.prevent="page+=1">下一頁 >></a>',
            '</div>',
        ].join(''),

        watch: {
            page: function(v) { 
                refreshPage(v);
            }
        },
    });
}

function newOptions(doc){
    
    var top0 = '';
    if(doc['corrected_category']!=null && doc['corrected_category']!='')
        top0 = doc['corrected_category_no']+'_'+doc['corrected_category'];
    
    
    return new Vue({
        el: '#'+genDivId(doc['item_no']),

        data: {
            id: doc['id'],
            itno: doc['item_no'],
            answer: doc['answer'],
            'top0': top0, // 此項從tops獨立出來比較好處理
            tops: [
                '',
                doc['top1_category_no']+'_'+doc['top1_category'],
                doc['top2_category_no']+'_'+doc['top2_category'],
                doc['top3_category_no']+'_'+doc['top3_category'],
                doc['top4_category_no']+'_'+doc['top4_category'],
                doc['top5_category_no']+'_'+doc['top5_category'],
            ],
            modifiedAt: ['','','','','',''],
            selectdStyle: {
                'border': '1.5px solid DodgerBlue',
                'border-radius': '3px'
            },
            textSelectdStyle: {
                'border': '1.5px solid DodgerBlue'
            }
        },

        methods: {
            onClickCategory: function(i){
                this.answer = i;
                if(this.answer!=0){
                    updatePrediction(this);
                }
            },

            onPressEnter: function(){
                console.log(0, this.top0);
                updatePrediction(this);
            }
        },

        watch:{
            top0: function(){
                console.log("watch top0="+top0);
            }
        },

        template: [
            '<form>',
                '<template v-for="(t,i) in tops">',
                    '<div v-if="i>0"  class="form-group" v-on:click="onClickCategory(i)">',
                        '<input type="radio" :value="i" v-model="answer">',
                        '&nbsp;',
                        '<label :style="answer==i? selectdStyle : \'\'">{{t}}</label>',
                        '&nbsp;&nbsp;',
                        '<span style="color:#FF0000">{{modifiedAt[i]}}</span>',
                    '</div>',
                '</template>',
                '<div class="form-group" v-on:click="onClickCategory(0)">',
                    '<input type="radio" :value="0" v-model="answer">',
                    '&nbsp;',
                    '<input :style="answer==0? textSelectdStyle : \'\'"  type="text" placeholder="" v-model="top0" v-on:keyup.enter="onPressEnter">',
                    '<span>{{top0}}</span>',
                    '&nbsp;&nbsp;<span style="color:#FF0000">{{modifiedAt[0]}}</span>',
                '</div>',
            '</form>',
        ].join('')
    });
}

function updatePrediction(that){
    // console.log(that);
    var correctedCategory = "";
    var correctedCategoryNo = "";
    if(that.answer==0){
        var c = that.top0.split('_');
        correctedCategoryNo = c[0];
        correctedCategory = c[1];
        if(correctedCategory==null || correctedCategory=='')
            return;

        if(correctedCategoryNo==null || correctedCategoryNo=='')
            return;
    }
    
    var body = {
        prediction_id: that.id,
        answer: that.answer,
        corrected_category: correctedCategory,
        corrected_category_no: correctedCategoryNo
    };

    var url = "<%= CONTEXT_PATH %>/update_prediction";
    Vue.http.post(url, body).then(
        (rsp)=>{
            console.log(rsp['bodyText']);
            var svrRsp = JSON.parse(rsp['bodyText']);
            var c = svrRsp['header']['ended_at'].split(/[- :.]/);
            var msg = 'modified at '+c[3]+':'+c[4]+':'+c[5];
            that.$set(that.modifiedAt, that.answer, msg);
        }, 
        (rsp)=>{ 
            console.log(rsp);
        }
    );
}

function genRow(doc){
    var row = [
        doc['item_no'], 
        doc['item_name'],
        doc['original_category'],
        '<div id="'+genDivId(doc['item_no'])+'"></div>'
    ];

    return row;
}

function genDivId(itno){
    return 'div_'+itno;
}


function columns(){
    return [
        {type:'string', id:'item_no', label:'商品代號'},
        {type:'string', id:'item_name', label:'商品名稱'},
        {type:'string', id:'original_category', label:'原始分類'},
        {type:'string', id:'opt', label:'預測分類'},
        // {type:'string', id:'miscellaneous', label:'雜項'},
    ];
}


// 啟動自動完成
function initAutocomplete(){
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
        source: g_classifiedCategoies
    });
}
</script>
</html>