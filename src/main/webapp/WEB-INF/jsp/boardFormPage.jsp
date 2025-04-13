<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>
<head>
    <title>
        <c:choose>
            <c:when test="${not empty board.idx}">게시글 수정</c:when>
            <c:otherwise>게시글 등록</c:otherwise>
        </c:choose>
    </title>
    <style>
      .error { color: red; }
      .errorSummary { border:1px solid red; padding:10px; margin-bottom:15px; }
    </style>
</head>
<body>
    <h2>
        <c:choose>
            <c:when test="${not empty board.idx}">게시글 수정</c:when>
            <c:otherwise>게시글 등록</c:otherwise>
        </c:choose>
    </h2>

    <!-- 전역 에러(필드별 에러 외에 form 전체 에러가 있을 때) -->
    <c:if test="${not empty org.springframework.validation.BindingResult.board and org.springframework.validation.BindingResult.board.errorCount > 0}">
        <div class="errorSummary">
            <form:errors path="*" element="div"/>
        </div>
    </c:if>

    <!-- form의 action을 BoardController의 insert 또는 update 처리 경로로 설정 -->
    <form:form action="${not empty board.idx ? 'updateBoard.do' : 'insertBoard.do'}" modelAttribute="board" method="post">
        <%-- 수정용 보드 폼을 위한 필드 --%>
        <c:if test="${not empty board.idx}">
            <form:hidden path="idx"/>
        </c:if>
        <%-- 부모게시글idx가 있을 때만 필드 출력(inset 시 공백문자 삽입 방지) --%>
        <c:if test="${not empty board.parentBoardIdx}">
            <form:hidden path="parentBoardIdx"/>
        </c:if>
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
                    <input type="submit" value="${not empty board.idx ? '수정하기' : '등록하기'}" />
                    <!-- parentBoardIdx 값에 따라 취소 시 이동 경로 결정 -->
                    <c:choose>
                      <c:when test="${not empty board.parentBoardIdx}">
                        <input type="button" value="취소"
                               onclick="location.href='selectBoard.do?idx=${board.parentBoardIdx}';" />
                      </c:when>
                      <c:otherwise>
                        <input type="button" value="취소"
                               onclick="location.href='mainBoardList.do';" />
                      </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>
    </form:form>
</body>
</html>
