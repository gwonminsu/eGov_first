package egovframework.practice.homework.service.impl;

import egovframework.practice.homework.service.BoardService;
import egovframework.practice.homework.service.BoardVO;
import egovframework.practice.test.service.TestVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
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

}
