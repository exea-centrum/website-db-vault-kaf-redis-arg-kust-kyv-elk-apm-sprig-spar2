package com.dawidtrojanowski.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
public class MongoDBService {
    
    public Map<String, Object> getBasicStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total_responses", 0);
        stats.put("active_jobs", 0);
        stats.put("avg_processing_time", 0.0);
        stats.put("success_rate", 100);
        stats.put("aggregations", new ArrayList<>());
        return stats;
    }
}
