package egovframework.practice.homework.service;

import java.util.List;

public interface BoardService {

    // 무지성 게시글 목록 조회
    List<BoardVO> getBoardList() throws Exception;

}
