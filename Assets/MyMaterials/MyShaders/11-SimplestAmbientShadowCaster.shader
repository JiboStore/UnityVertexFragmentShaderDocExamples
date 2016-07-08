Shader "MyShader/11-SimplestAmbientShadowCaster"
{
	SubShader
	{
		// very simple lighting pass, that only does non-textured ambient
		// actually doesn't matter what pass this is
		// the important one for shadow is the ShadowCaster pass
		Pass
		{
			Tags {
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"
			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 light : COLOR0;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				// only evaluate ambient, just for simplicity
				o.light.rgb = ShadeSH9(half4(worldNormal, 1));
				o.light.a = 1;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 c;
				c = i.light;
				return c;
			}
			ENDCG
		}

		// shadow caster rendering pass, implemented manually using macros from UnityCG.cginc
		Pass
		{
			Tags
			{
				// this is important
				"LightMode" = "ShadowCaster"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// I don't know what this is for, it is still working even if commented
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"
			// we don't really need anything from LightingCommon
//			#include "UnityLightingCommon.cginc"

			struct v2f
			{
				V2F_SHADOW_CASTER;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
	}
}
