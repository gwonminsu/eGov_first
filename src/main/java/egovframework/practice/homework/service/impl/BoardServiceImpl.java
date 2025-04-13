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

    private static final Logger log = LoggerFactory.getLogger(BoardServiceImpl.class);

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

    // 게시글 수정
    @Override
    public void updateBoard(BoardVO boardVO) throws Exception {
        boardDAO.updateBoard(boardVO);
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

    // 비밀번호 검증
    @Override
    public boolean checkPassword(String idx, String password) throws Exception {
        String actual = boardDAO.selectPassword(idx);
        return actual != null && actual.equals(password);
    }

    // 게시글 삭제(자식 게시글까지 일괄 적용)
    @Override
    public void deleteBoard(String idx) throws Exception {
        // 1) 자식 답글 조회
        List<BoardVO> replies = boardDAO.selectReplyTree(idx);
        // 2) 답글들 한 번에 삭제
        for (BoardVO r : replies) {
            boardDAO.deleteBoard(r.getIdx());
            log.info("DELETE 추가 삭제된 자식 게시글 idx: {}", r.getIdx());
        }
        // 4) 원글 삭제
        BoardVO deletedBoard = boardDAO.selectBoard(idx);
        boardDAO.deleteBoard(idx);
        log.info("DELETE 삭제된 게시글 데이터: {}", deletedBoard);
    }

}
