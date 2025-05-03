#version 330 core
out vec4 FragColor;

in vec2 TexCoord;
in vec3 ourColor;

// uniform vec4 ourColor;
// uniform sampler2D ourTexture;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float myMix;

void main()
{
    // FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
    // FragColor = vec4(ourColor, 1.0);
    // FragColor = texture(ourTexture, TexCoord) * vec4(ourColor, 1.0);
    // FragColor = mix(texture(texture1, TexCoord), texture(texture2, TexCoord), 0.4);
    FragColor = mix(texture(texture1, TexCoord), texture(texture2, TexCoord), myMix) * vec4(ourColor, 1.0);
} 
