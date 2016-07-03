// http://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
// Environment Reflection with a Normal Map
Shader "MyShader/02-SkyReflectionPerPixel"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float3 worldPos : TEXCOORD0;
				half3 worldNormal : TEXCOORD1;
			};

			v2f vert( float4 v : POSITION, float3 n : NORMAL )
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v);
				o.worldPos = mul(_Object2World, v).xyz;
				o.worldNormal = UnityObjectToWorldNormal(n);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// compute view direction and reflection vector per pixel here
				half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				half3 worldRefl = reflect(-worldViewDir, i.worldNormal);

				// same as in 02-SkyReflection.shader's pixel shader
				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
				half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);
				fixed4 c = 0;
				c.xyz = skyColor;
				return c;
			}
			ENDCG
		}
	}
}