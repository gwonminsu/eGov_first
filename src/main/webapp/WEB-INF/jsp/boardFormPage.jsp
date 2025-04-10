<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>게시글 작성</title>
</head>
<body>
    <h2>게시글 작성</h2>
    <!-- form의 action을 BoardController의 insert 처리 경로로 설정 (예: insertBoard.do) -->
    <form action="insertBoard.do" method="post">  <!-- 수정된 부분: action URL 설정 -->
        제목: <input type="text" name="title" /> <br/>
        작성자: <input type="text" name="author" /> <br/>
        비밀번호: <input type="password" name="password" /> <br/>
        내용: <textarea name="content"></textarea> <br/>
        <input type="submit" value="등록하기" />
    </form>
</body>
</html>
