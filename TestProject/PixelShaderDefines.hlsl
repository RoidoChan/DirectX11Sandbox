

//PIXEL INPUT TYPES ////////////////////////////////////////////////////////////////////////////////////

#ifdef NORMAL_MAP_PIXEL

struct NormalMapPixelType
{
	float4 pos : SV_POSITION;
	float4 worldPos : POSITION;
	float3 norm : NORMAL;
	float2 tex : TEXCOORD0;
	float3 tangent : TANGENT;
};

#endif

#ifdef STANDARD_PIXEL

struct StandardPixelType
{
	float4 pos : SV_POSITION;
	float4 worldPos : POSITION;
	float3 norm : NORMAL;
	float2 tex : TEXCOORD0;
};

#endif

//CONSTANT BUFFER TYPES/////////////////////////////////////////////////////////////////////////////

struct Light
{
	float4 lightPos;
	float4 lightColor;
};

static const int NUM_LIGHTS = 400;

cbuffer LightPositions : register(b0)
{
	Light lights[400];
};

cbuffer Eye : register(b1)
{
	float3 eyePos;
};

cbuffer MaterialProperties : register(b2)
{
	float4 diffColor;
	float4 specColor;
	float specComponent;
};

//FUNCTIONS///////////////////////////////////////////////////////////////////////////////////////////

float4 SampleNormalMap(float3 normal, float3 tangent, float4 normalSample)
{
	float3 norm = normalize(normal);
	float3 tan = normalize(tangent);

	//expand normal
	normalSample = (2.0f * normalSample) - 1.0f;

	float3 biTan = normalize(cross(normal, tangent));

	float4x4 tangentSpace = float4x4(float4(tangent, 0.0f),
							float4(biTan, 0.0f),
							float4(normal, 0.0f),
							float4(0.0f, 0.0f, 0.0f, 1.0f));

	return mul(normalSample, tangentSpace);
}

float4 DiffFactor(float3 lightVec, float3 newNorm, float4 diffSample)
{
	float diffCoeff = saturate(dot(lightVec, newNorm));
	float4 diffFactor = diffCoeff * diffSample;
	return diffFactor;
}

float SpecFactor(float3 eyeVec, float3 lightVec, float3 norm, float specComponent)
{
	float3 halfVec = normalize(lightVec + eyeVec);
	float intensity = saturate(dot(halfVec, norm));
	float specCoeff = pow(intensity, specComponent);
	return specCoeff;
}


float AttenuateLight(float dist)
{
	return 1.0f / (1.0f + 0.005f * dist + 0.005f * dist * dist);
}
