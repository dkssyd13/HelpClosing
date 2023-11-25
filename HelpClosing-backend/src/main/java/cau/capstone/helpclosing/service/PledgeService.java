package cau.capstone.helpclosing.service;

import cau.capstone.helpclosing.model.repository.PledgeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class PledgeService {

    @Autowired
    private PledgeRepository pledgeRepository;


}
