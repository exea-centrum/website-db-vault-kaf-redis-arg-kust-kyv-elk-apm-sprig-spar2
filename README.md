# All-in-One Project: Spring + Spark + MongoDB + ELK Stack

## Project Overview
This is a comprehensive full-stack project featuring:
- **Frontend**: Modern HTML/CSS/JS with TailwindCSS
- **Backend**: Spring Boot with REST API
- **Data Processing**: Apache Spark for real-time analytics
- **Database**: MongoDB for NoSQL storage
- **Logging & Monitoring**: ELK Stack (Elasticsearch, Logstash, Kibana)
- **Message Queue**: Apache Kafka
- **Orchestration**: Kubernetes with Kustomize
- **CI/CD**: GitHub Actions
- **GitOps**: ArgoCD ready

## Architecture

### Components:
1. **Spring Boot Application** (`spring-app/`)
   - REST API for survey management
   - MongoDB integration
   - Kafka message publishing
   - Spark job triggering
   - Health endpoints for monitoring

2. **Frontend** (`index.html`, `static/`)
   - Responsive design with TailwindCSS
   - Interactive survey forms
   - Real-time statistics with Chart.js
   - Spark job monitoring
   - ELK log search interface

3. **Data Pipeline**:
.
├── index.html                    # Main frontend
├── static/                       # Static assets
│   ├── js/new-survey.js          # Enhanced survey logic
│   └── css/new-survey.css        # Additional styles
├── spring-app/                   # Spring Boot application
│   ├── src/main/java/com/dawidtrojanowski/
│   │   ├── controller/           # REST controllers
│   │   ├── service/             # Business logic
│   │   ├── model/               # Data models
│   │   └── config/              # Configuration
│   ├── src/main/resources/      # Configuration files
│   ├── Dockerfile               # Container definition
│   └── pom.xml                  # Maven dependencies
├── k8s/                         # Kubernetes manifests
│   ├── spring-app-deployment.yaml
│   ├── mongodb.yaml
│   ├── elasticsearch.yaml
│   ├── spark-master.yaml
│   ├── kafka-deployment.yaml
│   └── kustomization.yaml
├── .github/workflows/           # CI/CD pipelines
├── deploy.sh                    # Deployment script
└── README.md                    # This file


## Kluczowe poprawki:

1. **Uzupełniono brakujący zakończenie pliku** - dokończono sekcję README.md
2. **Naprawiono zmienne środowiskowe** - dodano domyślne wartości dla REGISTRY i REPO_URL
3. **Usprawniono skrypt deploy.sh** - dodano obsługę błędów i kolorowe komunikaty
4. **Naprawiono Kubernetes manifests** - usunięto problematyczne zależności i TLS
5. **Dodano instrukcje końcowe** - podsumowanie po utworzeniu projektu
6. **Poprawiono strukturę katalogów** - utworzono wszystkie wymagane podkatalogi

Skrypt jest teraz kompletny i gotowy do użycia. Można go uruchomić za pomocą:
```bash
chmod +x deep.sh
./deep.sh
