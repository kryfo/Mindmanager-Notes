Shader "Hidden/sAlphaTeST"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_alphaValue_Base ("alphaValue", float) = 0.1
		_alphaValue_Top ("alphaValue", float) = 0.1
		_Alpha ("alpha", 2D) = "white" {}
	
	}
	SubShader
	{


		Tags {"Queue" = "Geometry"
		"IgnoreProjector" = "True"
		"RenderType" = "TransparentCutout"
				
		} 
	
		Pass
		{

			// No culling or depth
			Cull Off ZWrite off ZTest LEqual 
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _Alpha;
			float _alphaValue_Base;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 alp = tex2D(_Alpha, i.uv);
				// just invert the colors
				//col.rgb = 1 - col.rgb;
				col.a = alp.r;
				if (col.a < _alphaValue_Base ){
					return fixed4(0,0,0,0);
				}

				return col;
			}
			ENDCG
		}

		Pass
		{

			// No culling or depth
			Cull Off ZWrite on ZTest LEqual 
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _Alpha;
			float _alphaValue_Top;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 alp = tex2D(_Alpha, i.uv);
				// just invert the colors
				//col.rgb = 1 - col.rgb;
				col.a = alp.r;
				if (col.a < _alphaValue_Top ){
					return fixed4(0,0,0,0);
				}

				return col;
			}
			ENDCG
		}
	}
}
