package com.example.openai.image.generator.ui;

public record ImageGenerationRequest(String prompt, String size, String quality, String style) {
    public ImageGenerationRequest {
        if (size == null || size.isBlank()) {
            size = "1024x1024";
        }
        if (quality == null || quality.isBlank()) {
            quality = "standard";
        }
        if (style == null || style.isBlank()) {
            style = "natural";
        }
    }
}
