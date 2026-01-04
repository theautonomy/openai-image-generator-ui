@param com.example.openai.image.generator.ui.ImageGenerationRequest request
@param String imageUrl = null
@param String error = null
@param String imageModel = null
@param String generationTime = null
@param String imageSize = null
@param String imageQuality = null
@param String imageStyle = null

@template.layout(content = @`
    <h1>AI Image Generator</h1>

    <div class="main-layout">
        <div class="left-panel">
            <div class="card">
                <div class="form-group">
                    <label for="keywords">Your idea (keywords or brief description)</label>
                    <textarea
                        id="keywords"
                        placeholder="sunset beach palm trees, peaceful mood..."
                        rows="2"
                    ></textarea>
                    <div class="suggest-row">
                        <div class="style-select-group">
                            <label for="promptStyle">Style</label>
                            <select id="promptStyle" class="style-select">
                                <option value="creative">Creative</option>
                                <option value="professional">Professional</option>
                                <option value="fun">Fun & Playful</option>
                                <option value="realistic">Realistic Photo</option>
                                <option value="artistic">Fine Art</option>
                                <option value="fantasy">Fantasy</option>
                                <option value="minimalist">Minimalist</option>
                            </select>
                        </div>
                        <button type="button" class="btn btn-suggest" id="suggestBtn">
                            Suggest Prompt
                        </button>
                    </div>
                </div>

                <div class="separator">
                    <span>or edit the prompt below directly</span>
                </div>

                <form action="/" method="post" id="generateForm">
                    <div class="form-group">
                        <label for="prompt">Image generation prompt</label>
                        <textarea
                            id="prompt"
                            name="prompt"
                            placeholder="A detailed prompt for DALL-E will appear here, or write your own..."
                            rows="10"
                        >${request.prompt()}</textarea>
                    </div>

                    <div class="options-grid">
                        <div class="form-group">
                            <label for="size">Size</label>
                            <select id="size" name="size">
                                @if(request.size().equals("1024x1024"))
                                    <option value="1024x1024" selected>Square</option>
                                @else
                                    <option value="1024x1024">Square</option>
                                @endif
                                @if(request.size().equals("1792x1024"))
                                    <option value="1792x1024" selected>Landscape</option>
                                @else
                                    <option value="1792x1024">Landscape</option>
                                @endif
                                @if(request.size().equals("1024x1792"))
                                    <option value="1024x1792" selected>Portrait</option>
                                @else
                                    <option value="1024x1792">Portrait</option>
                                @endif
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="quality">Quality</label>
                            <select id="quality" name="quality">
                                @if(request.quality().equals("standard"))
                                    <option value="standard" selected>Standard</option>
                                @else
                                    <option value="standard">Standard</option>
                                @endif
                                @if(request.quality().equals("hd"))
                                    <option value="hd" selected>HD</option>
                                @else
                                    <option value="hd">HD</option>
                                @endif
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="style">Style</label>
                            <select id="style" name="style">
                                @if(request.style().equals("natural"))
                                    <option value="natural" selected>Natural</option>
                                @else
                                    <option value="natural">Natural</option>
                                @endif
                                @if(request.style().equals("vivid"))
                                    <option value="vivid" selected>Vivid</option>
                                @else
                                    <option value="vivid">Vivid</option>
                                @endif
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn" id="generateBtn">Generate Image</button>
                </form>
            </div>

            @if(error != null)
                <div class="error">${error}</div>
            @endif
        </div>

        <div class="right-panel">
            <div class="card image-card">
                @if(imageUrl != null)
                    <div class="image-meta">
                        <div class="meta-row">
                            <span class="meta-label">Model:</span>
                            <span class="meta-value">${imageModel}</span>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">Time:</span>
                            <span class="meta-value">${generationTime}s</span>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">Size:</span>
                            <span class="meta-value">${imageSize}</span>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">Quality:</span>
                            <span class="meta-value">${imageQuality}</span>
                        </div>
                        <div class="meta-row">
                            <span class="meta-label">Style:</span>
                            <span class="meta-value">${imageStyle}</span>
                        </div>
                    </div>
                    <div class="image-container">
                        <img src="${imageUrl}" alt="Generated image" id="generatedImage">
                    </div>
                    <button type="button" class="btn btn-download" id="downloadBtn" data-url="${imageUrl}">
                        Download Image
                    </button>
                @else
                    <div class="placeholder">
                        <div class="placeholder-icon">🎨</div>
                        <p>Your generated image will appear here</p>
                    </div>
                @endif
            </div>
        </div>
    </div>
`)
