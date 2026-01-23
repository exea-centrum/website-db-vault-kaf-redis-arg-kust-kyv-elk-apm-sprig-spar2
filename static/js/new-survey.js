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
