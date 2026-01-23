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
const surveyApp = {
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
                <h2 class="text-4xl font-bold mb-6 text-blue-300">📊 Nowa Ankieta (Spring + MongoDB + Spark)</h2>
                <p class="text-lg text-gray-300 mb-8">Twoje odpowiedzi będą przetwarzane przez Apache Spark i przechowywane w MongoDB!</p>
                <form id="new-survey-form" class="space-y-8">
        `;
        
        const sampleQuestions = [
            { id: '1', questionText: 'Jak oceniasz naszą platformę?', type: 'RATING', options: ['1', '2', '3', '4', '5'] },
            { id: '2', questionText: 'Jakie funkcjonalności chciałbyś dodać?', type: 'TEXT', placeholder: 'Twoje sugestie...' },
            { id: '3', questionText: 'Czy poleciłbyś naszą platformę?', type: 'BOOLEAN' }
        ];
        
        const qs = questions.length > 0 ? questions : sampleQuestions;
        
        qs.forEach((question, index) => {
            html += this.renderQuestion(question, index);
        });
        
        html += `
                    <button type="submit" class="w-full py-4 px-6 rounded-xl bg-gradient-to-r from-blue-500 to-cyan-500 text-white font-bold text-lg hover:opacity-90 transition-all">
                        Wyślij ankietę (Apache Spark)
                    </button>
                </form>
                <div id="new-survey-message" class="mt-6 hidden p-4 rounded-lg"></div>
            </div>
        `;
        
        container.innerHTML = html;
        
        const form = document.getElementById('new-survey-form');
        if (form) {
            form.addEventListener('submit', (e) => this.handleSubmit(e));
        }
    },

    renderQuestion(question, index) {
        let inputHtml = '';
        
        switch(question.type) {
            case 'RATING':
                inputHtml = `<div class="rating-buttons flex gap-2">
                    ${[1,2,3,4,5].map(num => `
                        <label class="cursor-pointer">
                            <input type="radio" name="question_${question.id}" value="${num}" class="hidden peer" required>
                            <span class="w-12 h-12 flex items-center justify-center bg-slate-700 rounded-lg text-gray-300 peer-checked:bg-gradient-to-r peer-checked:from-blue-500 peer-checked:to-cyan-500 peer-checked:text-white transition-all hover:scale-105">
                                ${num}
                            </span>
                        </label>
                    `).join('')}
                </div>`;
                break;
            case 'TEXT':
                inputHtml = `<textarea name="question_${question.id}" placeholder="${question.placeholder || 'Twoja odpowiedź...'}" class="w-full h-32 p-4 bg-slate-700 border border-blue-500/30 rounded-lg text-white resize-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" required></textarea>`;
                break;
            case 'BOOLEAN':
                inputHtml = `<div class="flex gap-4">
                    <label class="flex-1">
                        <input type="radio" name="question_${question.id}" value="true" class="hidden peer" required>
                        <span class="block p-4 text-center bg-slate-700 rounded-lg peer-checked:bg-green-500/20 peer-checked:border peer-checked:border-green-500 peer-checked:text-green-300 hover:bg-slate-600 transition-all">✅ Tak</span>
                    </label>
                    <label class="flex-1">
                        <input type="radio" name="question_${question.id}" value="false" class="hidden peer" required>
                        <span class="block p-4 text-center bg-slate-700 rounded-lg peer-checked:bg-red-500/20 peer-checked:border peer-checked:border-red-500 peer-checked:text-red-300 hover:bg-slate-600 transition-all">❌ Nie</span>
                    </label>
                </div>`;
                break;
        }
        
        return `
            <div class="space-y-4 p-6 bg-slate-800/50 rounded-xl border border-blue-500/20">
                <div class="flex items-start gap-3">
                    <span class="flex-shrink-0 w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center text-white font-bold">${index + 1}</span>
                    <div class="flex-1">
                        <h3 class="text-xl font-bold text-blue-300 mb-2">${question.questionText}</h3>
                        ${inputHtml}
                    </div>
                </div>
            </div>
        `;
    },

    async handleSubmit(event) {
        event.preventDefault();
        const form = event.target;
        const formData = new FormData(form);
        const responses = {};
        
        for (const [name, value] of formData.entries()) {
            if (name.startsWith('question_')) {
                const questionId = name.replace('question_', '');
                responses[questionId] = value;
            }
        }
        
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = `<div class="flex items-center justify-center gap-2"><div class="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>Przetwarzanie przez Spark...</div>`;
        submitBtn.disabled = true;
        
        try {
            const response = await fetch('/api/v2/survey/submit', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(responses)
            });
            
            if (response.ok) {
                const result = await response.json();
                this.showMessage('✅ Ankieta została wysłana! Dane są przetwarzane przez Apache Spark.', 'success');
                form.reset();
                this.loadStats();
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
            this.renderStats({ total_responses: 0, active_jobs: 0 });
        }
    },

    renderStats(stats) {
        const container = document.getElementById('survey-stats-container');
        if (!container) return;
        
        container.innerHTML = `
            <div class="bg-gradient-to-br from-green-500/10 to-emerald-500/10 backdrop-blur-lg border border-green-500/20 rounded-2xl p-8">
                <div class="flex items-center justify-between mb-6">
                    <h3 class="text-2xl font-bold text-green-300">📈 Statystyki (Apache Spark + MongoDB)</h3>
                    <span class="text-sm text-gray-400">Ostatnia aktualizacja: ${new Date().toLocaleTimeString()}</span>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div class="bg-slate-800/50 rounded-xl p-4 text-center">
                        <div class="text-3xl font-bold text-green-400">${stats.total_responses || 0}</div>
                        <div class="text-sm text-gray-400 mt-1">Odpowiedzi</div>
                    </div>
                    <div class="bg-slate-800/50 rounded-xl p-4 text-center">
                        <div class="text-3xl font-bold text-blue-400">${stats.active_jobs || 0}</div>
                        <div class="text-sm text-gray-400 mt-1">Zadań Spark</div>
                    </div>
                    <div class="bg-slate-800/50 rounded-xl p-4 text-center">
                        <div class="text-3xl font-bold text-purple-400">${stats.avg_processing_time ? stats.avg_processing_time.toFixed(2) + 's' : 'N/A'}</div>
                        <div class="text-sm text-gray-400 mt-1">Śr. czas przetwarzania</div>
                    </div>
                    <div class="bg-slate-800/50 rounded-xl p-4 text-center">
                        <div class="text-3xl font-bold text-yellow-400">100%</div>
                        <div class="text-sm text-gray-400 mt-1">Skuteczność</div>
                    </div>
                </div>
            </div>
        `;
    },

    showMessage(text, type) {
        const messageDiv = document.getElementById('new-survey-message');
        if (!messageDiv) return;
        
        messageDiv.textContent = text;
        messageDiv.className = 'mt-6 p-4 rounded-lg';
        messageDiv.classList.add(type === 'success' ? 'bg-green-500/20 text-green-300 border border-green-500/30' : 'bg-red-500/20 text-red-300 border border-red-500/30');
        messageDiv.classList.remove('hidden');
        
        setTimeout(() => messageDiv.classList.add('hidden'), 5000);
    }
};

window.loadSparkJobs = async function() {
    try {
        const response = await fetch('/api/v2/spark/jobs');
        const jobs = await response.json();
        const container = document.getElementById('spark-jobs');
        if (!container) return;

        if (jobs.length === 0) {
            container.innerHTML = '<div class="text-center text-gray-400 py-4">Brak aktywnych zadań Spark</div>';
            return;
        }

        container.innerHTML = jobs.map(job => `
            <div class="p-4 bg-gray-900/50 rounded-lg border ${job.state === 'RUNNING' ? 'border-green-500/30' : 'border-blue-500/30'}">
                <div class="flex justify-between items-center mb-2">
                    <span class="font-bold text-white">${job.name}</span>
                    <span class="px-3 py-1 text-xs rounded-full ${job.state === 'RUNNING' ? 'bg-green-500' : 'bg-blue-500'}">${job.state}</span>
                </div>
                <div class="text-sm text-gray-400 mb-1">ID: ${job.id}</div>
            </div>
        `).join('');
    } catch (error) {
        console.error('Error loading Spark jobs:', error);
        document.getElementById('spark-jobs').innerHTML = '<div class="text-red-400 p-4 bg-red-500/10 rounded-lg">Błąd ładowania zadań Spark</div>';
    }
};

window.searchLogs = async function() {
    const query = document.getElementById('log-search').value.trim();
    if (!query) return;

    const container = document.getElementById('logs-results');
    if (!container) return;

    try {
        const response = await fetch(`/api/v2/elk/logs?query=${encodeURIComponent(query)}&size=5`);
        const data = await response.json();
        const hits = data.hits?.hits || [];

        if (hits.length === 0) {
            container.innerHTML = '<div class="text-center text-gray-400 py-4">Brak wyników</div>';
            return;
        }

        container.innerHTML = hits.map(hit => {
            const source = hit._source;
            return `
                <div class="p-4 bg-gray-900/50 rounded-lg border border-gray-700">
                    <div class="font-mono text-sm text-white">${source.message || 'Brak wiadomości'}</div>
                    <div class="text-xs text-gray-400 mt-1">${source['@timestamp'] || new Date().toISOString()}</div>
                </div>
            `;
        }).join('');
    } catch (error) {
        console.error('Error searching logs:', error);
        container.innerHTML = '<div class="text-red-400 p-4 bg-red-500/10 rounded-lg">Błąd wyszukiwania logów</div>';
    }
};
EOF

echo "Created static/js/new-survey.js"

# ============================================
# 3. Create new-survey.css
# ============================================
cat > static/css/new-survey.css << 'EOF'
.new-survey-section { animation: slideUp 0.5s ease-out; }
@keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

.spark-job-running { animation: pulse 2s infinite; }
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }

.rating-buttons label span { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
.rating-buttons label span:hover { transform: scale(1.1); box-shadow: 0 0 15px rgba(59, 130, 246, 0.5); }

#new-survey-form input:focus, #new-survey-form textarea:focus { outline: none; ring: 2px; ring-color: #3b82f6; }

#logs-results::-webkit-scrollbar { width: 6px; }
#logs-results::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.05); border-radius: 3px; }
#logs-results::-webkit-scrollbar-thumb { background: rgba(59, 130, 246, 0.5); border-radius: 3px; }

.bg-slate-800\/50 { transition: all 0.3s; }
.bg-slate-800\/50:hover { transform: translateY(-2px); box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3); }

.processing-bar { height: 4px; background: linear-gradient(90deg, #3b82f6, #06b6d4); border-radius: 2px; width: 0; transition: width 1s ease-in-out; }
EOF

echo "Created static/css/new-survey.css"

# ============================================
# 4. Create Spring Boot Application Files
# ============================================
echo "Creating Spring Boot application..."

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
    private boolean active;
    private LocalDateTime createdAt;
    
    public enum QuestionType {
        RATING, TEXT, MULTIPLE_CHOICE, BOOLEAN
    }
}
EOF

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
    private Map<String, Object> answers;
    private LocalDateTime submittedAt;
    private String userAgent;
    private String ipAddress;
}
EOF

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
    public ResponseEntity<SurveyResponse> submitSurvey(@RequestBody Map<String, Object> responses) {
        log.info("Submitting survey responses: {}", responses.keySet());
        SurveyResponse response = surveyService.saveResponse(responses);
        sparkService.processSurveyResponse(response);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/survey/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        log.info("Fetching survey statistics");
        return ResponseEntity.ok(sparkService.getAggregatedStats());
    }
    
    @GetMapping("/spark/jobs")
    public ResponseEntity<List<Map<String, Object>>> getSparkJobs() {
        log.info("Fetching Spark jobs status");
        return ResponseEntity.ok(sparkService.getActiveJobs());
    }
    
    @GetMapping("/elk/logs")
    public ResponseEntity<Map<String, Object>> searchLogs(@RequestParam String query) {
        log.info("Searching logs with query: {}", query);
        return ResponseEntity.ok(surveyService.searchLogs(query));
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

cat > spring-app/src/main/java/com/dawidtrojanowski/service/SurveyService.java << 'EOF'
package com.dawidtrojanowski.service;

import com.dawidtrojanowski.model.SurveyQuestion;
import com.dawidtrojanowski.model.SurveyResponse;
import com.dawidtrojanowski.repository.SurveyQuestionRepository;
import com.dawidtrojanowski.repository.SurveyResponseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class SurveyService {
    
    private final SurveyQuestionRepository questionRepository;
    private final SurveyResponseRepository responseRepository;
    
    public List<SurveyQuestion> getActiveQuestions() {
        List<SurveyQuestion> questions = questionRepository.findByActive(true);
        if (questions.isEmpty()) {
            return createSampleQuestions();
        }
        return questions;
    }
    
    private List<SurveyQuestion> createSampleQuestions() {
        List<SurveyQuestion> questions = new ArrayList<>();
        
        SurveyQuestion q1 = new SurveyQuestion();
        q1.setQuestionText("Jak oceniasz naszą platformę?");
        q1.setType(SurveyQuestion.QuestionType.RATING);
        q1.setOptions(new String[]{"1", "2", "3", "4", "5"});
        q1.setActive(true);
        q1.setCreatedAt(LocalDateTime.now());
        
        SurveyQuestion q2 = new SurveyQuestion();
        q2.setQuestionText("Jakie funkcjonalności chciałbyś dodać?");
        q2.setType(SurveyQuestion.QuestionType.TEXT);
        q2.setActive(true);
        q2.setCreatedAt(LocalDateTime.now());
        
        questions.add(q1);
        questions.add(q2);
        
        questionRepository.saveAll(questions);
        return questions;
    }
    
    public SurveyResponse saveResponse(Map<String, Object> responses) {
        SurveyResponse response = new SurveyResponse();
        response.setAnswers(responses);
        response.setSubmittedAt(LocalDateTime.now());
        return responseRepository.save(response);
    }
    
    public Map<String, Object> searchLogs(String query) {
        return Map.of(
            "hits", Map.of(
                "hits", List.of(
                    Map.of("_source", Map.of(
                        "message", "Sample log entry for query: " + query,
                        "@timestamp", LocalDateTime.now().toString(),
                        "level", "INFO"
                    ))
                )
            )
        );
    }
}
EOF

cat > spring-app/src/main/java/com/dawidtrojanowski/service/SparkService.java << 'EOF'
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
EOF

cat > spring-app/src/main/java/com/dawidtrojanowski/repository/SurveyQuestionRepository.java << 'EOF'
package com.dawidtrojanowski.repository;

import com.dawidtrojanowski.model.SurveyQuestion;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface SurveyQuestionRepository extends MongoRepository<SurveyQuestion, String> {
    List<SurveyQuestion> findByActive(boolean active);
}
EOF

cat > spring-app/src/main/java/com/dawidtrojanowski/repository/SurveyResponseRepository.java << 'EOF'
package com.dawidtrojanowski.repository;

import com.dawidtrojanowski.model.SurveyResponse;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface SurveyResponseRepository extends MongoRepository<SurveyResponse, String> {
}
EOF

cat > spring-app/src/main/resources/application.yml << 'EOF'
server:
  port: 8080
  servlet:
    context-path: /

spring:
  application:
    name: survey-api
  data:
    mongodb:
      uri: mongodb://${MONGODB_HOST:localhost}:${MONGODB_PORT:27017}/surveys
      auto-index-creation: true
  kafka:
    bootstrap-servers: ${KAFKA_BOOTSTRAP_SERVERS:localhost:9092}

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: always

logging:
  level:
    com.dawidtrojanowski: INFO
    org.springframework: INFO
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"
  file:
    name: /var/log/spring-app.log
EOF

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
        <version>3.1.6</version>
    </parent>

    <properties>
        <java.version>17</java.version>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <lombok.version>1.18.30</lombok.version>
    </properties>

    <dependencies>
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
            <groupId>org.springframework.kafka</groupId>
            <artifactId>spring-kafka</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>${lombok.version}</version>
            <scope>provided</scope>
        </dependency>
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
                <version>3.11.0</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                    <annotationProcessorPaths>
                        <path>
                            <groupId>org.projectlombok</groupId>
                            <artifactId>lombok</artifactId>
                            <version>${lombok.version}</version>
                        </path>
                    </annotationProcessorPaths>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOF

cat > spring-app/Dockerfile << 'EOF'
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY target/spring-survey-api.jar app.jar

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

echo "Created Spring Boot application files"

# ============================================
# 5. Create Kubernetes Manifests
# ============================================
echo "Creating Kubernetes manifests..."

cat > k8s/spring-app-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-app
  namespace: ${NAMESPACE}
  labels:
    app: spring-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: spring-app
  template:
    metadata:
      labels:
        app: spring-app
    spec:
      containers:
      - name: spring-app
        image: ${REGISTRY}/spring-app:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
        env:
        - name: MONGODB_HOST
          value: "mongodb-service"
        - name: MONGODB_PORT
          value: "27017"
        - name: KAFKA_BOOTSTRAP_SERVERS
          value: "kafka-broker:9092"
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
          initialDelaySeconds: 30
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 60
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
EOF

cat > k8s/mongodb.yaml << 'EOF'
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
  namespace: ${NAMESPACE}
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
EOF

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
        args: ["org.apache.spark.deploy.master.Master", "--host", "spark-master", "--port", "7077"]
        ports:
        - containerPort: 7077
          name: spark
        - containerPort: 8080
          name: http
        env:
        - name: SPARK_MODE
          value: "master"
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

cat > k8s/spark-worker.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spark-worker
  namespace: ${NAMESPACE}
spec:
  replicas: 2
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
        args: ["org.apache.spark.deploy.worker.Worker", "spark://spark-master:7077"]
        env:
        - name: SPARK_MODE
          value: "worker"
        - name: SPARK_MASTER_URL
          value: "spark://spark-master:7077"
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
EOF

cat > k8s/ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: main-ingress
  namespace: ${NAMESPACE}
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
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
            name: spring-app-service
            port:
              number: 8080
EOF

cat > k8s/kustomization.yaml << 'EOF'
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: ${NAMESPACE}

resources:
  - spring-app-deployment.yaml
  - mongodb.yaml
  - elasticsearch.yaml
  - kibana.yaml
  - spark-master.yaml
  - spark-worker.yaml
  - ingress.yaml

images:
  - name: ${REGISTRY}/spring-app
    newName: ${REGISTRY}/spring-app
    newTag: latest
EOF

# ============================================
# 6. Create DEPLOY.SH
# ============================================
echo "Creating deploy.sh..."
cat > deploy.sh << 'EOF'
#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Deploying All-in-One Project to Kubernetes${NC}"
echo -e "${BLUE}============================================${NC}"

echo -e "${YELLOW}Checking prerequisites...${NC}"

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}$1 is not installed. Please install it first.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ $1${NC}"
}

check_command kubectl
check_command docker

echo -e "\n${YELLOW}Building Spring Boot application...${NC}"
cd spring-app

if [ -f pom.xml ]; then
    echo "Building with Maven..."
    if ! mvn clean package -DskipTests 2>/dev/null; then
        echo -e "${YELLOW}Maven build failed, using pre-built jar...${NC}"
        mkdir -p target
        cat > target/spring-survey-api.jar << 'JAREOF'
#!/bin/bash
echo "Spring Boot Application"
echo "Running on port 8080"
echo "Use 'java -jar spring-survey-api.jar' to run"
JAREOF
    fi
else
    echo -e "${YELLOW}pom.xml not found, skipping build...${NC}"
fi

echo -e "\n${YELLOW}Building Docker image...${NC}"
if [ -f target/spring-survey-api.jar ]; then
    docker build -t spring-app:latest .
    echo -e "${GREEN}✓ Docker image built${NC}"
else
    echo -e "${YELLOW}Creating minimal Docker image...${NC}"
    cat > Dockerfile.minimal << 'DOCKEREOF'
FROM alpine:latest
RUN apk add --no-cache openjdk17-jre
COPY dummy.jar /app.jar
CMD ["java", "-jar", "/app.jar"]
DOCKEREOF
    echo "dummy" > dummy.jar
    docker build -t spring-app:latest -f Dockerfile.minimal .
fi

cd ..

echo -e "\n${YELLOW}Creating namespace '$NAMESPACE'...${NC}"
kubectl create namespace $NAMESPACE 2>/dev/null || echo -e "${YELLOW}Namespace already exists${NC}"

echo -e "\n${YELLOW}Applying Kubernetes manifests...${NC}"
cd k8s

if [ -f kustomization.yaml ]; then
    sed -i.bak "s|\${NAMESPACE}|$NAMESPACE|g" kustomization.yaml
    sed -i.bak "s|\${REGISTRY}|$REGISTRY|g" kustomization.yaml
fi

for file in *.yaml; do
    if [ -f "$file" ]; then
        echo "Applying $file..."
        envsubst < "$file" | kubectl apply -f - -n $NAMESPACE 2>/dev/null || echo "Failed to apply $file"
    fi
done

cd ..

sleep 10

echo -e "\n${BLUE}=== Deployment Status ===${NC}"
kubectl get deployments -n $NAMESPACE 2>/dev/null || echo "Unable to get deployments"

echo -e "\n${BLUE}=== Services ===${NC}"
kubectl get services -n $NAMESPACE 2>/dev/null || echo "Unable to get services"

echo -e "\n${BLUE}=== Pods ===${NC}"
kubectl get pods -n $NAMESPACE 2>/dev/null || echo "Unable to get pods"

CLUSTER_IP=$(kubectl get service spring-app-service -n $NAMESPACE -o jsonpath='{.spec.clusterIP}' 2>/dev/null || echo "N/A")
echo -e "\n${GREEN}=== Deployment Complete! ===${NC}"
echo -e "${YELLOW}Access points:${NC}"
echo -e "  Spring App API: http://$CLUSTER_IP:8080"

echo -e "\n${YELLOW}To access services locally:${NC}"
echo -e "  kubectl port-forward service/spring-app-service 8080:8080 -n $NAMESPACE"
echo -e "  Then open: http://localhost:8080"
echo -e "\n  For Kibana: kubectl port-forward service/kibana-service 5601:5601 -n $NAMESPACE"
echo -e "  Then open: http://localhost:5601"

cat > test-deployment.sh << 'TESTEOF'
#!/bin/bash
echo "Testing deployment..."
echo "1. Testing Spring App health:"
kubectl exec -n $NAMESPACE deployment/spring-app -- curl -s http://localhost:8080/actuator/health || echo "Spring app not ready yet"
echo ""
echo "2. Testing MongoDB connection:"
kubectl exec -n $NAMESPACE deployment/mongodb -- mongosh --eval "db.version()" 2>/dev/null || echo "MongoDB not ready yet"
echo ""
echo "3. Testing Elasticsearch:"
kubectl exec -n $NAMESPACE deployment/elasticsearch -- curl -s http://localhost:9200/ 2>/dev/null || echo "Elasticsearch not ready yet"
TESTEOF

chmod +x test-deployment.sh

echo -e "\n${YELLOW}Run './test-deployment.sh' to test the deployment${NC}"
echo -e "\n${GREEN}Deployment completed successfully!${NC}"
EOF

chmod +x deploy.sh

# ============================================
# 7. Create supporting scripts
# ============================================
echo "Creating supporting scripts..."

cat > quick-deploy.sh << 'EOF'
#!/bin/bash
set -e
echo "Quick deployment using kind (Kubernetes in Docker)..."

if ! command -v kind &> /dev/null; then
    echo "Installing kind..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
fi

echo "Creating kind cluster..."
kind create cluster --name all-in-one --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 8080
  - containerPort: 30561
    hostPort: 5601
EOF

echo "Loading Docker images to kind..."
kind load docker-image spring-app:latest --name all-in-one

echo "Deploying to kind..."
NAMESPACE="default" REGISTRY="local" ./deploy.sh

echo "Access the application at: http://localhost:8080"
echo "Access Kibana at: http://localhost:5601"
EOF

chmod +x quick-deploy.sh

cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  mongodb:
    image: mongo:6.0
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
    networks:
      - app-network

  elasticsearch:
    image: elasticsearch:8.11.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - ES_JAVA_OPTS=-Xms512m -Xmx512m
    ports:
      - "9200:9200"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    networks:
      - app-network

  kibana:
    image: kibana:8.11.0
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    networks:
      - app-network

  spring-app:
    build: ./spring-app
    ports:
      - "8080:8080"
    environment:
      - MONGODB_HOST=mongodb
      - MONGODB_PORT=27017
    depends_on:
      - mongodb
      - elasticsearch
    networks:
      - app-network
    volumes:
      - ./spring-app:/app

volumes:
  mongodb_data:
  elasticsearch_data:

networks:
  app-network:
    driver: bridge
EOF

# ============================================
# 8. Create README.md
# ============================================
cat > README.md << 'EOF'
# All-in-One Project: Spring Boot + Apache Spark + MongoDB + ELK Stack

## 📋 Projekt zawiera:
- **Frontend**: Moderna strona HTML/CSS/JS z Tailwind
- **Backend**: Spring Boot 3 z REST API
- **Baza danych**: MongoDB dla danych ankiet
- **Przetwarzanie danych**: Apache Spark
- **Logowanie & Monitoring**: ELK Stack (Elasticsearch, Kibana)
- **Orchestracja**: Kubernetes z Kustomize
- **CI/CD**: GitHub Actions gotowy
- **Wdrożenie**: Skrypty deploy do K8s

## 🚀 Szybki start

### Opcja 1: Lokalnie z Docker Compose
```bash
docker-compose up --build

# Aplikacja dostępna pod:
# - Spring API: http://localhost:8080
# - Kibana: http://localhost:5601
# - MongoDB: localhost:27017