Shader "K13A/TeslaWave"
{
    Properties
    {
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
        _Outline("Outline", Float) = 0.1
        _GlitchColor1("Glitch Color 1", Color) = (1,1,1,1)
		_GlitchColor2("Glitch Color 2", Color) = (1,1,1,1)
		_GlitchColor3("Glitch Color 3", Color) = (1,1,1,1)
		// Glitch
		_GlitchSpeed ("Glitch Speed", Vector) = (1,1,1,1)
		_Glitchfrequency ("Glitch Frequency", Float) = 1.0
		_GlitchDistance ("Glitch Distance", Float) = 0
		_GlitchAreaScale ("Glitch Area Scale", Range(-0.001,1)) = 0
		_GlitchIntensity ("Glitch Intensity", Float) = 0
		_GlitchBrightness ("Glitch Brightness", Float) = 0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

		

		// 외곽선 그리기
		Pass
		{
			Blend DstColor SrcAlpha  
			Cull Front // 뒷면만 그리기
			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom

			half _Outline;
			fixed4 _GlitchColor1;
			fixed4 _GlitchSpeed;
			fixed _Glitchfrequency;
			fixed _GlitchIntensity;
			fixed _GlitchBrightness;
			fixed _GlitchDistance;
			fixed _GlitchAreaScale;
			sampler2D _MainTex;
			float4 _MainTex_ST;

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

			float4x4 GetRotationMatrix(float xRadian, float yRadian, float zRadian)
            {
                float sina, cosa;
                sincos(xRadian, sina, cosa);

                float4x4 xMatrix;

                xMatrix[0] = float4(1, 0, 0, 0);
                xMatrix[1] = float4(0, cosa, -sina, 0);
                xMatrix[2] = float4(0, sina, cosa, 0);
                xMatrix[3] = float4(0, 0, 0, 1);

                sincos(yRadian, sina, cosa);

                float4x4 yMatrix;

                yMatrix[0] = float4(cosa, 0, sina, 0);
                yMatrix[1] = float4(0, 1, 0, 0);
                yMatrix[2] = float4(-sina, 0, cosa, 0);
                yMatrix[3] = float4(0, 0, 0, 1);

                sincos(zRadian, sina, cosa);

                float4x4 zMatrix;

                zMatrix[0] = float4(cosa, -sina, 0, 0);
                zMatrix[1] = float4(sina, cosa, 0, 0);
                zMatrix[2] = float4(0, 0, 1, 0);
                zMatrix[3] = float4(0, 0, 0, 1);

                return mul(mul(yMatrix, xMatrix), zMatrix);
            }

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

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = CreateOutline(v.vertex, _Outline );
				o.uv.xy = (v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}
			float4 RotateAroundYInDegrees (float4 vertex, float degrees)
	         {
	             float alpha = degrees * 3.14 / 180.0;
	             float sina, cosa;
	             sincos(alpha, sina, cosa);
	             float2x2 m = float2x2(cosa, -sina, sina, cosa);
	             return float4(mul(m, vertex.xz), vertex.yw).xzyw;
	         }

			[maxvertexcount(6)]
			void geom(triangle vertexInput input[3], inout TriangleStream<vertexInput> OutputStream)
			{
				vertexInput vert = (vertexInput)0;
				float4 worldPos;
				for (int i = 0; i < 3 ; i++)
				{
					
					worldPos = input[i].vertex;
					worldPos *= step(frac(input[i].vertex.y * _Glitchfrequency / 100 + _Time.y * _GlitchSpeed), _GlitchAreaScale ) * 0.1 * _GlitchIntensity + _GlitchDistance;
					vert = input[i];
					float4 vertPos = worldPos;
					vert.vertex = UnityObjectToClipPos(vertPos);
					
					vert.normal = input[i].normal;
					vert.uv = input[i].uv;
					OutputStream.Append(vert);
				}
			} // Unity Rotation Reference : https://www.sysnet.pe.kr/2/0/11640


			half4 frag(vertexOutput i) : COLOR
			{
				return tex2D(_MainTex, i.uv) * _GlitchColor1 * _GlitchBrightness;
			}

			ENDCG
		}

Pass
		{
			Blend DstColor SrcAlpha  
			Cull Front // 뒷면만 그리기
			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom

			half _Outline;
			fixed4 _GlitchColor2;
			fixed4 _GlitchSpeed;
			fixed _Glitchfrequency;
			fixed _GlitchIntensity;
			fixed _GlitchBrightness;
			fixed _GlitchDistance;
			fixed _GlitchAreaScale;
			sampler2D _MainTex;
			float4 _MainTex_ST;

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

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = CreateOutline(v.vertex, _Outline );
				o.uv.xy = (v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}

			[maxvertexcount(6)]
			void geom(triangle vertexInput input[3], inout TriangleStream<vertexInput> OutputStream)
			{

				vertexInput vert = (vertexInput)0;
				float4 worldPos;
				for (int i = 0; i < 3 ; i++)
				{
					worldPos = input[i].vertex;
					worldPos *= step(frac(input[i].vertex.y * _Glitchfrequency / 100 + _Time.y * _GlitchSpeed), _GlitchAreaScale ) * 0.05 * _GlitchIntensity + _GlitchDistance;
					vert = input[i];
					float4 vertPos = worldPos;
					vert.vertex = UnityObjectToClipPos(vertPos);
					
					vert.normal = input[i].normal;
					vert.uv = input[i].uv;
					OutputStream.Append(vert);
				}
			}


			half4 frag(vertexOutput i) : COLOR
			{
				return tex2D(_MainTex, i.uv) * _GlitchColor2 * _GlitchBrightness;
			}

			ENDCG
		}

Pass
		{
			Blend DstColor SrcAlpha   
			Cull Front // 뒷면만 그리기
			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom

			half _Outline;
			fixed4 _GlitchColor3;
			fixed4 _GlitchSpeed;
			fixed _Glitchfrequency;
			fixed _GlitchIntensity;
			fixed _GlitchBrightness;
			fixed _GlitchDistance;
			fixed _GlitchAreaScale;
			sampler2D _MainTex;
			float4 _MainTex_ST;

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

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = CreateOutline(v.vertex, _Outline );
				o.uv.xy = (v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw); 
				return o;
			}

			[maxvertexcount(6)]
			void geom(triangle vertexInput input[3], inout TriangleStream<vertexInput> OutputStream)
			{

				vertexInput vert = (vertexInput)0;
				float4 worldPos;
				for (int i = 0; i < 3 ; i++)
				{
					worldPos = input[i].vertex;
					worldPos *= step(frac(input[i].vertex.y * _Glitchfrequency / 100 + _Time.y * _GlitchSpeed), _GlitchAreaScale ) * 0.15 * _GlitchIntensity + _GlitchDistance;
					vert = input[i];
					float4 vertPos = worldPos;
					vert.vertex = UnityObjectToClipPos(vertPos);
					
					vert.normal = input[i].normal;
					vert.uv = input[i].uv;
					OutputStream.Append(vert);
				}
			}


			half4 frag(vertexOutput i) : COLOR
			{
				return tex2D(_MainTex, i.uv) * _GlitchColor3 * _GlitchBrightness;
			}

			ENDCG
		}
/*
Pass
		{
			Blend DstColor SrcColor 
			Cull Front // 뒷면만 그리기
			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom

			half _Outline;
			fixed4 _GlitchColor1;
			fixed4 _GlitchColor2;
			fixed4 _GlitchColor3;
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

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(CreateOutline(v.vertex, _Outline ));
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}

			[maxvertexcount(12)]
			void geom(triangle vertexInput input[3], inout TriangleStream<vertexInput> OutputStream)
			{
				for (int i = 0; i < 3 ; i++)
				{
					vertexInput vert = input[i];
					vert.vertex += (0,0, step(frac(UnityObjectToClipPos(mul(unity_WorldToObject, input[i].vertex)).y * 0.5 + _Time.y * 0.5), 0.3) * 0.15);
					OutputStream.Append(vert);
				}
			}


			half4 frag(vertexOutput i) : COLOR
			{
				return 1.5;
			}

			ENDCG
		}
*/

//Original
		Pass
		{
			Blend OneMinusDstColor One

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

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

			ENDCG
		}

		//Original
		Pass
		{
			Blend One OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

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

			ENDCG
		}

    }
    FallBack "Diffuse"
}
