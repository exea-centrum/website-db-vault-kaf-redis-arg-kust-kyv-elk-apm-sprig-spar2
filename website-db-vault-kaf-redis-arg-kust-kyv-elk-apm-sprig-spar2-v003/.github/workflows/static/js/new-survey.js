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
