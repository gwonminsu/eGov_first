package egovframework.practice.homework.service.impl;

import egovframework.practice.homework.service.BoardVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository("BoardDAO")
public class BoardDAO {

    @Resource(name = "sqlSession")
    protected SqlSessionTemplate sqlSession;

    // 무지성 게시글 목록 조회
    public List<BoardVO> selectBoardList() throws Exception {
        return sqlSession.selectList("BoardDAO.selectBoardList");
    }

    // 전체 게시글 개수 조회
    public int selectBoardCount() throws Exception {
        return sqlSession.selectOne("BoardDAO.selectBoardCount");
    }

    // 원글 목록 조회
    public List<BoardVO> selectMainBoardList() throws Exception {
        return sqlSession.selectList("BoardDAO.selectMainBoardList");
    }

    // 전체 원글 개수 조회
    public int selectMainBoardCount() throws Exception {
        return sqlSession.selectOne("BoardDAO.selectMainBoardCount");
    }

    // 게시글 등록
    public void insertBoard(BoardVO boardVO) throws Exception {
        // mybatis 매퍼 XML 파일의 id가 "BoardDAO.insertBoard"인 쿼리가 실행
        sqlSession.insert("BoardDAO.insertBoard", boardVO);
    }

    // 게시글 수정
    public void updateBoard(BoardVO boardVO) throws Exception {
        sqlSession.update("BoardDAO.updateBoard", boardVO);
    }

    // 게시글 하나 조회
    public BoardVO selectBoard(String idx) throws Exception {
        return sqlSession.selectOne("BoardDAO.selectBoard", idx);
    };

    // 조회수 증가
    public void updateHitCount(String idx) throws Exception {
        sqlSession.update("BoardDAO.updateHitCount", idx);
    }

    // 답글 목록 조회
    public List<BoardVO> selectReplyTree(String parentIdx) throws Exception {
        return sqlSession.selectList("BoardDAO.selectReplyTree", parentIdx);
    };

    // 검증용 비밀번호 조회
    public String selectPassword(String idx) throws Exception {
        return sqlSession.selectOne("BoardDAO.selectPassword", idx);
    }

    // 게시물 삭제
    public void deleteBoard(String idx) throws Exception {
        sqlSession.delete("BoardDAO.deleteBoard", idx);
    }

}
