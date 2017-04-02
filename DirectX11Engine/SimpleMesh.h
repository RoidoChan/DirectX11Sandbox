//SimpleMesh.h
#pragma once
#include <DirectXMath.h>
using namespace DirectX;

struct ID3D11Buffer;
struct ID3D11Device;
struct ID3D11DeviceContext;
struct ProcessedMeshData;
struct ProcessedNormalMappedMeshData;

class SimpleMesh
{
public:
	SimpleMesh(): mVertBuffer(nullptr), mIndexBuffer(nullptr) {};
	~SimpleMesh() {};
	SimpleMesh(const SimpleMesh&) = delete;
	SimpleMesh(const SimpleMesh&&) = delete;

	bool Init(ID3D11Device* device, ProcessedMeshData* mesh);
	void Shutdown();
	void Render(ID3D11DeviceContext* context);
	void RenderBoundingBox(ID3D11DeviceContext* context);

	int GetIndexCount( ) const { return mIndexCount; }
	int GetMaterialIndex() const { return mMaterialIndex; }
	bool GetIsMapped() const { return mIsNormalMapped; }
	

	ID3D11Buffer* GetVertBuffer()  { return mVertBuffer; }
	ID3D11Buffer* GetIndexBuffer()  { return mIndexBuffer; }

	XMFLOAT3 GetBoxMin() const { return min; }
	XMFLOAT3 GetBoxMax() const { return max; }

private:
	bool InitBoundingBox(ID3D11Device* device);
	bool InitBuffers(ID3D11Device* device, ProcessedMeshData* mesh);
	void ShutdownBuffers();

	ID3D11Buffer* mVertBuffer = nullptr;
	ID3D11Buffer* mNormalBuffer = nullptr;
	ID3D11Buffer* mUvBuffer = nullptr;
	ID3D11Buffer* mTangentBuffer = nullptr;
	ID3D11Buffer* mIndexBuffer = nullptr;

	ID3D11Buffer* mAABBVertBuffer;
	ID3D11Buffer* mAABBIndexBuffer;

	int mMaterialIndex;
	int mVertCount;
	int mIndexCount;

	bool mIsNormalMapped = false;

	XMFLOAT3 min;
	XMFLOAT3 max;
};
