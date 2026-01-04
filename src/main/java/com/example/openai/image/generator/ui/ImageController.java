package com.example.openai.image.generator.ui; 

import java.util.Map;

import org.springframework.ai.image.ImageModel;
import org.springframework.ai.image.ImagePrompt;
import org.springframework.ai.image.ImageResponse;
import org.springframework.ai.openai.OpenAiImageOptions;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class ImageController {

    private final ImageModel imageModel;

    public ImageController(ImageModel imageModel) {
        this.imageModel = imageModel;
    }

    @GetMapping("/")
    public String home(Map<String, Object> model) {
        model.put("request", new ImageGenerationRequest("", "1024x1024", "standard", "natural"));
        model.put("imageUrl", null);
        return "index";
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
            ImageResponse response = imageModel.call(imagePrompt);

            String imageUrl = response.getResult().getOutput().getUrl();

            model.put("request", request);
            model.put("imageUrl", imageUrl);
        } catch (Exception e) {
            model.put("request", request);
            model.put("imageUrl", null);
            model.put("error", "Error generating image: " + e.getMessage());
        }

        return "index";
    }
}
