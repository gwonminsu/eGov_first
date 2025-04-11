package egovframework.practice.homework.service;

import java.util.List;

public interface BoardService {

    // 무지성 게시글 목록 조회
    List<BoardVO> getBoardList() throws Exception;

    // 원글 목록 조회
    List<BoardVO> getMainBoardList() throws Exception;

    // 게시글 등록
    void insertBoard(BoardVO boardVO) throws Exception;

    // 단일 게시글 조회
    BoardVO selectBoard(String idx) throws Exception;

    // 조회수 증가
    void updateHitCount(String idx) throws Exception;

    // 게시글 답글 목록 조회
    List<BoardVO> selectReplyTree(String parentIdx) throws Exception;

}
