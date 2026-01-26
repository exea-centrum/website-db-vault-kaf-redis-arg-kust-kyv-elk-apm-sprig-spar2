package com.dawidtrojanowski.controller;

import com.dawidtrojanowski.model.SurveyQuestion;
import com.dawidtrojanowski.model.SurveyResponse;
import com.dawidtrojanowski.service.SurveyService;
import com.dawidtrojanowski.service.SparkService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/v2")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class SurveyController {
    
    private final SurveyService surveyService;
    private final SparkService sparkService;
    
    @GetMapping("/survey/questions")
    public ResponseEntity<List<SurveyQuestion>> getQuestions() {
        log.info("Fetching survey questions");
        return ResponseEntity.ok(surveyService.getActiveQuestions());
    }
    
    @PostMapping("/survey/submit")
    public ResponseEntity<SurveyResponse> submitSurvey(
            @RequestBody Map<String, Object> responses,
            @RequestHeader(value = "User-Agent", required = false) String userAgent,
            @RequestHeader(value = "X-Forwarded-For", required = false) String ipAddress) {
        
        log.info("Submitting survey responses: {}", responses.keySet());
        SurveyResponse response = surveyService.saveResponse(responses, userAgent, ipAddress);
        
        // Trigger Spark processing
        sparkService.processSurveyResponse(response);
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/survey/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        log.info("Fetching survey statistics");
        Map<String, Object> stats = sparkService.getAggregatedStats();
        return ResponseEntity.ok(stats);
    }
    
    @GetMapping("/spark/jobs")
    public ResponseEntity<List<Map<String, Object>>> getSparkJobs() {
        log.info("Fetching Spark jobs status");
        return ResponseEntity.ok(sparkService.getActiveJobs());
    }
    
    @GetMapping("/elk/logs")
    public ResponseEntity<Map<String, Object>> searchLogs(
            @RequestParam String query,
            @RequestParam(defaultValue = "0") int from,
            @RequestParam(defaultValue = "10") int size) {
        
        log.info("Searching logs with query: {}", query);
        return ResponseEntity.ok(surveyService.searchLogs(query, from, size));
    }
    
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of(
            "status", "UP",
            "service", "spring-survey-api",
            "timestamp", java.time.LocalDateTime.now().toString()
        ));
    }
}
