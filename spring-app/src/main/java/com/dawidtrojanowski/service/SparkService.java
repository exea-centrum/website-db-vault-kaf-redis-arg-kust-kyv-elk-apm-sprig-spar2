package com.dawidtrojanowski.service;

import com.dawidtrojanowski.model.SurveyResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.spark.sql.*;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class SparkService {
    
    private final MongoDBService mongoDBService;
    private SparkSession sparkSession;
    private final Map<String, Map<String, Object>> activeJobs = new ConcurrentHashMap<>();
    
    @PostConstruct
    public void init() {
        try {
            sparkSession = SparkSession.builder()
                .appName("SurveyAnalytics")
                .master("spark://spark-master:7077")
                .config("spark.mongodb.input.uri", "mongodb://mongodb-service:27017/surveys.survey_responses")
                .config("spark.mongodb.output.uri", "mongodb://mongodb-service:27017/surveys.aggregated_stats")
                .config("spark.executor.memory", "1g")
                .config("spark.driver.memory", "512m")
                .getOrCreate();
            
            log.info("Spark session initialized successfully");
        } catch (Exception e) {
            log.error("Failed to initialize Spark session", e);
        }
    }
    
    public void processSurveyResponse(SurveyResponse response) {
        String jobId = UUID.randomUUID().toString();
        Map<String, Object> jobInfo = new HashMap<>();
        jobInfo.put("id", jobId);
        jobInfo.put("name", "SurveyResponseProcessing");
        jobInfo.put("state", "RUNNING");
        jobInfo.put("startedAt", new Date());
        jobInfo.put("responseId", response.getId());
        
        activeJobs.put(jobId, jobInfo);
        
        // Send to Kafka for async processing
        kafkaTemplate.send("survey-responses", response.getId(), response.toString());
        
        // Trigger Spark job
        new Thread(() -> {
            try {
                Dataset<Row> responses = sparkSession.read()
                    .format("mongodb")
                    .load();
                
                // Perform aggregations
                Dataset<Row> aggregated = responses
                    .groupBy("answers")
                    .agg(
                        functions.count("*").as("response_count"),
                        functions.avg("metadata.processingTime").as("avg_processing_time")
                    );
                
                // Save results
                aggregated.write()
                    .format("mongodb")
                    .mode(SaveMode.Append)
                    .save();
                
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
        try {
            if (sparkSession == null) {
                return Collections.emptyMap();
            }
            
            Dataset<Row> stats = sparkSession.read()
                .format("mongodb")
                .option("collection", "aggregated_stats")
                .load();
            
            Map<String, Object> result = new HashMap<>();
            result.put("total_responses", stats.count());
            result.put("aggregations", stats.collectAsList());
            result.put("timestamp", new Date());
            
            return result;
            
        } catch (Exception e) {
            log.error("Failed to get aggregated stats", e);
            return mongoDBService.getBasicStats();
        }
    }
    
    public List<Map<String, Object>> getActiveJobs() {
        return new ArrayList<>(activeJobs.values());
    }
}
