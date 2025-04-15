package egovframework.practice.homework.web;

import egovframework.practice.homework.service.AttachedFileService;
import egovframework.practice.homework.service.AttachedFileVO;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springmodules.validation.commons.DefaultBeanValidator;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.sql.Timestamp;
import java.util.List;

@Controller
@RequestMapping("/board")
public class BoardController {

    private static final Logger log = LoggerFactory.getLogger(BoardController.class);

    @Resource(name = "BoardService")
    protected BoardService boardService;

    @Resource(name="AttachedFileService")
    private AttachedFileService fileService;

//    @Resource(name = "propertiesService")
//    protected EgovPropertyService propertiesService;

    // Validator 사용
    @Resource(name = "beanValidator")
    protected DefaultBeanValidator beanValidator;

    // 게시글 목록 가져오기(일단 무지성으로 모든 데이터 가져옴)
    @RequestMapping("/boardList.do")
    public String selectBoardList(ModelMap model) throws Exception {
        // 글 목록
        List<BoardVO> list = boardService.getBoardList();
        log.info("SELECT 게시글 목록 데이터: {}", list);
        model.addAttribute("boardList", list);
        // 전체 글 개수
        int totalCount = boardService.getBoardCount();
        log.info("전체 글 개수: {}", totalCount);
        model.addAttribute("totalCount", totalCount);
        return "boardPage";
    }

    // 메인(원글) 목록
    @RequestMapping("/mainBoardList.do")
    public String selectMainBoardList(@RequestParam(value="searchType", required = false) String searchType,
                                      @RequestParam(value="keyword", required = false) String keyword,
                                      Model model) throws Exception {

        List<BoardVO> list; // 바인딩할 게시물 객체
        int totalCount; // 바인딩할 게시물 개수
        if (searchType != null && keyword != null && !keyword.trim().isEmpty()) {
            list = boardService.selectSearchBoardList(searchType, keyword);
            totalCount = boardService.selectSearchBoardCount(searchType, keyword);
            log.info("SELECT " + searchType + "(이)가 " + keyword + "(으)로 검색된 게시글 목록 데이터:" + list);
            log.info("검색된 게시글 개수: {}", totalCount);
        } else {
            list = boardService.getMainBoardList();
            totalCount = boardService.getMainBoardCount();
            log.info("SELECT 원글 목록 데이터: {}", list);
            log.info("전체 원글 개수: {}", totalCount);
        }

        model.addAttribute("boardList",  list);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword",    keyword);

        return "boardPage";
    }

    // 게시글 작성 또는 수정 폼 페이지 호출
    @RequestMapping(value="/boardForm.do", method= RequestMethod.GET)
    public String goBoardForm(@RequestParam(value="idx", required = false) String idx,
                              @RequestParam(value="parentBoardIdx", required=false) String parentBoardIdx,
                              @RequestParam(value="password", required=false) String password,
                              Model model) throws Exception {
        // 폼에 바인딩할 VO 준비
        BoardVO boardVO;
        if (idx != null && !idx.isEmpty()) { // 게시글 idx가 있으면 수정 모드 폼
            // 수정 모드: 비밀번호 검증 후 기존 게시글 불러오기
            if (password == null || !boardService.checkPassword(idx, password)) {
                model.addAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
                return selectBoard(idx, model);  // 상세페이지로 돌아감
            }
            boardVO = boardService.selectBoard(idx); // 수정할 게시글 정보를 VO에다 넣어줌
            List<AttachedFileVO> fileList = fileService.getFiles(idx); // 첨부파일 목록을 꺼내서
            model.addAttribute("fileList", fileList); // 모델에 담아주기
        } else {
            // 등록 모드: 새 VO 생성
            boardVO = new BoardVO();
            boardVO.setParentBoardIdx(parentBoardIdx);
        }
        model.addAttribute("board", boardVO); // 바인딩 객체를 추가
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
        // 첨부파일 목록 조회
        List<AttachedFileVO> files = fileService.getFiles(idx);
        model.addAttribute("fileList", files);
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
        log.info("SELECT 게시글 부모 상세 데이터: {}", parent);
        log.info("SELECT 게시글 level: {}", level);

        // 답글 트리 조회 (답글의 답글까지)
        List<BoardVO> replies = boardService.selectReplyTree(idx);
        model.addAttribute("replyList", replies);
        log.info("SELECT 게시글 답글 목록 데이터: {}", replies);

        return "boardDetailPage";
    }

    // 상세페이지에서 파일 다운로드
    @RequestMapping("/downloadFile.do")
    public void downloadFile(@RequestParam("fileIdx") String fileIdx,
                             HttpServletResponse response) throws Exception {
        // 1) 서비스에서 VO를 꺼낸다
        AttachedFileVO fileVO = fileService.getFileByIdx(fileIdx);
        if (fileVO == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 2) VO에서 필요한 값 꺼내기
        String storedFileName = fileVO.getFileUuid() + fileVO.getExt();   // 실제 저장된 파일명
        String originalFileName = fileVO.getFileName(); // 사용자에게 보여줄 원본 파일명
        String fullPath = fileVO.getFilePath() + File.separator + storedFileName;

        // 3) 파일 읽어서 response로 스트리밍
        File file = new File(fullPath);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + URLEncoder.encode(originalFileName, "UTF-8") + "\"");
        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
        }
    }


    // 게시글 등록
    @RequestMapping(value="/insertBoard.do", method=RequestMethod.POST)
    public String insertBoard(@ModelAttribute("board") BoardVO boardVO,
                              BindingResult bindingResult,
                              @RequestParam("files") MultipartFile[] files,
                              @RequestParam(value="searchType",   required=false) String searchType,
                              @RequestParam(value="keyword",      required=false) String keyword,
                              RedirectAttributes redirectAttrs,
                              Model model) throws Exception {
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
        fileService.saveFiles(boardVO.getIdx(), files);

        log.info("INSERT 게시글 데이터: {}", boardVO);

        // 리다이렉트 시 검색 파라미터 유지(원글이 아닌 답글인 경우만)
        redirectAttrs.addAttribute("idx", boardVO.getIdx());
        if (boardVO.getParentBoardIdx() != null) {
            if (searchType != null) redirectAttrs.addAttribute("searchType", searchType);
            if (keyword != null) redirectAttrs.addAttribute("keyword", keyword);
        }

        // 작성한 글 상세 페이지로 이동
        return "redirect:selectBoard.do";
    }
    
    // 게시글 수정
    @RequestMapping(value="/updateBoard.do", method=RequestMethod.POST)
    public String updateBoard(@ModelAttribute("board") BoardVO boardVO,
                              BindingResult bindingResult,
                              @RequestParam(value="files", required=false) MultipartFile[] files,
                              @RequestParam(value="deleteFileIdx", required=false) String[] deleteFileIdx,
                              @RequestParam(value="searchType", required=false) String searchType,
                              @RequestParam(value="keyword", required=false) String keyword,
                              RedirectAttributes redirectAttrs) throws Exception {
        beanValidator.validate(boardVO, bindingResult);
        if (bindingResult.hasErrors()) {
            return "boardFormPage";
        }
        // update_at 값만 update
        boardVO.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
        log.info("UPDATE 게시글 데이터: {}", boardVO);
        boardService.updateBoard(boardVO);
        // 삭제 체크된 파일들 삭제
        fileService.deleteFiles(deleteFileIdx);
        // 새로 업로드된 파일들 저장
        fileService.saveFiles(boardVO.getIdx(), files);

        // 리다이렉트 시 검색 파라미터 유지
        redirectAttrs.addAttribute("idx", boardVO.getIdx());
        if (searchType != null) redirectAttrs.addAttribute("searchType", searchType);
        if (keyword    != null) redirectAttrs.addAttribute("keyword",    keyword);

        return "redirect:/board/selectBoard.do";
    }

    // 게시글 삭제
    @RequestMapping(value="/deleteBoard.do", method=RequestMethod.POST)
    public String deleteBoard(@RequestParam("idx") String idx,
                              @RequestParam("password") String password,
                              @RequestParam(value = "searchType", required = false) String searchType,
                              @RequestParam(value = "keyword", required = false) String keyword,
                              RedirectAttributes redirectAttrs,
                              Model model) throws Exception {
        // 비밀번호 검증
        if (!boardService.checkPassword(idx, password)) {
            model.addAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            return selectBoard(idx, model);
        }

        // 부모 게시글 idx
        BoardVO board = boardService.selectBoard(idx);
        String parentIdx = board.getParentBoardIdx();

        // 자식을 포함한 게시글 일괄 삭제
        boardService.deleteBoard(idx);

        // 검색 파라미터를 리다이렉트 속성에 추가
        if (searchType != null) redirectAttrs.addAttribute("searchType", searchType);
        if (keyword != null) redirectAttrs.addAttribute("keyword",    keyword);

        if (parentIdx != null && !parentIdx.isEmpty()) {
            // 부모가 있는 경우: 부모 상세페이지로
            redirectAttrs.addAttribute("idx", parentIdx);
            return "redirect:/board/selectBoard.do";
        } else {
            // 부모가 없는 경우(원글): 메인 목록 페이지로
            return "redirect:/board/mainBoardList.do";
        }
    }

}
