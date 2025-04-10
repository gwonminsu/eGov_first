package egovframework.practice.homework.web;

import egovframework.practice.homework.service.BoardService;
import egovframework.practice.homework.service.BoardVO;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springmodules.validation.commons.DefaultBeanValidator;

import javax.annotation.Resource;
import java.util.List;

@Controller
@RequestMapping("/board")
public class BoardController {

    private static final Logger log = LoggerFactory.getLogger(BoardController.class);

    @Resource(name = "BoardService")
    protected BoardService boardService;

    /** EgovPropertyService */
//    @Resource(name = "propertiesService")
//    protected EgovPropertyService propertiesService;

    /** Validator */
//    @Resource(name = "beanValidator")
//    protected DefaultBeanValidator beanValidator;

    @RequestMapping("/boardList.do")
    public String selectBoardList(ModelMap model) throws Exception {
        List<BoardVO> list = boardService.getBoardList();
        log.info("SELECT 게시글 목록 데이터: {}", list);
        model.addAttribute("boardList", list);
        return "boardPage";
    }

}
