@param String title = "AI Image Generator"
@param gg.jte.Content content

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            color: #fff;
            padding: 2rem;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        h1 {
            text-align: center;
            margin-bottom: 2rem;
            font-size: 2.5rem;
            background: linear-gradient(90deg, #00d2ff, #3a7bd5);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .main-layout {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 2rem;
            align-items: start;
        }

        .left-panel {
            position: sticky;
            top: 2rem;
        }

        .right-panel {
            min-height: 500px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            padding: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            width: 100%;
        }

        .image-card {
            background: rgba(255, 255, 255, 0.05);
            height: 100%;
            min-height: 500px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .placeholder {
            text-align: center;
            color: #4a5568;
            padding: 2rem;
        }

        .placeholder-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        @media (max-width: 900px) {
            .main-layout {
                grid-template-columns: 1fr;
            }
            .left-panel {
                position: static;
            }
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #a0aec0;
        }

        textarea, select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.05);
            color: #fff;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        textarea:focus, select:focus {
            outline: none;
            border-color: #3a7bd5;
        }

        textarea {
            resize: vertical;
        }

        textarea[rows="2"] {
            min-height: 60px;
        }

        textarea[rows="5"] {
            min-height: 150px;
        }

        textarea[rows="6"] {
            min-height: 180px;
        }

        .separator {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 1.5rem 0;
            color: #4a5568;
            font-size: 0.85rem;
        }

        .separator::before,
        .separator::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .separator span {
            padding: 0 1rem;
        }

        select {
            cursor: pointer;
        }

        select option {
            background: #1a1a2e;
            color: #fff;
        }

        .options-grid {
            display: flex;
            flex-direction: row;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .options-grid .form-group {
            flex: 1;
            margin-bottom: 0;
        }

        .options-grid label {
            font-size: 0.8rem;
            margin-bottom: 0.25rem;
        }

        .options-grid select {
            padding: 0.5rem;
            font-size: 0.85rem;
        }

        .btn {
            display: inline-block;
            padding: 1rem 2rem;
            background: linear-gradient(90deg, #00d2ff, #3a7bd5);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            width: 100%;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(58, 123, 213, 0.4);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .btn-suggest {
            margin-top: 0.5rem;
            background: linear-gradient(90deg, #9b59b6, #8e44ad);
            padding: 0.6rem 1rem;
            font-size: 0.9rem;
        }

        .btn-suggest:hover {
            box-shadow: 0 4px 20px rgba(155, 89, 182, 0.4);
        }

        .error {
            background: rgba(255, 107, 107, 0.2);
            border: 1px solid #ff6b6b;
            color: #ff6b6b;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .image-container {
            text-align: center;
        }

        .image-container img {
            max-width: 100%;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .loading {
            display: none;
            text-align: center;
            padding: 2rem;
        }

        .loading.active {
            display: block;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 3px solid rgba(255, 255, 255, 0.1);
            border-top-color: #3a7bd5;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 1rem;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .prompt-display {
            background: rgba(0, 0, 0, 0.2);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            font-style: italic;
            color: #a0aec0;
        }

        .image-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 1rem;
            padding: 0.75rem 1rem;
            background: rgba(0, 210, 255, 0.1);
            border-radius: 8px;
            border: 1px solid rgba(0, 210, 255, 0.2);
        }

        .meta-row {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .meta-label {
            color: #a0aec0;
            font-size: 0.85rem;
        }

        .meta-value {
            color: #00d2ff;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .revised-prompt {
            background: rgba(0, 0, 0, 0.2);
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
            font-size: 0.9rem;
            color: #a0aec0;
        }

        .revised-prompt strong {
            color: #00d2ff;
            display: block;
            margin-bottom: 0.5rem;
        }

        .revised-prompt p {
            line-height: 1.5;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="container">
        ${content}
    </div>
    <script>
        // Handle generate form submission
        document.getElementById('generateForm').addEventListener('submit', function() {
            document.getElementById('generateBtn').disabled = true;
            document.getElementById('generateBtn').textContent = 'Generating...';
        });

        // Handle suggest button click
        document.getElementById('suggestBtn').addEventListener('click', async function() {
            const keywordsTextarea = document.getElementById('keywords');
            const promptTextarea = document.getElementById('prompt');
            const keywords = keywordsTextarea.value.trim();
            const suggestBtn = this;

            if (!keywords) {
                alert('Please enter some keywords first');
                return;
            }

            suggestBtn.disabled = true;
            suggestBtn.textContent = 'Thinking...';

            try {
                const formData = new FormData();
                formData.append('keywords', keywords);

                const response = await fetch('/suggest', {
                    method: 'POST',
                    body: formData
                });

                const data = await response.json();

                if (data.error) {
                    alert(data.error);
                } else if (data.prompt) {
                    promptTextarea.value = data.prompt;
                }
            } catch (error) {
                alert('Error: ' + error.message);
            } finally {
                suggestBtn.disabled = false;
                suggestBtn.textContent = 'Suggest Prompt';
            }
        });
    </script>
</body>
</html>
