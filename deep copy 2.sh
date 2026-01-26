#!/bin/bash

set -e

# PROJECT SETUP
PROJECT="website-db-vault-kaf-redis-arg-kust-kyv-elk-apm-sprig-spar2"
NAMESPACE="davtroelkjs"
REGISTRY="${REGISTRY:-ghcr.io/exea-centrum/website-db-vault-kaf-redis-arg-kust-kyv-elk-apm-sprig-spar2}"
REPO_URL="${REPO_URL:-https://github.com/exea-centrum/website-db-vault-kaf-redis-arg-kust-kyv-elk-apm-sprig-spar2.git}"

echo "Creating project structure for $PROJECT..."

# Create directory structure
mkdir -p $PROJECT
cd $PROJECT

mkdir -p k8s
mkdir -p spring-app/src/main/java/com/dawidtrojanowski/{model,controller,service,config,repository}
mkdir -p spring-app/src/main/resources
mkdir -p static/{js,css}
mkdir -p .github/workflows

# ============================================
# 1. Create main HTML file (index.html)
# ============================================
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="pl">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dawid Trojanowski - Strona Osobista</title>
    <script src="https://cdn.tailwindcss.com "></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js "></script>
    <style>
      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(10px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      .animate-fade-in {
        animation: fadeIn 0.5s ease-out;
      }
      .skill-bar {
        height: 10px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 5px;
        overflow: hidden;
      }
      .skill-progress {
        height: 100%;
        border-radius: 5px;
        transition: width 1.5s ease-in-out;
      }
    </style>
  </head>
  <body
    class="bg-gradient-to-br from-slate-900 via-purple-900 to-slate-900 text-white min-h-screen"
  >
    <header
      class="border-b border-purple-500/30 backdrop-blur-sm bg-black/20 sticky top-0 z-50"
    >
      <div class="container mx-auto px-6 py-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <h1
              class="text-3xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent"
            >
              Dawid Trojanowski
            </h1>
          </div>
          <nav class="flex gap-4">
            <button
              onclick="showTab('intro')"
              class="tab-btn px-4 py-2 rounded-lg bg-purple-500 text-white"
              data-tab="intro"
            >
              O Mnie
            </button>
            <button
              onclick="showTab('edu')"
              class="tab-btn px-4 py-2 rounded-lg text-purple-300"
              data-tab="edu"
            >
              Edukacja
            </button>
            <button
              onclick="showTab('exp')"
              class="tab-btn px-4 py-2 rounded-lg text-purple-300"
              data-tab="exp"
            >
              Doświadczenie
            </button>
            <button
              onclick="showTab('skills')"
              class="tab-btn px-4 py-2 rounded-lg text-purple-300"
              data-tab="skills"
            >
              Umiejętności
            </button>
            <button
              onclick="showTab('survey')"
              class="tab-btn px-4 py-2 rounded-lg text-purple-300"
              data-tab="survey"
            >
              Ankieta
            </button>
            <button
              onclick="showTab('new-survey')"
              class="tab-btn px-4 py-2 rounded-lg text-purple-300"
              data-tab="new-survey"
            >
              Nowa Ankieta
            </button>
            <button
              onclick="showTab('contact')"
              class="tab-btn px-4 py-2 rounded-lg text-purple-300"
              data-tab="contact"
            >
              Kontakt
            </button>
          </nav>
        </div>
      </div>
    </header>

    <main class="container mx-auto px-6 py-12">
      <div id="intro-tab" class="tab-content">
        <div class="space-y-8 animate-fade-in">
          <div
            class="bg-gradient-to-br from-purple-500/10 to-pink-500/10 backdrop-blur-lg border border-purple-500/20 rounded-2xl p-8"
          >
            <h2 class="text-4xl font-bold mb-6 text-purple-300">O Mnie</h2>
            <p class="text-lg text-gray-300 leading-relaxed">
              Cześć! Jestem Dawidem Trojanowskim, pasjonatem informatyki i
              nowych technologii. Specjalizuję się w tworzeniu rozproszonych
              systemów wykorzystujących FastAPI, Redis, Kafka i PostgreSQL z
              pełnym monitoringiem.
            </p>
          </div>
        </div>
      </div>

      <div id="edu-tab" class="tab-content hidden">
        <div class="space-y-6 animate-fade-in">
          <h2 class="text-4xl font-bold mb-8 text-purple-300">Edukacja</h2>
          <div
            class="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-lg border border-purple-500/20 rounded-xl p-6"
          >
            <h3 class="text-2xl font-bold mb-4 text-purple-300">
              Politechnika Warszawska
            </h3>
            <p class="text-gray-300 mb-4">Informatyka, studia magisterskie</p>
          </div>
        </div>
      </div>

      <div id="exp-tab" class="tab-content hidden">
        <div class="space-y-6 animate-fade-in">
          <h2 class="text-4xl font-bold mb-8 text-purple-300">
            Doświadczenie Zawodowe
          </h2>
          <div
            class="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-lg border border-purple-500/20 rounded-xl p-6"
          >
            <h3 class="text-2xl font-bold mb-4 text-purple-300">
              Full Stack Developer
            </h3>
            <p class="text-gray-300 mb-4">
              Specjalizacja w systemach rozproszonych
            </p>
          </div>
        </div>
      </div>

      <div id="skills-tab" class="tab-content hidden">
        <div class="space-y-6 animate-fade-in">
          <h2 class="text-4xl font-bold mb-8 text-purple-300">Umiejętności</h2>
          <div class="grid md:grid-cols-2 gap-6">
            <div
              class="bg-gradient-to-br from-slate-800/50 to-slate-900/50 backdrop-blur-lg border border-purple-500/20 rounded-xl p-6"
            >
              <h3 class="text-2xl font-bold mb-4 text-purple-300">
                Technologie
              </h3>
              <div class="space-y-4">
                <div>
                  <div class="flex justify-between mb-1">
                    <span>FastAPI</span><span>90%</span>
                  </div>
                  <div class="skill-bar">
                    <div
                      class="skill-progress bg-gradient-to-r from-purple-500 to-pink-500"
                      data-width="90%"
                    ></div>
                  </div>
                </div>
                <div>
                  <div class="flex justify-between mb-1">
                    <span>Kubernetes</span><span>85%</span>
                  </div>
                  <div class="skill-bar">
                    <div
                      class="skill-progress bg-gradient-to-r from-purple-500 to-pink-500"
                      data-width="85%"
                    ></div>
                  </div>
                </div>
                <div>
                  <div class="flex justify-between mb-1">
                    <span>PostgreSQL</span><span>88%</span>
                  </div>
                  <div class="skill-bar">
                    <div
                      class="skill-progress bg-gradient-to-r from-purple-500 to-pink-500"
                      data-width="88%"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div id="survey-tab" class="tab-content hidden">
        <div class="space-y-8 animate-fade-in">
          <div
            class="bg-gradient-to-br from-purple-500/10 to-pink-500/10 backdrop-blur-lg border border-purple-500/20 rounded-2xl p-8"
          >
            <h2 class="text-4xl font-bold mb-6 text-purple-300">Ankieta</h2>
            <p class="text-lg text-gray-300 mb-8">
              Twoje odpowiedzi trafią przez Redis i Kafka do bazy PostgreSQL z
              pełnym monitoringiem!
            </p>

            <form id="survey-form" class="space-y-6">
              <div id="survey-questions"></div>
              <button
                type="submit"
                class="w-full py-3 px-4 rounded-lg bg-purple-500 text-white hover:bg-purple-600 transition-all"
              >
                Wyślij ankietę
              </button>
            </form>

            <div id="survey-message" class="mt-4 hidden p-3 rounded-lg"></div>
          </div>

          <div
            class="bg-gradient-to-br from-purple-500/10 to-pink-500/10 backdrop-blur-lg border border-purple-500/20 rounded-2xl p-8"
          >
            <h3 class="text-2xl font-bold mb-6 text-purple-300">
              Statystyki ankiet
            </h3>
            <div class="grid md:grid-cols-2 gap-6">
              <div id="survey-stats"></div>
              <div>
                <canvas id="survey-chart" width="400" height="200"></canvas>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div id="new-survey-tab" class="tab-content hidden">
        <div class="space-y-8 animate-fade-in">
          <div class="new-survey-section">
            <div id="new-survey-container"></div>
          </div>
          <div class="mt-12">
            <div id="survey-stats-container"></div>
          </div>
          <div class="mt-12 grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="bg-gray-800 rounded-xl p-6">
              <h3 class="text-xl font-bold mb-4">⚡ Apache Spark Jobs</h3>
              <div id="spark-jobs" class="space-y-2">
                <div class="animate-pulse">Ładowanie zadań Spark...</div>
              </div>
              <button
                onclick="loadSparkJobs()"
                class="mt-4 px-4 py-2 bg-orange-500 text-white rounded-lg hover:bg-orange-600"
              >
                Odśwież status
              </button>
            </div>
            <div class="bg-gray-800 rounded-xl p-6">
              <h3 class="text-xl font-bold mb-4">
                🔍 Wyszukiwarka Logów (ELK)
              </h3>
              <div class="flex gap-2 mb-4">
                <input
                  type="text"
                  id="log-search"
                  placeholder="Szukaj w logach..."
                  class="flex-1 px-4 py-2 bg-gray-700 text-white rounded-lg"
                />
                <button
                  onclick="searchLogs()"
                  class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600"
                >
                  Szukaj
                </button>
              </div>
              <div
                id="logs-results"
                class="space-y-2 max-h-60 overflow-y-auto"
              ></div>
            </div>
          </div>
        </div>
      </div>

      <div id="contact-tab" class="tab-content hidden">
        <div class="space-y-8 animate-fade-in">
          <div
            class="bg-gradient-to-br from-purple-500/10 to-pink-500/10 backdrop-blur-lg border border-purple-500/20 rounded-2xl p-8"
          >
            <h2 class="text-4xl font-bold mb-6 text-purple-300">Kontakt</h2>
            <div class="grid md:grid-cols-2 gap-6">
              <div class="space-y-4">
                <form id="contact-form">
                  <div>
                    <input
                      type="email"
                      name="email"
                      placeholder="Twój email"
                      class="w-full py-3 px-4 rounded-lg bg-slate-700 text-white border border-purple-500/30"
                      required
                    />
                  </div>
                  <div>
                    <textarea
                      name="message"
                      placeholder="Twoja wiadomość"
                      rows="4"
                      class="w-full py-3 px-4 rounded-lg bg-slate-700 text-white border border-purple-500/30"
                      required
                    ></textarea>
                  </div>
                  <button
                    type="submit"
                    class="w-full mt-4 py-3 px-4 rounded-lg bg-purple-500 text-white hover:bg-purple-600 transition-all"
                  >
                    Wyślij
                  </button>
                </form>
                <div id="form-message" class="mt-4 hidden p-3 rounded-lg"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <script>
      function showTab(tabName) {
          document.querySelectorAll(".tab-content").forEach((tab) => {
              tab.classList.add("hidden");
              tab.classList.remove("animate-fade-in");
          });
          setTimeout(() => {
              const activeTab = document.getElementById(tabName + "-tab");
              activeTab.classList.remove("hidden");
              activeTab.classList.add("animate-fade-in");
              if (tabName === "skills") setTimeout(animateSkillBars, 300);
              if (tabName === "survey") { loadSurveyQuestions(); loadSurveyStats(); }
              if (tabName === "new-survey") {
                  surveyApp.loadQuestions();
                  surveyApp.loadStats();
                  loadSparkJobs();
              }
          }, 50);
          document.querySelectorAll(".tab-btn").forEach((btn) => {
              btn.classList.remove("bg-purple-500", "text-white");
              btn.classList.add("text-purple-300");
          });
          document.querySelector(`[data-tab="${tabName}"]`).classList.add("bg-purple-500", "text-white");
      }

      function animateSkillBars() {
          document.querySelectorAll(".skill-progress").forEach((bar) => {
              bar.style.width = bar.getAttribute("data-width");
          });
      }

      async function loadSurveyQuestions() {
          try {
              const response = await fetch('/api/survey/questions');
              const questions = await response.json();
              const container = document.getElementById('survey-questions');
              container.innerHTML = '';
              questions.forEach((q, index) => {
                  const questionDiv = document.createElement('div');
                  questionDiv.className = 'space-y-3';
                  questionDiv.innerHTML = `<label class="block text-gray-300 font-semibold">${q.text}</label>`;
                  if (q.type === 'rating') {
                      questionDiv.innerHTML += `<div class="flex gap-2 flex-wrap">${q.options.map(option => `
                          <label class="flex items-center space-x-2 cursor-pointer">
                              <input type="radio" name="question_${q.id}" value="${option}" class="hidden peer" required>
                              <span class="px-4 py-2 rounded-lg bg-slate-700 text-gray-300 peer-checked:bg-purple-500 peer-checked:text-white transition-all">${option}</span>
                          </label>`).join('')}</div>`;
                  } else if (q.type === 'text') {
                      questionDiv.innerHTML += `<textarea name="question_${q.id}" placeholder="${q.placeholder}" class="w-full py-3 px-4 rounded-lg bg-slate-700 text-white border border-purple-500/30" rows="3"></textarea>`;
                  }
                  container.appendChild(questionDiv);
              });
          } catch (error) {
              console.error('Error loading survey questions:', error);
          }
      }

      async function loadSurveyStats() {
          try {
              const response = await fetch('/api/survey/stats');
              const stats = await response.json();
              const container = document.getElementById('survey-stats');
              if (stats.total_responses === 0) {
                  container.innerHTML = '<div class="text-center text-gray-400 py-8">Brak odpowiedzi na ankietę.</div>';
                  return;
              }
              let statsHTML = `<div class="space-y-4"><div class="grid grid-cols-2 gap-4 text-center">
                  <div class="bg-slate-800/50 rounded-lg p-4"><div class="text-2xl font-bold text-purple-300">${stats.total_visits}</div><div class="text-sm text-gray-400">Odwiedzin</div></div>
                  <div class="bg-slate-800/50 rounded-lg p-4"><div class="text-2xl font-bold text-purple-300">${stats.total_responses}</div><div class="text-sm text-gray-400">Odpowiedzi</div></div></div>`;
              for (const [question, answers] of Object.entries(stats.survey_responses)) {
                  statsHTML += `<div class="border-t border-purple-500/20 pt-4"><h4 class="font-semibold text-purple-300 mb-2">${question}</h4><div class="space-y-2">`;
                  answers.forEach(item => {
                      statsHTML += `<div class="flex justify-between items-center"><span class="text-gray-300 text-sm">${item.answer}</span><span class="text-purple-300 font-semibold">${item.count}</span></div>`;
                  });
                  statsHTML += `</div></div>`;
              }
              statsHTML += `</div>`;
              container.innerHTML = statsHTML;
              updateSurveyChart(stats);
          } catch (error) {
              console.error('Error loading survey stats:', error);
          }
      }

      function updateSurveyChart(stats) {
          const ctx = document.getElementById('survey-chart').getContext('2d');
          const labels = []; const data = [];
          for (const [question, answers] of Object.entries(stats.survey_responses)) {
              answers.forEach(item => { labels.push(`${question}: ${item.answer}`); data.push(item.count); });
          }
          new Chart(ctx, {
              type: 'doughnut',
              data: { labels: labels, datasets: [{ data: data, backgroundColor: ['#a855f7','#ec4899','#8b5cf6','#d946ef','#7c3aed'] }] },
              options: { responsive: true, plugins: { legend: { position: 'bottom', labels: { color: '#cbd5e1', font: { size: 10 } } } } }
          });
      }

      document.getElementById('survey-form').addEventListener('submit', async (e) => {
          e.preventDefault();
          const responses = [];
          for (let i = 1; i <= 5; i++) {
              const questionElement = e.target.elements[`question_${i}`];
              if (questionElement) {
                  if (questionElement.type === 'radio') {
                      const selected = document.querySelector(`input[name="question_${i}"]:checked`);
                      if (selected) responses.push({ question: `Pytanie ${i}`, answer: selected.value });
                  } else if (questionElement.tagName === 'TEXTAREA' && questionElement.value.trim()) {
                      responses.push({ question: `Pytanie ${i}`, answer: questionElement.value.trim() });
                  }
              }
          }
          if (responses.length === 0) { showSurveyMessage('Proszę odpowiedzieć na przynajmniej jedno pytanie', 'error'); return; }
          try {
              for (const response of responses) {
                  await fetch('/api/survey/submit', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(response) });
              }
              showSurveyMessage('Dziękujemy za wypełnienie ankiety!', 'success');
              e.target.reset(); loadSurveyStats();
          } catch (error) {
              console.error('Error submitting survey:', error);
              showSurveyMessage('Wystąpił błąd podczas wysyłania ankiety', 'error');
          }
      });

      function showSurveyMessage(text, type) {
          const messageDiv = document.getElementById('survey-message');
          messageDiv.textContent = text;
          messageDiv.className = 'mt-4 p-3 rounded-lg';
          messageDiv.classList.add(type === 'error' ? 'bg-red-500/20 text-red-300 border border-red-500/30' : 'bg-green-500/20 text-green-300 border border-green-500/30');
          messageDiv.classList.remove('hidden');
          setTimeout(() => { messageDiv.classList.add('hidden'); }, 5000);
      }

      async function loadSparkJobs() {
          try {
              const response = await fetch('/api/v2/spark/jobs');
              const jobs = await response.json();

              const container = document.getElementById('spark-jobs');
              if (jobs.length === 0) {
                  container.innerHTML = '<div class="text-gray-400">Brak aktywnych zadań Spark</div>';
                  return;
              }

              container.innerHTML = jobs.map(job => `
                  <div class="p-3 bg-gray-900 rounded-lg">
                      <div class="flex justify-between items-center">
                          <span class="font-medium">${job.name}</span>
                          <span class="px-2 py-1 text-xs rounded ${job.state === 'RUNNING' ? 'bg-green-500' : 'bg-yellow-500'}">
                              ${job.state}
                          </span>
                      </div>
                      <div class="text-sm text-gray-400 mt-1">ID: ${job.id}</div>
                  </div>
              `).join('');
          } catch (error) {
              console.error('Error loading Spark jobs:', error);
              document.getElementById('spark-jobs').innerHTML =
                  '<div class="text-red-400">Błąd ładowania zadań Spark</div>';
          }
      }

      async function searchLogs() {
          const query = document.getElementById('log-search').value;

          try {
              const response = await fetch(`/api/v2/elk/logs?query=${encodeURIComponent(query)}`);
              const data = await response.json();

              const container = document.getElementById('logs-results');
              const hits = data.hits?.hits || [];

              if (hits.length === 0) {
                  container.innerHTML = '<div class="text-gray-400">Brak wyników</div>';
                  return;
              }

              container.innerHTML = hits.map(hit => {
                  const source = hit._source;
                  return `
                      <div class="p-3 bg-gray-900 rounded-lg">
                          <div class="text-sm font-medium">${source.message || 'Brak wiadomości'}</div>
                          <div class="text-xs text-gray-400 mt-1">
                              ${source['@timestamp'] || new Date().toISOString()}
                          </div>
                          ${source.level ? `<span class="text-xs px-2 py-1 rounded ${source.level === 'ERROR' ? 'bg-red-500' : 'bg-blue-500'}">${source.level}</span>` : ''}
                      </div>
                  `;
              }).join('');
          } catch (error) {
              console.error('Error searching logs:', error);
              document.getElementById('logs-results').innerHTML =
                  '<div class="text-red-400">Błąd wyszukiwania logów</div>';
          }
      }

      document.getElementById('contact-form').addEventListener('submit', async (e) => {
          e.preventDefault();
          const formData = new FormData(e.target);
          try {
              const response = await fetch('/api/contact', { method: 'POST', body: formData });
              const result = await response.json();
              showFormMessage(result.message, response.ok ? "success" : "error");
              if (response.ok) e.target.reset();
          } catch (error) {
              console.error('Error sending contact form:', error);
              showFormMessage("Wystąpił błąd podczas wysyłania wiadomości", "error");
          }
      });

      function showFormMessage(text, type) {
          const formMessage = document.getElementById('form-message');
          formMessage.textContent = text;
          formMessage.className = "mt-4 p-3 rounded-lg";
          formMessage.classList.add(type === "error" ? "bg-red-500/20 text-red-300 border border-red-500/30" : "bg-green-500/20 text-green-300 border border-green-500/30");
          formMessage.classList.remove("hidden");
          setTimeout(() => { formMessage.classList.add("hidden"); }, 5000);
      }

      document.addEventListener("DOMContentLoaded", () => {
          showTab("intro");
          // Ładujemy statystyki co 30 sekund
          setInterval(() => {
              if (!document.getElementById('new-survey-tab').classList.contains('hidden')) {
                  surveyApp.loadStats();
              }
          }, 30000);
      });
    </script>
    <script src="/static/js/new-survey.js"></script>
    <link rel="stylesheet" href="/static/css/new-survey.css" />
  </body>
</html>
EOF

echo "Created index.html"

# ============================================
# 2. Create new-survey.js
# ============================================
cat > static/js/new-survey.js << 'EOF'
// static/js/new-survey.js

const surveyApp = {
    currentSurvey: null,
    
    async loadQuestions() {
        try {
            const response = await fetch('/api/v2/survey/questions');
            const questions = await response.json();
            this.renderQuestions(questions);
        } catch (error) {
            console.error('Failed to load questions:', error);
            this.showError('Nie udało się załadować pytań ankietowych.');
        }
    },
    
    renderQuestions(questions) {
        const container = document.getElementById('new-survey-container');
        if (!container) return;
        
        let html = `
            <div class="bg-gradient-to-br from-blue-500/10 to-cyan-500/10 backdrop-blur-lg border border-blue-500/20 rounded-2xl p-8">
                <h2 class="text-4xl font-bold mb-6 text-blue-300">
                    📊 Nowa Ankieta (Spring + MongoDB + Spark)
                </h2>
                <p class="text-lg text-gray-300 mb-8">
                    Twoje odpowiedzi będą przetwarzane przez Apache Spark i przechowywane w MongoDB!
                </p>
                
                <form id="new-survey-form" class="space-y-8">
                    <div class="grid md:grid-cols-2 gap-6">
        `;
        
        questions.forEach((question, index) => {
            html += this.renderQuestion(question, index);
        });
        
        html += `
                    </div>
                    
                    <div class="mt-8">
                        <button type="submit" 
                                class="w-full py-4 px-6 rounded-xl bg-gradient-to-r from-blue-500 to-cyan-500 
                                       text-white font-bold text-lg hover:opacity-90 transition-all 
                                       flex items-center justify-center gap-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                                      d="M13 10V3L4 14h7v7l9-11h-7z"/>
                            </svg>
                            Wyślij ankietę (Apache Spark)
                        </button>
                    </div>
                </form>
                
                <div id="new-survey-message" class="mt-6 hidden p-4 rounded-lg"></div>
            </div>
        `;
        
        container.innerHTML = html;
        
        // Attach form handler
        const form = document.getElementById('new-survey-form');
        if (form) {
            form.addEventListener('submit', (e) => this.handleSubmit(e));
        }
    },
    
    renderQuestion(question, index) {
        let inputHtml = '';
        
        switch(question.type) {
            case 'RATING':
                inputHtml = this.renderRatingQuestion(question);
                break;
            case 'MULTIPLE_CHOICE':
                inputHtml = this.renderMultipleChoiceQuestion(question);
                break;
            case 'TEXT':
                inputHtml = this.renderTextQuestion(question);
                break;
            case 'BOOLEAN':
                inputHtml = this.renderBooleanQuestion(question);
                break;
        }
        
        return `
            <div class="space-y-4 p-6 bg-slate-800/50 rounded-xl border border-blue-500/20">
                <div class="flex items-start gap-3">
                    <span class="flex-shrink-0 w-8 h-8 bg-blue-500 rounded-full 
                                 flex items-center justify-center text-white font-bold">
                        ${index + 1}
                    </span>
                    <div class="flex-1">
                        <h3 class="text-xl font-bold text-blue-300 mb-2">
                            ${question.questionText}
                        </h3>
                        ${inputHtml}
                    </div>
                </div>
            </div>
        `;
    },
    
    renderRatingQuestion(question) {
        return `
            <div class="rating-buttons flex gap-2">
                ${[1,2,3,4,5].map(num => `
                    <label class="cursor-pointer">
                        <input type="radio" name="question_${question.id}" 
                               value="${num}" class="hidden peer" required>
                        <span class="w-12 h-12 flex items-center justify-center 
                                     bg-slate-700 rounded-lg text-gray-300 
                                     peer-checked:bg-gradient-to-r peer-checked:from-blue-500 
                                     peer-checked:to-cyan-500 peer-checked:text-white 
                                     transition-all hover:scale-105">
                            ${num}
                        </span>
                    </label>
                `).join('')}
            </div>
        `;
    },
    
    renderMultipleChoiceQuestion(question) {
        return `
            <div class="space-y-2">
                ${question.options.map(option => `
                    <label class="flex items-center space-x-3 p-3 bg-slate-700/50 
                                   rounded-lg cursor-pointer hover:bg-slate-700 transition-colors">
                        <input type="radio" name="question_${question.id}" 
                               value="${option}" class="h-5 w-5 text-blue-500">
                        <span class="text-gray-300">${option}</span>
                    </label>
                `).join('')}
            </div>
        `;
    },
    
    renderTextQuestion(question) {
        return `
            <textarea name="question_${question.id}" 
                      placeholder="${question.placeholder || 'Twoja odpowiedź...'}"
                      class="w-full h-32 p-4 bg-slate-700 border border-blue-500/30 
                             rounded-lg text-white resize-none focus:ring-2 
                             focus:ring-blue-500 focus:border-transparent"
                      required></textarea>
        `;
    },
    
    renderBooleanQuestion(question) {
        return `
            <div class="flex gap-4">
                <label class="flex-1">
                    <input type="radio" name="question_${question.id}" 
                           value="true" class="hidden peer" required>
                    <span class="block p-4 text-center bg-slate-700 rounded-lg 
                                 peer-checked:bg-green-500/20 peer-checked:border 
                                 peer-checked:border-green-500 peer-checked:text-green-300
                                 hover:bg-slate-600 transition-all">
                        ✅ Tak
                    </span>
                </label>
                <label class="flex-1">
                    <input type="radio" name="question_${question.id}" 
                           value="false" class="hidden peer" required>
                    <span class="block p-4 text-center bg-slate-700 rounded-lg 
                                 peer-checked:bg-red-500/20 peer-checked:border 
                                 peer-checked:border-red-500 peer-checked:text-red-300
                                 hover:bg-slate-600 transition-all">
                        ❌ Nie
                    </span>
                </label>
            </div>
        `;
    },
    
    async handleSubmit(event) {
        event.preventDefault();
        const form = event.target;
        const formData = new FormData(form);
        const responses = {};
        
        // Collect responses
        for (const [name, value] of formData.entries()) {
            if (name.startsWith('question_')) {
                const questionId = name.replace('question_', '');
                responses[questionId] = value;
            }
        }
        
        // Show loading state
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = `
            <div class="flex items-center justify-center gap-2">
                <div class="w-5 h-5 border-2 border-white border-t-transparent 
                            rounded-full animate-spin"></div>
                Przetwarzanie przez Spark...
            </div>
        `;
        submitBtn.disabled = true;
        
        try {
            const response = await fetch('/api/v2/survey/submit', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(responses)
            });
            
            if (response.ok) {
                const result = await response.json();
                this.showMessage('✅ Ankieta została wysłana! Dane są przetwarzane przez Apache Spark.', 'success');
                form.reset();
                this.loadStats(); // Refresh stats
                
                // Trigger Spark job status update
                setTimeout(() => loadSparkJobs(), 2000);
                
            } else {
                throw new Error('Server error');
            }
            
        } catch (error) {
            console.error('Survey submission error:', error);
            this.showMessage('❌ Wystąpił błąd podczas wysyłania ankiety.', 'error');
            
        } finally {
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
        }
    },
    
    async loadStats() {
        try {
            const response = await fetch('/api/v2/survey/stats');
            const stats = await response.json();
            this.renderStats(stats);
        } catch (error) {
            console.error('Failed to load stats:', error);
        }
    },
    
    renderStats(stats) {
        const container = document.getElementById('survey-stats-container');
        if (!container) return;
        
        let html = `
            <div class="bg-gradient-to-br from-green-500/10 to-emerald-500/10 
                        backdrop-blur-lg border border-green-500/20 rounded-2xl p-8">
                <div class="flex items-center justify-between mb-6">
                    <h3 class="text-2xl font-bold text-green-300">
                        📈 Statystyki (Apache Spark + MongoDB)
                    </h3>
                    <span class="text-sm text-gray-400">
                        Ostatnia aktualizacja: ${new Date().toLocaleTimeString()}
                    </span>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
                    <div class="bg-slate-800/50 rounded-xl p-4 text-center">
                        <div class="text-3xl font-bold text-green-400">
                            ${stats.total_responses || 0}
                        </div>
                        <div class="text-sm text-gray-400 mt-1">Odpowiedzi</div>
                    </div>
                    
                    <div class="bg-slate-800/50 rounded-xl p-4 text-center">
                        <div class="text-3xl font-bold text-blue-400">
                            ${stats.active_jobs || 0}
                        </div>
                        <div class="text-sm text-gray-400 mt-1">Zadań Spark</div>
                    </div>
                    
                    <div class="bg-slate-800/50 rounded-xl p-4 text-center">
                        <div class="text-3xl font-bold text-purple-400">
                            ${stats.avg_processing_time ? stats.avg_processing_time.toFixed(2) + 's' : 'N/A'}
                        </div>
                        <div class="text-sm text-gray-400 mt-1">Śr. czas przetwarzania</div>
                    </div>
                    
                    <div class="bg-slate-800/50 rounded-xl p-4 text-center">
                        <div class="text-3xl font-bold text-yellow-400">
                            ${stats.success_rate ? stats.success_rate + '%' : '100%'}
                        </div>
                        <div class="text-sm text-gray-400 mt-1">Skuteczność</div>
                    </div>
                </div>
        `;
        
        if (stats.aggregations && stats.aggregations.length > 0) {
            html += `
                <div class="mt-6">
                    <h4 class="text-lg font-bold text-gray-300 mb-4">Agregacje Spark:</h4>
                    <div class="space-y-3 max-h-80 overflow-y-auto">
            `;
            
            stats.aggregations.forEach((agg, index) => {
                html += `
                    <div class="p-3 bg-slate-800/30 rounded-lg">
                        <div class="flex justify-between items-center">
                            <span class="text-sm text-gray-300">${JSON.stringify(agg.answers)}</span>
                            <span class="font-bold text-green-400">${agg.response_count} odpowiedzi</span>
                        </div>
                        ${agg.avg_processing_time ? 
                            `<div class="text-xs text-gray-400 mt-1">
                                Średni czas: ${agg.avg_processing_time.toFixed(3)}s
                            </div>` : ''}
                    </div>
                `;
            });
            
            html += `</div></div>`;
        }
        
        html += `</div>`;
        container.innerHTML = html;
    },
    
    showMessage(text, type) {
        const messageDiv = document.getElementById('new-survey-message');
        if (!messageDiv) return;
        
        messageDiv.textContent = text;
        messageDiv.className = 'mt-6 p-4 rounded-lg';
        
        if (type === 'success') {
            messageDiv.classList.add('bg-green-500/20', 'text-green-300', 
                                     'border', 'border-green-500/30');
        } else {
            messageDiv.classList.add('bg-red-500/20', 'text-red-300', 
                                     'border', 'border-red-500/30');
        }
        
        messageDiv.classList.remove('hidden');
        
        setTimeout(() => {
            messageDiv.classList.add('hidden');
        }, 5000);
    },
    
    showError(text) {
        this.showMessage(text, 'error');
    }
};

// Global functions for Spark and ELK
window.loadSparkJobs = async function() {
    try {
        const response = await fetch('/api/v2/spark/jobs');
        const jobs = await response.json();

        const container = document.getElementById('spark-jobs');
        if (!container) return;

        if (jobs.length === 0) {
            container.innerHTML = `
                <div class="text-center text-gray-400 py-4">
                    Brak aktywnych zadań Spark
                </div>
            `;
            return;
        }

        container.innerHTML = jobs.map(job => `
            <div class="p-4 bg-gray-900/50 rounded-lg border 
                        ${job.state === 'RUNNING' ? 'border-green-500/30' : 
                          job.state === 'COMPLETED' ? 'border-blue-500/30' : 
                          'border-red-500/30'}">
                <div class="flex justify-between items-center mb-2">
                    <span class="font-bold text-white">${job.name}</span>
                    <span class="px-3 py-1 text-xs rounded-full 
                                ${job.state === 'RUNNING' ? 'bg-green-500' : 
                                  job.state === 'COMPLETED' ? 'bg-blue-500' : 
                                  'bg-red-500'}">
                        ${job.state}
                    </span>
                </div>
                <div class="text-sm text-gray-400 mb-1">ID: ${job.id}</div>
                ${job.startedAt ? `
                    <div class="text-xs text-gray-500">
                        Rozpoczęto: ${new Date(job.startedAt).toLocaleTimeString()}
                    </div>
                ` : ''}
                ${job.responseId ? `
                    <div class="text-xs text-gray-500 truncate">
                        Response: ${job.responseId.substring(0, 8)}...
                    </div>
                ` : ''}
            </div>
        `).join('');

    } catch (error) {
        console.error('Error loading Spark jobs:', error);
        document.getElementById('spark-jobs').innerHTML = `
            <div class="text-red-400 p-4 bg-red-500/10 rounded-lg">
                Błąd ładowania zadań Spark
            </div>
        `;
    }
};

window.searchLogs = async function() {
    const query = document.getElementById('log-search').value.trim();
    if (!query) return;

    const searchBtn = document.querySelector('#logs-results + button');
    const originalText = searchBtn?.innerHTML;
    if (searchBtn) {
        searchBtn.innerHTML = `
            <div class="flex items-center gap-2">
                <div class="w-4 h-4 border-2 border-white border-t-transparent 
                            rounded-full animate-spin"></div>
                Szukanie...
            </div>
        `;
        searchBtn.disabled = true;
    }

    try {
        const response = await fetch(`/api/v2/elk/logs?query=${encodeURIComponent(query)}&size=5`);
        const data = await response.json();

        const container = document.getElementById('logs-results');
        if (!container) return;

        const hits = data.hits?.hits || [];

        if (hits.length === 0) {
            container.innerHTML = `
                <div class="text-center text-gray-400 py-4">
                    Brak wyników dla: "${query}"
                </div>
            `;
            return;
        }

        container.innerHTML = hits.map((hit, index) => {
            const source = hit._source;
            const level = source.level || 'INFO';
            const levelColors = {
                'ERROR': 'bg-red-500',
                'WARN': 'bg-yellow-500',
                'INFO': 'bg-blue-500',
                'DEBUG': 'bg-gray-500'
            };

            return `
                <div class="p-4 bg-gray-900/50 rounded-lg border border-gray-700">
                    <div class="flex justify-between items-start mb-2">
                        <span class="font-mono text-sm text-white truncate">
                            ${source.message || source.log || 'Brak wiadomości'}
                        </span>
                        <span class="px-2 py-1 text-xs rounded-full ${levelColors[level] || 'bg-gray-500'}">
                            ${level}
                        </span>
                    </div>
                    <div class="text-xs text-gray-400 flex justify-between">
                        <span>${source['@timestamp'] ? 
                            new Date(source['@timestamp']).toLocaleString() : 
                            'Brak daty'}</span>
                        <span class="font-mono">${source.logger || 'unknown'}</span>
                    </div>
                    ${source.service_name ? `
                        <div class="text-xs text-gray-500 mt-1">
                            Service: ${source.service_name}
                        </div>
                    ` : ''}
                </div>
            `;
        }).join('');

    } catch (error) {
        console.error('Error searching logs:', error);
        document.getElementById('logs-results').innerHTML = `
            <div class="text-red-400 p-4 bg-red-500/10 rounded-lg">
                Błąd wyszukiwania logów: ${error.message}
            </div>
        `;
    } finally {
        if (searchBtn) {
            searchBtn.innerHTML = originalText;
            searchBtn.disabled = false;
        }
    }
};

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    // Auto-refresh Spark jobs every 10 seconds if on new-survey tab
    setInterval(() => {
        if (!document.getElementById('new-survey-tab')?.classList.contains('hidden')) {
            loadSparkJobs();
            surveyApp.loadStats();
        }
    }, 10000);
});
EOF

echo "Created static/js/new-survey.js"

# ============================================
# 3. Create new-survey.css
# ============================================
cat > static/css/new-survey.css << 'EOF'
/* static/css/new-survey.css */

.new-survey-section {
    animation: slideUp 0.5s ease-out;
}

@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Spark job status animations */
@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
}

.spark-job-running {
    animation: pulse 2s infinite;
}

/* Log entries styling */
.log-entry {
    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
    font-size: 12px;
    transition: all 0.2s;
}

.log-entry:hover {
    background: rgba(59, 130, 246, 0.1);
    border-color: #3b82f6;
}

/* Rating stars animation */
.rating-buttons label span {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.rating-buttons label span:hover {
    transform: scale(1.1);
    box-shadow: 0 0 15px rgba(59, 130, 246, 0.5);
}

/* Form focus states */
#new-survey-form input:focus,
#new-survey-form textarea:focus {
    outline: none;
    ring: 2px;
    ring-color: #3b82f6;
}

/* Scrollbar styling */
#logs-results::-webkit-scrollbar {
    width: 6px;
}

#logs-results::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 3px;
}

#logs-results::-webkit-scrollbar-thumb {
    background: rgba(59, 130, 246, 0.5);
    border-radius: 3px;
}

/* Stats cards hover effects */
.bg-slate-800\/50 {
    transition: all 0.3s;
}

.bg-slate-800\/50:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
}

/* Progress bar for processing time */
.processing-bar {
    height: 4px;
    background: linear-gradient(90deg, #3b82f6, #06b6d4);
    border-radius: 2px;
    width: 0;
    transition: width 1s ease-in-out;
}
EOF

echo "Created static/css/new-survey.css"

# ============================================
# 4. Create Spring Boot Application Files
# ============================================

# SpringSurveyApplication.java
cat > spring-app/src/main/java/com/dawidtrojanowski/SpringSurveyApplication.java << 'EOF'
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
EOF

# SurveyQuestion.java
cat > spring-app/src/main/java/com/dawidtrojanowski/model/SurveyQuestion.java << 'EOF'
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
EOF

# SurveyResponse.java
cat > spring-app/src/main/java/com/dawidtrojanowski/model/SurveyResponse.java << 'EOF'
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
EOF

# SurveyController.java
cat > spring-app/src/main/java/com/dawidtrojanowski/controller/SurveyController.java << 'EOF'
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
EOF

# SurveyService.java
cat > spring-app/src/main/java/com/dawidtrojanowski/service/SurveyService.java << 'EOF'
package com.dawidtrojanowski.service;

import com.dawidtrojanowski.model.SurveyQuestion;
import com.dawidtrojanowski.model.SurveyResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Service
public class SurveyService {
    
    public List<SurveyQuestion> getActiveQuestions() {
        List<SurveyQuestion> questions = new ArrayList<>();
        
        // Sample questions
        for (int i = 1; i <= 5; i++) {
            SurveyQuestion question = new SurveyQuestion();
            question.setId("q" + i);
            question.setQuestionText("Pytanie " + i + ": Jak oceniasz naszą usługę?");
            question.setType(SurveyQuestion.QuestionType.RATING);
            question.setOptions(new String[]{"1", "2", "3", "4", "5"});
            question.setOrder(i);
            question.setActive(true);
            question.setCreatedAt(LocalDateTime.now());
            question.setUpdatedAt(LocalDateTime.now());
            questions.add(question);
        }
        
        return questions;
    }
    
    public SurveyResponse saveResponse(Map<String, Object> responses, String userAgent, String ipAddress) {
        SurveyResponse response = new SurveyResponse();
        response.setId(UUID.randomUUID().toString());
        response.setSessionId(UUID.randomUUID().toString());
        response.setUserId("anonymous");
        response.setAnswers(responses);
        response.setSubmittedAt(LocalDateTime.now());
        response.setUserAgent(userAgent);
        response.setIpAddress(ipAddress);
        
        SurveyResponse.Metadata metadata = new SurveyResponse.Metadata();
        metadata.setBrowser(userAgent != null && userAgent.contains("Chrome") ? "Chrome" : "Other");
        metadata.setOs(userAgent != null && userAgent.contains("Windows") ? "Windows" : "Other");
        metadata.setDevice("Desktop");
        metadata.setProcessingTime(0.5);
        metadata.setSparkJobId(UUID.randomUUID().toString());
        
        response.setMetadata(metadata);
        
        log.info("Saved survey response: {}", response.getId());
        return response;
    }
    
    public Map<String, Object> searchLogs(String query, int from, int size) {
        // Simulated log search
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> hits = new HashMap<>();
        
        List<Map<String, Object>> hitList = new ArrayList<>();
        Map<String, Object> hit = new HashMap<>();
        Map<String, Object> source = new HashMap<>();
        
        source.put("message", "Sample log entry for query: " + query);
        source.put("@timestamp", LocalDateTime.now().toString());
        source.put("level", "INFO");
        source.put("logger", "SurveyController");
        
        hit.put("_source", source);
        hitList.add(hit);
        
        hits.put("hits", hitList);
        result.put("hits", hits);
        
        return result;
    }
}
EOF

# MongoDBService.java
cat > spring-app/src/main/java/com/dawidtrojanowski/service/MongoDBService.java << 'EOF'
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
EOF

# SparkService.java
cat > spring-app/src/main/java/com/dawidtrojanowski/service/SparkService.java << 'EOF'
package com.dawidtrojanowski.service;

import com.dawidtrojanowski.model.SurveyResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.spark.sql.*;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Service
@RequiredArgsConstructor
public class SparkService {
    
    private final KafkaTemplate<String, String> kafkaTemplate;
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
EOF

# ElasticsearchConfig.java
cat > spring-app/src/main/java/com/dawidtrojanowski/config/ElasticsearchConfig.java << 'EOF'
package com.dawidtrojanowski.config;

import org.springframework.context.annotation.Configuration;

@Configuration
public class ElasticsearchConfig {
    // Simple configuration - Elasticsearch connectivity will be handled
    // via environment properties in application-k8s.yml
}
EOF

# KafkaConfig.java
cat > spring-app/src/main/java/com/dawidtrojanowski/config/KafkaConfig.java << 'EOF'
package com.dawidtrojanowski.config;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.*;
import org.springframework.kafka.support.serializer.JsonDeserializer;
import org.springframework.kafka.support.serializer.JsonSerializer;
import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableKafka
public class KafkaConfig {
    
    @Bean
    public ProducerFactory<String, Object> producerFactory() {
        Map<String, Object> config = new HashMap<>();
        config.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka-broker:9092");
        config.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        config.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
        config.put(ProducerConfig.ACKS_CONFIG, "all");
        return new DefaultKafkaProducerFactory<>(config);
    }
    
    @Bean
    public KafkaTemplate<String, Object> kafkaTemplate() {
        return new KafkaTemplate<>(producerFactory());
    }
    
    @Bean
    public ConsumerFactory<String, Object> consumerFactory() {
        Map<String, Object> config = new HashMap<>();
        config.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka-broker:9092");
        config.put(ConsumerConfig.GROUP_ID_CONFIG, "survey-group");
        config.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        
        JsonDeserializer<Object> deserializer = new JsonDeserializer<>();
        deserializer.addTrustedPackages("*");
        
        return new DefaultKafkaConsumerFactory<>(
            config,
            new StringDeserializer(),
            deserializer
        );
    }
    
    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, Object> kafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, Object> factory = 
            new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactory());
        factory.setConcurrency(3);
        return factory;
    }
}
EOF

# application-k8s.yml
cat > spring-app/src/main/resources/application-k8s.yml << 'EOF'
server:
  port: 8080
  servlet:
    context-path: /

spring:
  application:
    name: survey-api
  data:
    mongodb:
      uri: mongodb://${MONGODB_URI:mongodb-service:27017}/surveys
      auto-index-creation: true
  kafka:
    bootstrap-servers: ${KAFKA_BOOTSTRAP_SERVERS:kafka-broker:9092}
    producer:
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
      value-serializer: org.springframework.kafka.support.serializer.JsonSerializer
    consumer:
      group-id: survey-group
      auto-offset-reset: earliest
      key-deserializer: org.apache.kafka.common.serialization.StringDeserializer
      value-deserializer: org.springframework.kafka.support.serializer.JsonDeserializer
      properties:
        spring.json.trusted.packages: "*"
  elasticsearch:
    rest:
      uris: http://${ELASTICSEARCH_HOST:elasticsearch-service:9200}

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: always
  metrics:
    export:
      prometheus:
        enabled: true

logging:
  level:
    com.dawidtrojanowski: DEBUG
    org.springframework.kafka: INFO
    org.apache.spark: WARN
  file:
    name: /var/log/spring-app.log
  logstash:
    host: logstash-service
    port: 5000
    enabled: true
EOF

# Dockerfile
cat > spring-app/Dockerfile << 'EOF'
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy jar file
COPY target/spring-survey-api.jar app.jar

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

# pom.xml
cat > spring-app/pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.dawidtrojanowski</groupId>
    <artifactId>spring-survey-api</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.1.5</version>
    </parent>

    <properties>
        <java.version>17</java.version>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <spring-kafka.version>3.1.0</spring-kafka.version>
        <spark.version>3.5.0</spark.version>
        <mongodb-driver.version>4.11.1</mongodb-driver.version>
        <elasticsearch.version>8.12.0</elasticsearch.version>
    </properties>

    <dependencies>
        <!-- Spring Boot Starters -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-mongodb</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        
        <!-- Kafka -->
        <dependency>
            <groupId>org.springframework.kafka</groupId>
            <artifactId>spring-kafka</artifactId>
        </dependency>
        
        <!-- Apache Spark -->
        <dependency>
            <groupId>org.apache.spark</groupId>
            <artifactId>spark-core_2.13</artifactId>
            <version>${spark.version}</version>
            <exclusions>
                <exclusion>
                    <groupId>org.slf4j</groupId>
                    <artifactId>slf4j-log4j12</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
        <dependency>
            <groupId>org.apache.spark</groupId>
            <artifactId>spark-sql_2.13</artifactId>
            <version>${spark.version}</version>
        </dependency>
        <dependency>
            <groupId>org.mongodb.spark</groupId>
            <artifactId>mongo-spark-connector_2.13</artifactId>
            <version>10.2.0</version>
        </dependency>
        
        <!-- Elasticsearch -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
        </dependency>
        
        <!-- Utilities -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        
        <!-- Monitoring -->
        <dependency>
            <groupId>io.micrometer</groupId>
            <artifactId>micrometer-registry-prometheus</artifactId>
        </dependency>
        
        <!-- Testing -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </exclude>
                    </excludes>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <annotationProcessorPaths>
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                        </path>
                    </annotationProcessorPaths>
                </configuration>
            </plugin>
        </plugins>
        <finalName>spring-survey-api</finalName>
    </build>
</project>
EOF

echo "Created Spring Boot application files"

# ============================================
# 5. Create FIXED Kubernetes Manifests
# ============================================

# Create missing dependencies first
cat > k8s/kafka-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kafka
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kafka
  template:
    metadata:
      labels:
        app: kafka
    spec:
      containers:
      - name: kafka
        image: confluentinc/cp-kafka:7.4.0
        env:
        - name: KAFKA_BROKER_ID
          value: "1"
        - name: KAFKA_ZOOKEEPER_CONNECT
          value: "localhost:2181"
        - name: KAFKA_ADVERTISED_LISTENERS
          value: "PLAINTEXT://kafka-broker:9092"
        - name: KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR
          value: "1"
        ports:
        - containerPort: 9092
---
apiVersion: v1
kind: Service
metadata:
  name: kafka-broker
  namespace: ${NAMESPACE}
spec:
  selector:
    app: kafka
  ports:
  - port: 9092
    targetPort: 9092
EOF

cat > k8s/apm-server-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apm-server
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apm-server
  template:
    metadata:
      labels:
        app: apm-server
    spec:
      containers:
      - name: apm-server
        image: docker.elastic.co/apm/apm-server:8.11.0
        env:
        - name: output.elasticsearch.hosts
          value: '["http://elasticsearch-service:9200"]'
        ports:
        - containerPort: 8200
---
apiVersion: v1
kind: Service
metadata:
  name: apm-server
  namespace: ${NAMESPACE}
spec:
  selector:
    app: apm-server
  ports:
  - port: 8200
    targetPort: 8200
EOF

# FIXED spring-app-deployment.yaml - removed problematic dependencies
cat > k8s/spring-app-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-app
  namespace: ${NAMESPACE}
  labels:
    app: spring-app
    version: v2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: spring-app
  template:
    metadata:
      labels:
        app: spring-app
    spec:
      serviceAccountName: spring-app-sa
      containers:
      - name: spring-app
        image: ${REGISTRY}/spring-app:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: "kubernetes"
        - name: MONGODB_URI
          value: "mongodb://mongodb-service:27017/surveys"
        - name: SPRING_DATA_MONGODB_DATABASE
          value: "surveys"
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        readinessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 90
          periodSeconds: 15
---
apiVersion: v1
kind: Service
metadata:
  name: spring-app-service
  namespace: ${NAMESPACE}
spec:
  selector:
    app: spring-app
  ports:
  - port: 8080
    targetPort: 8080
    name: http
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: spring-app-sa
  namespace: ${NAMESPACE}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: spring-app-role
  namespace: ${NAMESPACE}
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps"]
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: spring-app-rolebinding
  namespace: ${NAMESPACE}
subjects:
- kind: ServiceAccount
  name: spring-app-sa
  namespace: ${NAMESPACE}
roleRef:
  kind: Role
  name: spring-app-role
  apiGroup: rbac.authorization.k8s.io
EOF

# Fixed mongodb.yaml
cat > k8s/mongodb.yaml << 'EOF'
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
  namespace: ${NAMESPACE}
  labels:
    app: mongodb
spec:
  serviceName: mongodb-service
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo:6.0
        ports:
        - containerPort: 27017
        env:
        - name: MONGO_INITDB_DATABASE
          value: "surveys"
        volumeMounts:
        - name: mongodb-data
          mountPath: /data/db
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          tcpSocket:
            port: 27017
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          tcpSocket:
            port: 27017
          initialDelaySeconds: 5
          periodSeconds: 5
  volumeClaimTemplates:
  - metadata:
      name: mongodb-data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 5Gi
---
apiVersion: v1
kind: Service
metadata:
  name: mongodb-service
  namespace: ${NAMESPACE}
spec:
  selector:
    app: mongodb
  ports:
  - port: 27017
    targetPort: 27017
EOF

# Fixed elasticsearch.yaml
cat > k8s/elasticsearch.yaml << 'EOF'
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: elasticsearch
  namespace: ${NAMESPACE}
spec:
  serviceName: elasticsearch-service
  replicas: 1
  selector:
    matchLabels:
      app: elasticsearch
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      containers:
      - name: elasticsearch
        image: elasticsearch:8.11.0
        env:
        - name: discovery.type
          value: single-node
        - name: xpack.security.enabled
          value: "false"
        - name: ES_JAVA_OPTS
          value: "-Xms512m -Xmx512m"
        ports:
        - containerPort: 9200
          name: http
        - containerPort: 9300
          name: transport
        volumeMounts:
        - name: elasticsearch-data
          mountPath: /usr/share/elasticsearch/data
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
---
apiVersion: v1
kind: Service
metadata:
  name: elasticsearch-service
  namespace: ${NAMESPACE}
spec:
  selector:
    app: elasticsearch
  ports:
  - port: 9200
    targetPort: 9200
  - port: 9300
    targetPort: 9300
EOF

# Fixed logstash.yaml
cat > k8s/logstash.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: logstash
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: logstash
  template:
    metadata:
      labels:
        app: logstash
    spec:
      containers:
      - name: logstash
        image: logstash:8.11.0
        ports:
        - containerPort: 5000
          name: tcp
        env:
        - name: XPACK_MONITORING_ENABLED
          value: "false"
        command:
        - logstash
        - -e
        - |
          input {
            tcp {
              port => 5000
              codec => json_lines
            }
          }
          filter {
            if [type] == "spring" {
              grok {
                match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{NUMBER:pid} --- \[%{DATA:thread}\] %{DATA:class} : %{GREEDYDATA:message}" }
              }
              date {
                match => [ "timestamp", "ISO8601" ]
                target => "@timestamp"
              }
              mutate {
                add_field => { "service_name" => "spring-app" }
              }
            }
          }
          output {
            elasticsearch {
              hosts => ["elasticsearch-service:9200"]
              index => "logs-%{+YYYY.MM.dd}"
            }
            stdout {
              codec => rubydebug
            }
          }
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
---
apiVersion: v1
kind: Service
metadata:
  name: logstash-service
  namespace: ${NAMESPACE}
spec:
  selector:
    app: logstash
  ports:
  - port: 5000
    targetPort: 5000
    name: tcp
EOF

# Fixed kibana.yaml
cat > k8s/kibana.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kibana
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kibana
  template:
    metadata:
      labels:
        app: kibana
    spec:
      containers:
      - name: kibana
        image: kibana:8.11.0
        ports:
        - containerPort: 5601
        env:
        - name: ELASTICSEARCH_HOSTS
          value: "http://elasticsearch-service:9200"
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /api/status
            port: 5601
          initialDelaySeconds: 60
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: kibana-service
  namespace: ${NAMESPACE}
spec:
  selector:
    app: kibana
  ports:
  - port: 5601
    targetPort: 5601
EOF

# Fixed spark-master.yaml
cat > k8s/spark-master.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spark-master
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: spark-master
  template:
    metadata:
      labels:
        app: spark-master
    spec:
      containers:
      - name: spark-master
        image: bitnami/spark:3.5.0
        command: ["/opt/bitnami/spark/bin/spark-class"]
        args: ["org.apache.spark.deploy.master.Master", 
               "--host", "spark-master", 
               "--port", "7077",
               "--webui-port", "8080"]
        ports:
        - containerPort: 7077
          name: spark
        - containerPort: 8080
          name: http
        env:
        - name: SPARK_MODE
          value: "master"
        - name: SPARK_MASTER_HOST
          value: "spark-master"
        - name: SPARK_RPC_AUTHENTICATION_ENABLED
          value: "no"
        - name: SPARK_RPC_ENCRYPTION_ENABLED
          value: "no"
        - name: SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED
          value: "no"
        - name: SPARK_SSL_ENABLED
          value: "no"
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
---
apiVersion: v1
kind: Service
metadata:
  name: spark-master-service
  namespace: ${NAMESPACE}
spec:
  selector:
    app: spark-master
  ports:
  - port: 7077
    targetPort: 7077
    name: spark
  - port: 8080
    targetPort: 8080
    name: http
EOF

# Fixed spark-worker.yaml
cat > k8s/spark-worker.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spark-worker
  namespace: ${NAMESPACE}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: spark-worker
  template:
    metadata:
      labels:
        app: spark-worker
    spec:
      containers:
      - name: spark-worker
        image: bitnami/spark:3.5.0
        command: ["/opt/bitnami/spark/bin/spark-class"]
        args: ["org.apache.spark.deploy.worker.Worker", 
               "spark://spark-master:7077"]
        ports:
        - containerPort: 8081
          name: http
        env:
        - name: SPARK_MODE
          value: "worker"
        - name: SPARK_MASTER_URL
          value: "spark://spark-master:7077"
        - name: SPARK_WORKER_MEMORY
          value: "1g"
        - name: SPARK_WORKER_CORES
          value: "1"
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
EOF

# Fixed ingress-extended.yaml - removed TLS and cert-manager references
cat > k8s/ingress-extended.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: spring-app-ingress
  namespace: ${NAMESPACE}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "*"
spec:
  ingressClassName: nginx
  rules:
  - host: survey.dawidtrojanowski.com
    http:
      paths:
      - path: /api/v2
        pathType: Prefix
        backend:
          service:
            name: spring-app-service
            port:
              number: 8080
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 8000
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kibana-ingress
  namespace: ${NAMESPACE}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: kibana.dawidtrojanowski.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: kibana-service
            port:
              number: 5601
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: spark-ingress
  namespace: ${NAMESPACE}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: spark.dawidtrojanowski.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: spark-master-service
            port:
              number: 8080
EOF

# Fixed kustomization.yaml
cat > k8s/kustomization.yaml << 'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: ${NAMESPACE}

resources:
  - spring-app-deployment.yaml
  - kafka-deployment.yaml
  - apm-server-deployment.yaml
  - mongodb.yaml
  - elasticsearch.yaml
  - logstash.yaml
  - kibana.yaml
  - spark-master.yaml
  - spark-worker.yaml
  - ingress-extended.yaml

images:
  - name: spring-app
    newName: ${REGISTRY}/spring-app
    newTag: latest

configMapGenerator:
  - name: mongodb-config
    literals:
      - database=surveys
      - host=mongodb-service
      - port=27017

secretGenerator:
  - name: mongodb-secret
    literals:
      - username=admin
      - password=password
  - name: kibana-auth
    literals:
      - auth=admin:password
EOF

echo "Created FIXED Kubernetes manifests"

# ============================================
# 6. Create GitHub Actions Workflow
# ============================================
cat > .github/workflows/build.yaml << 'EOF'
name: Build and Deploy Spring App

on:
  push:
    branches: [ main ]
    paths:
      - 'spring-app/**'

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
    
    - name: Build with Maven
      run: |
        cd spring-app
        mvn clean package -DskipTests
    
    - name: Login to GitHub Container Registry
      uses: docker/login-action@v2
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Build and push Spring App
      uses: docker/build-push-action@v4
      with:
        context: ./spring-app
        push: true
        tags: |
          ghcr.io/exea-centrum/website-db-vault-kaf-redis-arg-kust-kyv-elk-apm-sprig-spar2/spring-app:latest
          ghcr.io/exea-centrum/website-db-vault-kaf-redis-arg-kust-kyv-elk-apm-sprig-spar2/spring-app:${{ github.sha }}
    
    - name: Update Kustomize
      run: |
        cd k8s
        kustomize edit set image spring-app=ghcr.io/exea-centrum/website-db-vault-kaf-redis-arg-kust-kyv-elk-apm-sprig-spar2/spring-app:${{ github.sha }}
    
    - name: Commit and push changes
      run: |
        git config user.name "GitHub Actions"
        git config user.email "actions@github.com"
        git add k8s/kustomization.yaml
        git commit -m "Update Spring app image to ${{ github.sha }}" || echo "No changes to commit"
        git push
EOF

# ============================================
# 7. Create fixed deploy.sh script
# ============================================
cat > deploy.sh << 'EOF'
#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Deploying $PROJECT ===${NC}"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}kubectl is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if kustomize is installed
if ! command -v kustomize &> /dev/null; then
    echo -e "${YELLOW}kustomize is not installed. Installing...${NC}"
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
    sudo mv kustomize /usr/local/bin/
fi

# Set namespace
echo -e "${YELLOW}Setting up namespace: $NAMESPACE${NC}"
kubectl create namespace $NAMESPACE 2>/dev/null || true

# Apply Kustomize
echo -e "${YELLOW}Applying Kustomize manifests...${NC}"
cd k8s

# Create temporary files with environment substitution
for file in *.yaml; do
    if [ -f "$file" ]; then
        envsubst < "$file" > "${file}.tmp"
        mv "${file}.tmp" "$file"
    fi
done

# Build and apply kustomization
kustomize build . | kubectl apply -f -
cd ..

# Wait for deployments
echo -e "${YELLOW}Waiting for deployments to be ready...${NC}"
sleep 20

# Check deployment status
echo -e "\n${BLUE}=== Deployment Status ===${NC}"
kubectl get deployments -n $NAMESPACE

echo -e "\n${BLUE}=== Services ===${NC}"
kubectl get services -n $NAMESPACE

echo -e "\n${BLUE}=== Pods ===${NC}"
kubectl get pods -n $NAMESPACE

echo -e "\n${GREEN}=== Deployment Complete! ===${NC}"
echo -e "Access points:"
echo -e "  - Spring App API: http://spring-app-service.$NAMESPACE.svc.cluster.local:8080"
echo -e "  - MongoDB: mongodb-service.$NAMESPACE.svc.cluster.local:27017"
echo -e "  - Kibana: http://kibana-service.$NAMESPACE.svc.cluster.local:5601"
echo -e "  - Spark Master: http://spark-master-service.$NAMESPACE.svc.cluster.local:8080"

echo -e "\n${YELLOW}To monitor the deployment:${NC}"
echo -e "  kubectl get all -n $NAMESPACE"
echo -e "  kubectl logs deployment/spring-app -n $NAMESPACE"
echo -e "  kubectl port-forward service/spring-app-service 8080:8080 -n $NAMESPACE"
EOF

chmod +x deploy.sh

# ============================================
# 8. Create README.md
# ============================================
cat > README.md << 'EOF'
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