

sampler2D _MainTex;
float4 _MainTex_ST;

half _Outline;

fixed4 _Direction;

fixed _GlitchSpeed;
fixed _Glitchfrequency;
fixed _GlitchIntensity;
fixed _GlitchBrightness;
fixed _GlitchDistance;
fixed _GlitchAreaScale;

struct vertexInput
{
    float4 vertex: POSITION;
    float4 uv: TEXCOORD0;
    float3 normal : NORMAL;
};

struct vertexOutput
{
    float4 pos: SV_POSITION;
    float4 uv: TEXCOORD0;
};

float4 CreateOutline(float4 vertPos, float Outline)
{
    float4x4 scaleMat;
    scaleMat[0][0] = 1.0f + Outline;
    scaleMat[0][1] = 0.0f;
    scaleMat[0][2] = 0.0f;
    scaleMat[0][3] = 0.0f;
    scaleMat[1][0] = 0.0f;
    scaleMat[1][1] = 1.0f + Outline;
    scaleMat[1][2] = 0.0f;
    scaleMat[1][3] = 0.0f;
    scaleMat[2][0] = 0.0f;
    scaleMat[2][1] = 0.0f;
    scaleMat[2][2] = 1.0f + Outline;
    scaleMat[2][3] = 0.0f;
    scaleMat[3][0] = 0.0f;
    scaleMat[3][1] = 0.0f;
    scaleMat[3][2] = 0.0f;
    scaleMat[3][3] = 0.0f;
				
    return mul(scaleMat, vertPos);
}

void _geom(triangle vertexInput input[3], inout TriangleStream<vertexInput> OutputStream, float range)
{
    vertexInput vert = (vertexInput)0;
    float4 worldPos;
    for (int i = 0; i < 3 ; i++)
    {
					
        worldPos = input[i].vertex;
        worldPos *= step(frac(mul(input[i].vertex, _Direction) * _Glitchfrequency / 100 + _Time.y * _GlitchSpeed), _GlitchAreaScale ) * range * _GlitchIntensity + _GlitchDistance;
        vert = input[i];
        float4 vertPos = worldPos;
        vert.vertex = UnityObjectToClipPos(vertPos);
					
        vert.normal = input[i].normal;
        vert.uv = input[i].uv;
        OutputStream.Append(vert);
    }
}


vertexOutput vert(vertexInput v)
{
    vertexOutput o;
    o.pos = CreateOutline(v.vertex, _Outline );
    o.uv.xy = (v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw);
    return o;
}

