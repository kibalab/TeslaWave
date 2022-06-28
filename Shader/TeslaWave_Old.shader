Shader "K13A/Old/TeslaWave"
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
		_GlitchSpeed ("Glitch Speed", Float) = 1.0
		_Glitchfrequency ("Glitch Frequency", Float) = 1.0
		_GlitchDistance ("Glitch Distance", Float) = 0
		_GlitchAreaScale ("Glitch Area Scale", Float) = 0
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
			fixed _GlitchSpeed;
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
					vert.vertex += (0,0, step(frac(UnityObjectToClipPos(mul(unity_WorldToObject, input[i].vertex)).y * _Glitchfrequency / 100 + _Time.y * _GlitchSpeed), _GlitchAreaScale ) * 0.1 * _GlitchIntensity + _GlitchDistance);
					OutputStream.Append(vert);
				}
			}


			half4 frag(vertexOutput i) : COLOR
			{
				return tex2D(_MainTex, i.texcoord) * _GlitchColor1 * _GlitchBrightness;
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
			fixed _GlitchSpeed;
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
					vert.vertex += (0,0, step(frac(UnityObjectToClipPos(mul(unity_WorldToObject, input[i].vertex)).y  * _Glitchfrequency / 100 + _Time.y * _GlitchSpeed), _GlitchAreaScale ) * 0.05 * _GlitchIntensity + _GlitchDistance);
					OutputStream.Append(vert);
				}
			}


			half4 frag(vertexOutput i) : COLOR
			{
				return tex2D(_MainTex, i.texcoord) * _GlitchColor2 * _GlitchBrightness;
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
			fixed _GlitchSpeed;
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
				o.pos = UnityObjectToClipPos(CreateOutline(v.vertex, _Outline ));
				o.uv.xy = (v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw); 
				return o;
			}

			[maxvertexcount(12)]
			void geom(triangle vertexInput input[3], inout TriangleStream<vertexInput> OutputStream)
			{
				for (int i = 0; i < 3 ; i++)
				{
					vertexInput vert = input[i];
					vert.vertex += (0,0, step(frac(UnityObjectToClipPos(mul(unity_WorldToObject, input[i].vertex)).y * _Glitchfrequency / 100 + _Time.y * _GlitchSpeed), _GlitchAreaScale ) * 0.15 * _GlitchIntensity + _GlitchDistance);
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
			Blend DstColor SrcColor 

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
