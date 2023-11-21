package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.model.Entity.HelpLog;
import cau.capstone.helpclosing.model.Request.HelpLogRequest;
import cau.capstone.helpclosing.model.Response.HelpLogResponse;
import cau.capstone.helpclosing.model.repository.HelpLogRepository;
import cau.capstone.helpclosing.model.repository.LocationRepository;
import cau.capstone.helpclosing.model.repository.PledgeRepository;
import cau.capstone.helpclosing.model.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;


@Service
public class HelpLogService {

    @Autowired
    HelpLogRepository helpLogRepository;

    @Autowired
    PledgeRepository pledgeRepository;

    @Autowired
    LocationRepository locationRepository;

    @Autowired
    UserRepository userRepository;


//    public void createHelpLog(HelpLogRequest helpLogRequest){
//
//        HelpLog helpLog = HelpLog.builder()
//                .requester(userRepository.findByUserId(helpLogRequest.getRequesterId()))
//                .recipient(userRepository.findByUserId(helpLogRequest.getRecipientId()))
//                .pledgeRequest(pledgeRepository.findByPledgeId(helpLogRequest.getPledgeRequestId()))
//                .pledgeRecipient(pledgeRepository.findByPledgeId(helpLogRequest.getPledgeRecipientId()))
//                .location(locationRepository.findByLocationId(helpLogRequest.getLocationId()))
//
//
//        helpLogRepository.save(helpLog);
//    }


    //위치를 어떻게 받을건지?
    public HelpLogResponse createHelpLog(HelpLogRequest helpLogRequest){

            HelpLog helpLog = HelpLog.builder()
                    .requester(userRepository.findByUserId(helpLogRequest.getRequesterId()))
                    .recipient(userRepository.findByUserId(helpLogRequest.getRecipientId()))
                    .pledgeRequest(pledgeRepository.findByUser(userRepository.findByUserId(helpLogRequest.getRequesterId())))
                    .pledgeRecipient(pledgeRepository.findByUser(userRepository.findByUserId(helpLogRequest.getRecipientId())))
                   // .location(locationRepository.findByUserId(helpLogRequest.getRecipientId()))
                    .build();

            helpLog.setTime(LocalDateTime.now());

            helpLogRepository.save(helpLog);

            return HelpLogResponse.builder()
                    .requesterId(helpLogRequest.getRequesterId())
                    .recipientId(helpLogRequest.getRecipientId())
                    .build();
    }

    public List<HelpLog> getHelpLogListRequest(Long userId){
        return helpLogRepository.findAllByRequester(userRepository.findByUserId(userId));
    }

    public List<HelpLog> getHelpLogListResponse(Long userId){
        return helpLogRepository.findAllByRecipient(userRepository.findByUserId(userId));
    }


}
