package com.example.openai.image.generator.ui;

import java.util.Map;

import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.image.ImageModel;
import org.springframework.ai.image.ImagePrompt;
import org.springframework.ai.image.ImageResponse;
import org.springframework.ai.openai.OpenAiImageOptions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ImageController {

    private final ImageModel imageModel;
    private final ChatModel chatModel;

    public ImageController(ImageModel imageModel, ChatModel chatModel) {
        this.imageModel = imageModel;
        this.chatModel = chatModel;
    }

    @GetMapping("/")
    public String home(Map<String, Object> model) {
        model.put("request", new ImageGenerationRequest("", "1024x1024", "standard", "natural"));
        model.put("imageUrl", null);
        return "index";
    }

    @PostMapping("/suggest")
    @ResponseBody
    public Map<String, String> suggestPrompt(@RequestParam String keywords) {
        if (keywords == null || keywords.isBlank()) {
            return Map.of("error", "Please enter some keywords");
        }

        try {
            String systemPrompt =
                    """
                You are an expert at creating detailed, vivid image generation prompts for DALL-E 3.
                Given some keywords or a brief description, create a detailed, creative prompt that will generate a stunning image.
                The prompt should be descriptive, include artistic style, lighting, mood, and composition details.
                Return ONLY the prompt text, nothing else. Keep it under 200 words.
                """;

            String userMessage =
                    "Create an image generation prompt based on these keywords: " + keywords;

            var response = chatModel.call(new Prompt(systemPrompt + "\n\n" + userMessage));
            String suggestedPrompt = response.getResult().getOutput().getText().trim();

            return Map.of("prompt", suggestedPrompt);
        } catch (Exception e) {
            return Map.of("error", "Error generating suggestion: " + e.getMessage());
        }
    }

    @PostMapping("/generate")
    public String generateImage(
            @ModelAttribute ImageGenerationRequest request, Map<String, Object> model) {
        if (request.prompt() == null || request.prompt().isBlank()) {
            model.put("request", request);
            model.put("imageUrl", null);
            model.put("error", "Please enter a prompt");
            return "index";
        }

        try {
            String[] dimensions = request.size().split("x");
            int width = Integer.parseInt(dimensions[0]);
            int height = Integer.parseInt(dimensions[1]);

            OpenAiImageOptions options =
                    OpenAiImageOptions.builder()
                            .model("dall-e-3")
                            .width(width)
                            .height(height)
                            .quality(request.quality())
                            .style(request.style())
                            .build();

            ImagePrompt imagePrompt = new ImagePrompt(request.prompt(), options);

            long startTime = System.currentTimeMillis();
            ImageResponse response = imageModel.call(imagePrompt);
            long duration = System.currentTimeMillis() - startTime;

            String imageUrl = response.getResult().getOutput().getUrl();

            model.put("request", request);
            model.put("imageUrl", imageUrl);
            model.put("generationTime", String.format("%.1f", duration / 1000.0));
            model.put("imageSize", request.size());
            model.put("imageQuality", request.quality());
            model.put("imageStyle", request.style());
        } catch (Exception e) {
            model.put("request", request);
            model.put("imageUrl", null);
            model.put("error", "Error generating image: " + e.getMessage());
        }

        return "index";
    }
}
