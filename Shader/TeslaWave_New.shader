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

		

		// Wavw 1
		Pass
		{
			Blend DstColor SrcAlpha  
			Cull Front // 뒷면만 그리기
			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom
			#include "./cginc/TeslaWave.cginc"

			fixed4 _GlitchColor1;

			[maxvertexcount(6)]
			void geom(triangle vertexInput input[3], inout TriangleStream<vertexInput> OutputStream)
			{
				_geom(input, OutputStream, 0.1f);
			}

			half4 frag(vertexOutput i) : COLOR { return tex2D(_MainTex, i.uv) * _GlitchColor1 * _GlitchBrightness; }

			ENDCG
		}

		// Wavw 2
		Pass
		{
			Blend DstColor SrcAlpha  
			Cull Front // 뒷면만 그리기
			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom
			#include "./cginc/TeslaWave.cginc"

			fixed4 _GlitchColor2;

			[maxvertexcount(6)]
			void geom(triangle vertexInput input[3], inout TriangleStream<vertexInput> OutputStream)
			{
				_geom(input, OutputStream, 0.05f);
			}

			half4 frag(vertexOutput i) : COLOR { return tex2D(_MainTex, i.uv) * _GlitchColor2 * _GlitchBrightness; }

			ENDCG
		}

		// Wavw 3
		Pass
		{
			Blend DstColor SrcAlpha  
			Cull Front // 뒷면만 그리기
			ZWrite Off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom
			#include "./cginc/TeslaWave.cginc"

			fixed4 _GlitchColor3;

			[maxvertexcount(6)]
			void geom(triangle vertexInput input[3], inout TriangleStream<vertexInput> OutputStream)
			{
				_geom(input, OutputStream, 0.15f);
			}

			half4 frag(vertexOutput i) : COLOR { return tex2D(_MainTex, i.uv) * _GlitchColor3 * _GlitchBrightness; }

			ENDCG
		}

		//Original
		Pass
		{
			Blend One OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "./cginc/OriginalPass.cginc"
			ENDCG
		}

    }
    FallBack "Diffuse"
}
