package cau.capstone.helpclosing.controller;


import cau.capstone.helpclosing.model.Entity.HelpLog;
import cau.capstone.helpclosing.model.Header;
import cau.capstone.helpclosing.model.Request.HelpLogRequest;
import cau.capstone.helpclosing.model.Response.HelpLogResponse;
import cau.capstone.helpclosing.service.HelpLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RequiredArgsConstructor
@RestController
public class HelpLogController {

    @Autowired
    HelpLogService helpLogService;

    @GetMapping("/helpLog/request/{userId}")
    public Header<List<HelpLog>> findHelpLogRequest(@PathVariable("userId") Long userId){
        try{
            return Header.OK(helpLogService.getHelpLogListRequest(userId),"list of help log");
        }
        catch(Exception e){
            return Header.ERROR("Need to login for finding help log");
        }
    }

    @GetMapping("/helpLog/recipient/{userId}")
    public Header<List<HelpLog>> findHelpLogRecipient(@PathVariable("userId") Long userId){
        try{
            return Header.OK(helpLogService.getHelpLogListResponse(userId),"list of help log");
        }
        catch(Exception e){
            return Header.ERROR("Need to login for finding help log");
        }
    }

    @PostMapping("/helpLog/create")
    public Header<HelpLogResponse> createHelpLog(HelpLogRequest helpLogRequest){
        try{
            return Header.OK(helpLogService.createHelpLog(helpLogRequest),"create help log");
        }
        catch(Exception e){
            return Header.ERROR("Need to login for creating help log");
        }
    }
}
