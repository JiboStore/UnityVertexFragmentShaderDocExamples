Shader "MyShader/09-LightingSimpleDiffuseWithAmbient"
{
	Properties
	{
		[NoScaleOffset]
		_MainTex ( "Main Texture", 2D ) = "white" { }
	}

	SubShader
	{
		Pass
		{
			Tags
			{
				// indicate that our pass is the "base" pass in forward
				// rendering pipeline. It gets ambient and main directional
				// light data set up. light direction in _WorldSpaceLightPos0
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
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 diff : COLOR0;	// diffuse lighting color
			};

			v2f vert ( appdata_base i )
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
				o.uv = i.texcoord;
				// get vertex normal in world space
				float3 worldNormal = UnityObjectToWorldNormal(i.normal);
				// dot product between normal and light direction for
				// standard diffuse (Lambert) lighting
				float nl = dot(worldNormal, _WorldSpaceLightPos0);
				// factor in the light color
				o.diff = nl * _LightColor0;

				// the only difference from previous (08-LightingSimpleDiffuse) shader
				// in addition to the diffuse lighting from the main light,
				// add illumination from ambient or light probes
				// ShadeSH9 function from UnityCG.cginc evaluates it,
				// using world space normal
				o.diff.rgb += ShadeSH9(half4(worldNormal, 1));
				return o;
			}

			sampler2D _MainTex;

			float4 frag(v2f i) : SV_Target
			{
				float4 c;
				// sample texture
				c = tex2D(_MainTex, i.uv);
				// multiply by lighting
				c *= i.diff;
				return c;
			}
			ENDCG
		}
	}
}
