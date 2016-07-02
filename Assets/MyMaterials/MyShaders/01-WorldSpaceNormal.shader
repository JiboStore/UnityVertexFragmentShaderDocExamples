Shader "MyShader/01-WorldSpaceNormal" 
{
	// no material properties needed

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
				float3 worldNormal : NORMAL;
				float4 pos : SV_POSITION;
			};

			v2f vert ( float4 vertex : POSITION, float4 normal : NORMAL )
			{
				v2f o;
				o.pos = mul ( UNITY_MATRIX_MVP, vertex );
//				o.worldNormal = normal;	// just the same
				o.worldNormal = UnityObjectToWorldNormal(normal); // need UnityCG.cginc
				return o;
			}

			float3 frag ( v2f input ) : SV_Target
			{
				float3 col;
				col = input.worldNormal * 0.5 + 0.5;
				return col;
			}
			ENDCG
		}
	}
}