package com.dawidtrojanowski.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;

@Document(collection = "survey_questions")
@Data
public class SurveyQuestion {
    @Id
    private String id;
    private String questionText;
    private QuestionType type;
    private String[] options;
    private Integer order;
    private boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    public enum QuestionType {
        RATING, TEXT, MULTIPLE_CHOICE, BOOLEAN
    }
}
