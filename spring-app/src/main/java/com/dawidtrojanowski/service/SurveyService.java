package com.dawidtrojanowski.service;

import com.dawidtrojanowski.model.SurveyQuestion;
import com.dawidtrojanowski.model.SurveyResponse;
import com.dawidtrojanowski.repository.SurveyQuestionRepository;
import com.dawidtrojanowski.repository.SurveyResponseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class SurveyService {
    
    private final SurveyQuestionRepository questionRepository;
    private final SurveyResponseRepository responseRepository;
    
    public List<SurveyQuestion> getActiveQuestions() {
        List<SurveyQuestion> questions = questionRepository.findByActive(true);
        if (questions.isEmpty()) {
            return createSampleQuestions();
        }
        return questions;
    }
    
    private List<SurveyQuestion> createSampleQuestions() {
        List<SurveyQuestion> questions = new ArrayList<>();
        
        SurveyQuestion q1 = new SurveyQuestion();
        q1.setQuestionText("Jak oceniasz naszą platformę?");
        q1.setType(SurveyQuestion.QuestionType.RATING);
        q1.setOptions(new String[]{"1", "2", "3", "4", "5"});
        q1.setActive(true);
        q1.setCreatedAt(LocalDateTime.now());
        
        SurveyQuestion q2 = new SurveyQuestion();
        q2.setQuestionText("Jakie funkcjonalności chciałbyś dodać?");
        q2.setType(SurveyQuestion.QuestionType.TEXT);
        q2.setActive(true);
        q2.setCreatedAt(LocalDateTime.now());
        
        questions.add(q1);
        questions.add(q2);
        
        questionRepository.saveAll(questions);
        return questions;
    }
    
    public SurveyResponse saveResponse(Map<String, Object> responses) {
        SurveyResponse response = new SurveyResponse();
        response.setAnswers(responses);
        response.setSubmittedAt(LocalDateTime.now());
        return responseRepository.save(response);
    }
    
    public Map<String, Object> searchLogs(String query) {
        return Map.of(
            "hits", Map.of(
                "hits", List.of(
                    Map.of("_source", Map.of(
                        "message", "Sample log entry for query: " + query,
                        "@timestamp", LocalDateTime.now().toString(),
                        "level", "INFO"
                    ))
                )
            )
        );
    }
}
