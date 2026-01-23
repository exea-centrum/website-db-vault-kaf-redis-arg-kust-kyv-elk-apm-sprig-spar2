package com.dawidtrojanowski.service;

import com.dawidtrojanowski.model.SurveyResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class SparkService {
    
    private final Map<String, Map<String, Object>> activeJobs = new ConcurrentHashMap<>();
    
    public void processSurveyResponse(SurveyResponse response) {
        String jobId = UUID.randomUUID().toString();
        Map<String, Object> jobInfo = new HashMap<>();
        jobInfo.put("id", jobId);
        jobInfo.put("name", "SurveyResponseProcessing");
        jobInfo.put("state", "RUNNING");
        jobInfo.put("startedAt", new Date());
        jobInfo.put("responseId", response.getId());
        
        activeJobs.put(jobId, jobInfo);
        
        new Thread(() -> {
            try {
                Thread.sleep(3000);
                jobInfo.put("state", "COMPLETED");
                jobInfo.put("completedAt", new Date());
                log.info("Spark job completed successfully: {}", jobId);
            } catch (Exception e) {
                jobInfo.put("state", "FAILED");
                jobInfo.put("error", e.getMessage());
                log.error("Spark job failed: {}", jobId, e);
            }
        }).start();
    }
    
    public Map<String, Object> getAggregatedStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total_responses", activeJobs.size());
        stats.put("active_jobs", (int) activeJobs.values().stream()
            .filter(job -> "RUNNING".equals(job.get("state")))
            .count());
        stats.put("avg_processing_time", 2.5);
        stats.put("timestamp", new Date());
        return stats;
    }
    
    public List<Map<String, Object>> getActiveJobs() {
        return new ArrayList<>(activeJobs.values());
    }
}
