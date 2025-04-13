<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>게시글 상세</title>
    <style>
        .errorSummary { border:1px solid red; padding:10px; margin-bottom:15px; color: red; }
        .updatedMessage { color: gray; font-size: 0.8em; }
    </style>
</head>
<body>
    <!-- 에러 메시지 -->
    <c:if test="${not empty errorMessage}">
        <div class="errorSummary">${errorMessage}</div>
    </c:if>

    <c:choose>
        <%-- level 0: 원글 --%>
        <c:when test="${board.level == 0}">
            <h2>${board.title}</h2>
        </c:when>
        <%-- level 1 or 2: 답글/답글의답글 --%>
        <c:otherwise>
            <h3>[${parentBoard.title}]의 답글</h3>
            <h2>${board.title}</h2>
        </c:otherwise>
    </c:choose>
    <!-- 수정일이 작성일과 다를 때만 표시 -->
    <c:if test="${board.updatedAt.time ne board.createdAt.time}">
      <span class="updatedMessage">
        ( ${board.updatedAt} 에 수정됨 )
      </span>
    </c:if>
    <div>작성자: ${board.author} | 등록일: ${board.createdAt} | 조회수: ${board.hit}</div>
    <hr/>
    <div>${board.content}</div>
    <hr/>

  <!-- 버튼 그룹 -->
  <c:choose>
    <%-- level 0: 원글 → 목록 --%>
    <c:when test="${board.level == 0}">
      <form action="mainBoardList.do" method="get" style="display:inline;">
        <button type="submit">목록</button>
      </form>
    </c:when>
    <%-- level 1 or 2: 답글/답글의답글 → 이전(부모 상세) --%>
    <c:otherwise>
      <form action="selectBoard.do" method="get" style="display:inline;">
        <input type="hidden" name="idx" value="${board.parentBoardIdx}" />
        <button type="submit">이전</button>
      </form>
    </c:otherwise>
  </c:choose>

  <form id="pwForm" method="post" style="display:inline;">
    <input type="hidden" name="idx" value="${board.idx}" />
    비밀번호: <input type="password" name="password" />

    <button type="submit" formaction="boardForm.do" formmethod="get">
      수정
    </button>
    <button type="submit" formaction="deleteBoard.do" formmethod="post">
      삭제
    </button>
  </form>

  <c:choose>
      <%-- 원글 또는 첫 답글(level=1)일 때만 활성화 --%>
      <c:when test="${board.level < 2}">
        <form action="boardForm.do" method="get" style="display:inline;">
          <input type="hidden" name="parentBoardIdx" value="${board.idx}"/>
          <button type="submit">답변등록</button>
        </form>
        <h3>답글 목록</h3>
      </c:when>
      <%-- 답글의 답글(level>=2)일 때는 비활성화 --%>
      <c:otherwise>
        <button type="button" disabled style="display:inline;" title="더 이상 답변을 달 수 없습니다">
          답변등록
        </button>
      </c:otherwise>
    </c:choose>

  <ul>
    <c:forEach var="reply" items="${replyList}">
      <li style="margin-left:${reply.level * 20}px;">
        <a href="selectBoard.do?idx=${reply.idx}">${reply.title}</a>
        <small>by ${reply.author}</small>
      </li>
    </c:forEach>
  </ul>
</body>
</html>