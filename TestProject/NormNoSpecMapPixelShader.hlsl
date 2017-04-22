//SimplePixelShader
#define NORMAL_MAP_PIXEL

#include "PixelShaderDefines.hlsl"

Texture2D diffTexture : register(t0);
Texture2D normTexture : register(t1);

SamplerState SampleType;


float4 main(NormalMapPixelType input) : SV_TARGET0
{
	float3 lightVec = normalize(lights[0].lightPos.xyz - input.worldPos.xyz);
	float distance = length(lights[0].lightPos - input.worldPos);
	float3 eyeVec = normalize(eyePos - input.worldPos.xyz);

	float4 diffSample = diffTexture.Sample(SampleType, input.tex);
	float4 normSample = normTexture.Sample(SampleType, input.tex);

	float4 norm = SampleNormalMap(input.norm, input.tangent, normSample);

	float4 accum = float4(0.0f, 0.0f, 0.0f, 1.0f);

	[loop]
	for (int i = 0; i < 200; i++)
	{
		float3 lightVec = normalize(lights[i].lightPos.xyz - input.worldPos.xyz);
		float distance = length(lights[i].lightPos.xyz - input.worldPos.xyz);
		float4 diffFactor = DiffFactor(lightVec, norm.xyz, diffSample);
		float lightIntensity = AttenuateLight(distance);

		accum += lights[i].lightColor * lightIntensity *  (diffFactor * diffColor);
	}

	float4 amb = float4(0.1f, 0.1f, 0.1f, 1.0f) * diffSample;

	return saturate(amb + accum);
}