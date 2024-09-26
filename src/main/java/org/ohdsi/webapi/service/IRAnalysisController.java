package org.ohdsi.webapi.service;

import org.ohdsi.webapi.service.dto.IRAnalysisShortDTO;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

//@RestController
//@RequestMapping("/ir2")
//public class IRAnalysisController {
//
//    private final IRAnalysisService irAnalysisService;
//
//    public IRAnalysisController(IRAnalysisService irAnalysisService) {
//        this.irAnalysisService = irAnalysisService;
//    }
//
//    @GetMapping(path = "/", produces = MediaType.APPLICATION_JSON_VALUE)
//    List<IRAnalysisShortDTO> getIRAnalysisList() {
//        return irAnalysisService.getIRAnalysisList();
//    }
//}
