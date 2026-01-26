package com.dawidtrojanowski;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableMongoRepositories
@EnableKafka
@EnableScheduling
public class SpringSurveyApplication {
    public static void main(String[] args) {
        SpringApplication.run(SpringSurveyApplication.class, args);
    }
}
