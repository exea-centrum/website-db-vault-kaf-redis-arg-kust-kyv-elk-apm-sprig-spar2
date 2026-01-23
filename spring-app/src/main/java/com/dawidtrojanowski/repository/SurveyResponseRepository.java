package com.dawidtrojanowski.repository;

import com.dawidtrojanowski.model.SurveyResponse;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface SurveyResponseRepository extends MongoRepository<SurveyResponse, String> {
}
