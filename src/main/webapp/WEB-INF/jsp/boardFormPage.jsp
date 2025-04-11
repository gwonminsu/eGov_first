<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>
<head>
    <title>게시글 작성</title>
    <style>
      .error { color: red; }
      .errorSummary { border:1px solid red; padding:10px; margin-bottom:15px; }
    </style>
</head>
<body>
    <h2>게시글 작성</h2>

    <!-- 전역 에러(필드별 에러 외에 form 전체 에러가 있을 때) -->
    <c:if test="${not empty org.springframework.validation.BindingResult.board and org.springframework.validation.BindingResult.board.errorCount > 0}">
        <div class="errorSummary">
            <form:errors path="*" element="div"/>
        </div>
    </c:if>

    <!-- form의 action을 BoardController의 insert 처리 경로로 설정 -->
    <form:form action="insertBoard.do" modelAttribute="board" method="post">
        <form:hidden path="parentBoardIdx"/>
        <table>
            <tr>
                <th>제목</th>
                <td>
                    <form:input path="title" />
                    <form:errors path="title" cssClass="error" />
                </td>
            </tr>
            <tr>
                <th>작성자</th>
                <td>
                    <form:input path="author" />
                    <form:errors path="author" cssClass="error" />
                </td>
            </tr>
            <tr>
                <th>비밀번호</th>
                <td>
                    <form:password path="password" />
                    <form:errors path="password" cssClass="error" />
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <form:textarea path="content" rows="5" cols="50" />
                    <form:errors path="content" cssClass="error" />
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align:center;">
                    <input type="submit" value="등록하기" />
                    <input type="button" value="취소" onclick="location.href='boardList.do';" />
                </td>
            </tr>
        </table>
    </form:form>
</body>
</html>
