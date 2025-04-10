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

}
