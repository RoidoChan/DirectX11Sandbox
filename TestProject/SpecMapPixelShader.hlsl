//SimplePixelShader

#define STANDARD_PIXEL
#include "PixelShaderDefines.hlsl"

Texture2D diffTexture : register(t0);
Texture2D specTexture : register(t1);
SamplerState SampleType;

[earlydepthstencil]
float4 main(StandardPixelType input) : SV_TARGET0
{
	float3 norm = normalize(input.norm);
	float3 eyeVec = normalize(eyePos - input.worldPos.xyz);
	float4 diffSample = diffTexture.Sample(SampleType, input.tex);
	float4 specSample = specTexture.Sample(SampleType, input.tex);
	float4 accum = float4(0.0f, 0.0f, 0.0f, 1.0f);

	for (int i = 0; i < NUM_LIGHTS; i++)
	{
		float3 lightVec = lights[i].lightPos.xyz - input.worldPos.xyz;
		float distance = length(lightVec);
		lightVec = normalize(lightVec);
		float specFactor = saturate(SpecFactor(eyeVec, lightVec, norm, specComponent));
		float4 diffFactor = saturate(DiffFactor(lightVec, norm, diffSample));
		float lightIntensity = AttenuateLight(distance);

		accum += lights[i].lightColor * lightIntensity *  saturate(specFactor + diffFactor * diffColor);
	}

	float4 amb = float4(0.05f, 0.05f, 0.05f, 1.0f) * diffSample;
	return saturate(accum);
}