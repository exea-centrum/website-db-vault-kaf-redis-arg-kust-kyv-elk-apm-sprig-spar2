package com.dawidtrojanowski.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;
import java.util.Map;

@Document(collection = "survey_responses")
@Data
public class SurveyResponse {
    @Id
    private String id;
    private String sessionId;
    private String userId;
    private Map<String, Object> answers;
    private LocalDateTime submittedAt;
    private String userAgent;
    private String ipAddress;
    private Metadata metadata;
    
    @Data
    public static class Metadata {
        private String browser;
        private String os;
        private String device;
        private Double processingTime;
        private String sparkJobId;
    }
}
