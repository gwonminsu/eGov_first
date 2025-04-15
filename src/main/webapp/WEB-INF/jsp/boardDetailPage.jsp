<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>게시글 상세</title>
    <style>
    </style>
    <!-- jquery 사용 -->
    <script src="<c:url value='/js/jquery-3.6.0.min.js'/>"></script>
</head>
<body>
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

    <h3>첨부파일</h3>
    <ul>
        <c:forEach var="f" items="${fileList}">
            <c:url var="downloadUrl" value="downloadFile.do">
                <c:param name="fileIdx" value="${f.idx}" />
            </c:url>
            <li>
                <a href="${downloadUrl}">${f.fileName}</a>
                (${f.fileSize} bytes)
            </li>
        </c:forEach>
    </ul>

    <!-- 버튼 그룹 -->
    <c:choose>
        <%-- level 0: 원글 → 목록 --%>
        <c:when test="${board.level == 0}">
            <%-- 기본 목록 URL --%>
            <c:url var="mainListUrl" value="/board/mainBoardList.do" />
            <%-- hidden input으로 검색 파라미터 유지 --%>
            <form action="${mainListUrl}" method="get" style="display:inline;">
                <c:if test="${not empty param.searchType}">
                    <input type="hidden" name="searchType" value="${param.searchType}" />
                </c:if>
                <c:if test="${not empty param.keyword}">
                    <input type="hidden" name="keyword" value="${param.keyword}" />
                </c:if>
                <button type="submit">목록</button>
            </form>
        </c:when>

        <%-- level 1 or 2: 답글/답글의답글 → 이전(부모 상세) --%>
        <c:otherwise>
            <c:url var="prevUrl" value="/board/selectBoard.do" />
            <form action="${prevUrl}" method="get" style="display:inline;">
                <input type="hidden" name="idx" value="${board.parentBoardIdx}" />
                <c:if test="${not empty param.searchType}">
                    <input type="hidden" name="searchType" value="${param.searchType}" />
                </c:if>
                <c:if test="${not empty param.keyword}">
                    <input type="hidden" name="keyword" value="${param.keyword}" />
                </c:if>
                <button type="submit">이전</button>
            </form>
        </c:otherwise>
    </c:choose>

    <form id="pwForm" method="post" style="display:inline;">
        <input type="hidden" name="idx" value="${board.idx}" />
        비밀번호: <input type="password" name="password" />

        <c:if test="${not empty param.searchType}">
            <input type="hidden" name="searchType" value="${param.searchType}" />
        </c:if>
        <c:if test="${not empty param.keyword}">
            <input type="hidden" name="keyword"    value="${param.keyword}"    />
        </c:if>

        <c:url var="editFormUrl" value="/board/boardForm.do" />
        <button type="submit" formaction="${editFormUrl}" formmethod="get">
          수정
        </button>
        <c:url var="deleteUrl" value="/board/deleteBoard.do"/>
        <button type="submit" formaction="${deleteUrl}" formmethod="post">
          삭제
        </button>
    </form>

    <c:choose>
        <%-- 원글 또는 첫 답글(level=1)일 때만 활성화 --%>
        <c:when test="${board.level < 2}">
            <c:url var="replyUrl" value="boardForm.do"/>
            <form action="${replyUrl}" method="get" style="display:inline;">
                <input type="hidden" name="parentBoardIdx" value="${board.idx}"/>
                <c:if test="${not empty param.searchType}">
                    <input type="hidden" name="searchType" value="${param.searchType}" />
                </c:if>
                <c:if test="${not empty param.keyword}">
                    <input type="hidden" name="keyword" value="${param.keyword}" />
                </c:if>
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
            <c:url var="replyUrl" value="selectBoard.do">
                <c:param name="idx" value="${reply.idx}" />
                <c:if test="${not empty param.searchType}">
                    <c:param name="searchType" value="${param.searchType}" />
                </c:if>
                <c:if test="${not empty param.keyword}">
                    <c:param name="keyword" value="${param.keyword}" />
                </c:if>
            </c:url>
            <li style="margin-left:${reply.level * 20}px;">
                <a href="${replyUrl}">${reply.title}</a>
                <small>by ${reply.author}</small>
            </li>
        </c:forEach>
    </ul>

    <script>
        $(function(){
            // 서버에서 모델에 담긴 errorMessage를 꺼내서 알림
            // c:out으로 XSS 공격 예방
            var errMsg = '<c:out value="${errorMessage}" default=""/>';
            if (errMsg) {
                alert(errMsg);
            }
        });
    </script>
</body>
</html>