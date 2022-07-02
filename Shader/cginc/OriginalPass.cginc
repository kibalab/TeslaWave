half4 _Color;
sampler2D _MainTex;
float4 _MainTex_ST;

struct vertexInput
{
    float4 vertex: POSITION;
    float4 texcoord: TEXCOORD0;
};

struct vertexOutput
{
    float4 pos: SV_POSITION;
    float4 texcoord: TEXCOORD0;
};

vertexOutput vert(vertexInput v)
{
    vertexOutput o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
    return o;
}

half4 frag(vertexOutput i) : COLOR
{
    return tex2D(_MainTex, i.texcoord) * _Color;
}
