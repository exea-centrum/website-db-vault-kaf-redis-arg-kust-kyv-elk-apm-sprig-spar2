package com.dawidtrojanowski.repository;

import com.dawidtrojanowski.model.SurveyQuestion;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface SurveyQuestionRepository extends MongoRepository<SurveyQuestion, String> {
    List<SurveyQuestion> findByActive(boolean active);
}
