package egovframework.practice.homework.web;

import egovframework.practice.homework.service.BoardService;
import egovframework.practice.homework.service.BoardVO;
import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springmodules.validation.commons.DefaultBeanValidator;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.util.List;

@Controller
@RequestMapping("/board")
public class BoardController {

    private static final Logger log = LoggerFactory.getLogger(BoardController.class);

    @Resource(name="boardIdGnrService")
    private EgovIdGnrService idgen;

    @Resource(name = "BoardService")
    protected BoardService boardService;

    /** EgovPropertyService */
//    @Resource(name = "propertiesService")
//    protected EgovPropertyService propertiesService;

    // Validator 사용
    @Resource(name = "beanValidator")
    protected DefaultBeanValidator beanValidator;

    // 게시글 목록 가져오기(일단 무지성으로 모든 데이터 가져옴)
    @RequestMapping("/boardList.do")
    public String selectBoardList(ModelMap model) throws Exception {
        List<BoardVO> list = boardService.getBoardList();
        log.info("SELECT 게시글 목록 데이터: {}", list);
        model.addAttribute("boardList", list);
        return "boardPage";
    }

    // 게시글 작성 폼 페이지 호출
    @RequestMapping(value="/boardForm.do", method= RequestMethod.GET)
    public String goBoardForm(@RequestParam(value="parentBoardIdx", required=false) String parentBoardIdx, Model model) {
        // 폼에 바인딩할 VO 생성 및 부모 idx 세팅
        BoardVO boardVO = new BoardVO();
        boardVO.setParentBoardIdx(parentBoardIdx);
        model.addAttribute("board", boardVO); // 폼 검증용 바인딩 객체를 추가
        return "boardFormPage";
    }

    // 게시글 상세 조회
    @RequestMapping(value="/selectBoard.do", method=RequestMethod.GET)
    public String selectBoard(@RequestParam("idx") String idx, Model model) throws Exception {
        // 조회수 증가
        boardService.updateHitCount(idx);

        // 게시글 조회
        BoardVO board = boardService.selectBoard(idx);
        int level = 0;
        String parentIdx = board.getParentBoardIdx();
        // 부모 글 가져오기
        BoardVO parent = boardService.selectBoard(parentIdx);
        if (parentIdx != null && !parentIdx.isEmpty()) {
            // 부모의 부모가 있으면 level=2, 없으면 level=1
            level = (parent.getParentBoardIdx() != null && !parent.getParentBoardIdx().isEmpty()) ? 2 : 1;
        }
        board.setLevel(level);
        model.addAttribute("board", board);
        model.addAttribute("parentBoard", parent);
        log.info("SELECT 게시글 상세 데이터: {}", board);
        log.info("SELECT 게시글 부모 상세 데이터: {}", board);
        log.info("SELECT 게시글 level: {}", level);

        // 답글 트리 조회 (답글의 답글까지)
        List<BoardVO> replies = boardService.selectReplyTree(idx);
        model.addAttribute("replyList", replies);
        log.info("SELECT 게시글 답글 목록 데이터: {}", replies);

        return "boardDetailPage";
    }

    // 게시글 등록
    @RequestMapping(value="/insertBoard.do", method=RequestMethod.POST)
    public String insertBoard(@ModelAttribute("board") BoardVO boardVO, BindingResult bindingResult, Model model) throws Exception {
        // idgen을 사용하여 게시글 PK 자동 생성
        String newBoardId = idgen.getNextStringId();  // idgen 서비스에서 새 ID 생성
        boardVO.setIdx(newBoardId); // 생성된 id를 Board VO에 설정

        // 서버에서 폼 검증
        beanValidator.validate(boardVO, bindingResult);
        if (bindingResult.hasErrors()) {
            model.addAttribute("board", boardVO);
            return "boardFormPage";
        }

        // 현재 타임스탬프 생성 후, 생성일과 수정일 필드에 설정
        Timestamp now = new Timestamp(System.currentTimeMillis());
        boardVO.setCreatedAt(now);  // created_at 값 설정
        boardVO.setUpdatedAt(now);  // updated_at 값 설정

        boardService.insertBoard(boardVO);

        log.info("INSERT 게시글 데이터: {}", boardVO);

        return "redirect:boardList.do";
    }

}
