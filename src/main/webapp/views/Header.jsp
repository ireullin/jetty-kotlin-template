<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<br>
<h1><img src="<%= CONTEXT_PATH %>/assets/images/uitox_rd.png"></h1>
<h2>推薦系統後台</h2>
<br>
<br>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
   

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
        
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                個人化電子報
            </a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                <a class="dropdown-item" href="<%= CONTEXT_PATH %>/<%= params.get("env") %>/pedm">個人化電子報查詢</a>
                <a class="dropdown-item" href="<%= CONTEXT_PATH %>/<%= params.get("env") %>/pedm/training_histories">訓練紀錄</a>
                <a class="dropdown-item" href="<%= CONTEXT_PATH %>/<%= params.get("env") %>/pedm/import_histories">匯入紀錄</a>
            </div>
        </li>

        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                相關商品
            </a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                <a class="dropdown-item" href="<%= CONTEXT_PATH %>/<%= params.get("env") %>/related_items">相關商品查詢</a>
                <a class="dropdown-item" href="<%= CONTEXT_PATH %>/<%= params.get("env") %>/related_items/stories">訓練紀錄</a>
            </div>
        </li>

        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                個人化首頁
            </a>
            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                <a class="dropdown-item" href="<%= CONTEXT_PATH %>/<%= params.get("env") %>/prec">個人化首頁查詢</a>
                <a class="dropdown-item" href="<%= CONTEXT_PATH %>/<%= params.get("env") %>/prec/stories">訓練紀錄</a>
            </div>
        </li>
        
        </ul>
        
    </div>
</nav>