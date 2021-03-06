//SpecMapShader.h
#pragma once
#include "Defines.h"
#include <Shader.h>


struct ID3D11Buffer;
struct ID3D11SamplerState;
struct ID3D11ShaderResourceView;
struct ID3D11DeviceContext;


class SpecMapShader : public Shader
{
public:
	SpecMapShader() : mMatrixBuffer(0),
		mLightBuffer(0),
		mMaterialBuffer(0) {};

	SpecMapShader(const SpecMapShader&) = delete;
	~SpecMapShader() { Shutdown(); }

	bool Init(ID3D11Device* device, HWND hwnd, unsigned int numLights);
	void Shutdown();
	bool PrepareShader(ID3D11DeviceContext* deviceContext);
	bool SetConstantShaderParameters(void* data, ID3D11DeviceContext* deviceContext);
	bool SetPerMeshParameters(void* data, ID3D11DeviceContext* deviceContext);
private:
private:
	ID3D11Buffer* mMatrixBuffer;
	ID3D11Buffer* mLightBuffer;
	ID3D11Buffer* mEyeBuffer;
	ID3D11Buffer* mMaterialBuffer;

	static const int MATRIX_BUFFER = 0;
	static const int LIGHT_BUFFER = 0;
	static const int EYE_BUFFER = 1;
	static const int MATERIAL_BUFFER = 2;

	int mNumLights;
};
