﻿Shader "MyShader/08-LightingSimpleDiffuse"
{
	Properties
	{
		[NoScaleOffset]
		_MainTex("Main Texture", 2D) = "white" {}
	}

	SubShader
	{
		Pass
		{
			Tags
			{
				// indicate that our pass is the "base" pass in forward
				// rendering pipeline. It gets ambient and main directional
				// light data set up; light direction in _WorldSpaceLightPos0
				// and color in _LightColor0
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"				// for UnityObjectToWorldNormal
			#include "UnityLightingCommon.cginc"	// for _LightColor0

			struct v2f
			{
				float2 uv : TEXCOORD0;
				fixed4 diff : COLOR0;	// diffuse lighting color
				float4 pos : SV_POSITION;
			};

			v2f vert( appdata_base v )
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord;
				// get vertex normal in world space
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				// dot product between normal and light direction for
				// standard diffuse (Lambert) lighting
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));	// original
//				half nl = dot(worldNormal, _WorldSpaceLightPos0.xyz);	// test
				// factor in the light color
				o.diff = nl * _LightColor0;
				return o;
			}

			sampler2D _MainTex;
			fixed4 frag(v2f i) : SV_Target
			{
				// sample texture
				fixed4 c = tex2D(_MainTex, i.uv);
				// multiply by lighting
				c *= i.diff;
				return c;
			}
			ENDCG
		}
	}
}
