package com.dawidtrojanowski.service;

import com.dawidtrojanowski.model.SurveyQuestion;
import com.dawidtrojanowski.model.SurveyResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Service
public class SurveyService {
    
    public List<SurveyQuestion> getActiveQuestions() {
        List<SurveyQuestion> questions = new ArrayList<>();
        
        // Sample questions
        for (int i = 1; i <= 5; i++) {
            SurveyQuestion question = new SurveyQuestion();
            question.setId("q" + i);
            question.setQuestionText("Pytanie " + i + ": Jak oceniasz naszą usługę?");
            question.setType(SurveyQuestion.QuestionType.RATING);
            question.setOptions(new String[]{"1", "2", "3", "4", "5"});
            question.setOrder(i);
            question.setActive(true);
            question.setCreatedAt(LocalDateTime.now());
            question.setUpdatedAt(LocalDateTime.now());
            questions.add(question);
        }
        
        return questions;
    }
    
    public SurveyResponse saveResponse(Map<String, Object> responses, String userAgent, String ipAddress) {
        SurveyResponse response = new SurveyResponse();
        response.setId(UUID.randomUUID().toString());
        response.setSessionId(UUID.randomUUID().toString());
        response.setUserId("anonymous");
        response.setAnswers(responses);
        response.setSubmittedAt(LocalDateTime.now());
        response.setUserAgent(userAgent);
        response.setIpAddress(ipAddress);
        
        SurveyResponse.Metadata metadata = new SurveyResponse.Metadata();
        metadata.setBrowser(userAgent != null && userAgent.contains("Chrome") ? "Chrome" : "Other");
        metadata.setOs(userAgent != null && userAgent.contains("Windows") ? "Windows" : "Other");
        metadata.setDevice("Desktop");
        metadata.setProcessingTime(0.5);
        metadata.setSparkJobId(UUID.randomUUID().toString());
        
        response.setMetadata(metadata);
        
        log.info("Saved survey response: {}", response.getId());
        return response;
    }
    
    public Map<String, Object> searchLogs(String query, int from, int size) {
        // Simulated log search
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> hits = new HashMap<>();
        
        List<Map<String, Object>> hitList = new ArrayList<>();
        Map<String, Object> hit = new HashMap<>();
        Map<String, Object> source = new HashMap<>();
        
        source.put("message", "Sample log entry for query: " + query);
        source.put("@timestamp", LocalDateTime.now().toString());
        source.put("level", "INFO");
        source.put("logger", "SurveyController");
        
        hit.put("_source", source);
        hitList.add(hit);
        
        hits.put("hits", hitList);
        result.put("hits", hits);
        
        return result;
    }
}
