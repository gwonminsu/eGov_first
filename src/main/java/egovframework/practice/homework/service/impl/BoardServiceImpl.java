package egovframework.practice.homework.service.impl;

import egovframework.practice.homework.service.BoardService;
import egovframework.practice.homework.service.BoardVO;
import egovframework.practice.test.service.TestVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;

@Service("BoardService")
public class BoardServiceImpl implements BoardService {

    private static final Logger LOGGER = LoggerFactory.getLogger(BoardServiceImpl.class);

    @Resource(name = "BoardDAO")
    protected BoardDAO boardDAO;

    // 무지성 게시글 목록 조회
    @Override
    public List<BoardVO> getBoardList() throws Exception {
        return boardDAO.selectBoardList();
    }

    // 전체 게시글 개수 조회
    @Override
    public int getBoardCount() throws Exception {
        return boardDAO.selectBoardCount();
    }

    // 원글 목록 조회
    @Override
    public List<BoardVO> getMainBoardList() throws Exception {
        return boardDAO.selectMainBoardList();
    }

    // 전체 원글 개수 조회
    @Override
    public int getMainBoardCount() throws Exception {
        return boardDAO.selectMainBoardCount();
    }

    // 게시글 등록
    @Override
    public void insertBoard(BoardVO boardVO) throws Exception {
        boardDAO.insertBoard(boardVO);
    }

    // 단일 게시글 조회
    @Override
    public BoardVO selectBoard(String idx) throws Exception {
        return boardDAO.selectBoard(idx);
    }

    @Override
    public void updateHitCount(String idx) throws Exception {
        boardDAO.updateHitCount(idx);
    }

    // 게시글 답글 목록 조회
    @Override
    public List<BoardVO> selectReplyTree(String parentIdx) throws Exception {
        return boardDAO.selectReplyTree(parentIdx);
    }

}
