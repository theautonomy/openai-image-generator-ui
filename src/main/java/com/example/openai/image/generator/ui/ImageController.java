package com.example.openai.image.generator.ui;

import java.util.List;
import java.util.Map;

import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
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
    public Map<String, String> suggestPrompt(
            @RequestParam String keywords,
            @RequestParam(defaultValue = "creative") String promptStyle) {
        if (keywords == null || keywords.isBlank()) {
            return Map.of("error", "Please enter some keywords");
        }

        try {
            var systemMessage = new SystemMessage(getSystemPrompt(promptStyle));
            var userMessage = new UserMessage(
                    "Create an image generation prompt based on these keywords: " + keywords);

            var prompt = new Prompt(List.of(systemMessage, userMessage));
            var response = chatModel.call(prompt);
            String suggestedPrompt = response.getResult().getOutput().getText().trim();

            return Map.of("prompt", suggestedPrompt);
        } catch (Exception e) {
            return Map.of("error", "Error generating suggestion: " + e.getMessage());
        }
    }

    private String getSystemPrompt(String style) {
        return switch (style) {
            case "professional" -> """
                You are an expert at creating professional, polished image generation prompts for DALL-E 3.
                Create prompts for high-quality professional artwork, corporate imagery, or refined illustrations.
                Focus on clean compositions, professional lighting, and sophisticated aesthetics.
                Return ONLY the prompt text, nothing else. Keep it under 200 words.
                """;
            case "fun" -> """
                You are a creative artist who loves fun, whimsical, and playful imagery!
                Create prompts that are colorful, cheerful, and full of joy and humor.
                Think cartoon-like, exaggerated features, bright colors, and happy vibes.
                Return ONLY the prompt text, nothing else. Keep it under 200 words.
                """;
            case "realistic" -> """
                You are a photography expert creating hyper-realistic image prompts for DALL-E 3.
                Focus on photorealistic details, natural lighting, realistic textures, and believable scenes.
                Include camera settings, lens types, and photography techniques in your descriptions.
                Return ONLY the prompt text, nothing else. Keep it under 200 words.
                """;
            case "artistic" -> """
                You are a fine art curator creating prompts inspired by classical and modern art movements.
                Reference specific art styles like impressionism, surrealism, art nouveau, or abstract expressionism.
                Focus on artistic techniques, brush strokes, color palettes, and emotional depth.
                Return ONLY the prompt text, nothing else. Keep it under 200 words.
                """;
            case "fantasy" -> """
                You are a fantasy world builder creating magical and mythical image prompts.
                Include dragons, wizards, enchanted forests, magical creatures, and epic landscapes.
                Focus on otherworldly lighting, mystical atmospheres, and epic fantasy elements.
                Return ONLY the prompt text, nothing else. Keep it under 200 words.
                """;
            case "minimalist" -> """
                You are a minimalist designer creating clean, simple image prompts.
                Focus on negative space, simple shapes, limited color palettes, and elegant simplicity.
                Less is more - create prompts that emphasize clarity and refined aesthetics.
                Return ONLY the prompt text, nothing else. Keep it under 200 words.
                """;
            default -> """
                You are an expert at creating detailed, vivid image generation prompts for DALL-E 3.
                Given some keywords or a brief description, create a detailed, creative prompt that will generate a stunning image.
                The prompt should be descriptive, include artistic style, lighting, mood, and composition details.
                Return ONLY the prompt text, nothing else. Keep it under 200 words.
                """;
        };
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
            model.put("imageModel", "DALL-E 3");
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
