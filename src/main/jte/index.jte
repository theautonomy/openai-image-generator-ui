@param com.example.openai.image.generator.ui.ImageGenerationRequest request
@param String imageUrl = null
@param String error = null

@template.layout(content = @`
    <h1>AI Image Generator</h1>

    <div class="main-layout">
        <div class="left-panel">
            <div class="card">
                <form action="/generate" method="post">
                    <div class="form-group">
                        <label for="prompt">Describe the image you want to create</label>
                        <textarea
                            id="prompt"
                            name="prompt"
                            placeholder="A serene mountain landscape at sunset with a crystal clear lake reflecting the golden sky..."
                        >${request.prompt()}</textarea>
                    </div>

                    <div class="options-grid">
                        <div class="form-group">
                            <label for="size">Image Size</label>
                            <select id="size" name="size">
                                @if(request.size().equals("1024x1024"))
                                    <option value="1024x1024" selected>Square (1024x1024)</option>
                                @else
                                    <option value="1024x1024">Square (1024x1024)</option>
                                @endif
                                @if(request.size().equals("1792x1024"))
                                    <option value="1792x1024" selected>Landscape (1792x1024)</option>
                                @else
                                    <option value="1792x1024">Landscape (1792x1024)</option>
                                @endif
                                @if(request.size().equals("1024x1792"))
                                    <option value="1024x1792" selected>Portrait (1024x1792)</option>
                                @else
                                    <option value="1024x1792">Portrait (1024x1792)</option>
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

                    <button type="submit" class="btn">Generate Image</button>
                </form>
            </div>

            @if(error != null)
                <div class="error">${error}</div>
            @endif
        </div>

        <div class="right-panel">
            <div class="card image-card">
                @if(imageUrl != null)
                    <div class="prompt-display">
                        <strong>Prompt:</strong> ${request.prompt()}
                    </div>
                    <div class="image-container">
                        <img src="${imageUrl}" alt="Generated image">
                    </div>
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
