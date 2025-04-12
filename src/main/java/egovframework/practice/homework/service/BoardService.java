package egovframework.practice.homework.service;

import java.util.List;

public interface BoardService {

    // 무지성 게시글 목록 조회
    List<BoardVO> getBoardList() throws Exception;

    // 전체 게시글 개수 조회
    int getBoardCount() throws Exception;

    // 원글 목록 조회
    List<BoardVO> getMainBoardList() throws Exception;

    // 전체 원글 개수 조회
    int getMainBoardCount() throws Exception;

    // 게시글 등록
    void insertBoard(BoardVO boardVO) throws Exception;

    // 단일 게시글 조회
    BoardVO selectBoard(String idx) throws Exception;

    // 조회수 증가
    void updateHitCount(String idx) throws Exception;

    // 게시글 답글 목록 조회
    List<BoardVO> selectReplyTree(String parentIdx) throws Exception;

    // 비밀번호 검증
    boolean checkPassword(String idx, String password) throws Exception;

    // 게시글 삭제(자식 게시글까지 일괄 적용)
    void deleteBoard(String idx) throws Exception;

}
