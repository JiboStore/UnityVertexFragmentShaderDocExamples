// Tri-planar Texturing
// http://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html
Shader "MyShader/07-TriplanarTexturing"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" { }
		_Tiling("Tiling", float) = 1.0
		_OcclusionMap("Occlusion", 2D) = "white" { }
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			float _Tiling;
			sampler2D _OcclusionMap;

			struct v2f
			{
				float4 pos : SV_POSITION;
				half3 objNormal : TEXCOORD0;
				float3 coords : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			v2f vert ( float4 v : POSITION, float3 n : NORMAL, float2 uv : TEXCOORD0 )
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v);
				o.objNormal = n;
				o.coords = (v * _Tiling).xyz;
				o.uv = uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half3 blending = abs(i.objNormal);
				blending /= dot(blending, 1.0);
				fixed4 cx = tex2D(_MainTex, i.coords.yz);
				fixed4 cy = tex2D(_MainTex, i.coords.xz);
				fixed4 cz = tex2D(_MainTex, i.coords.xy);
				fixed4 c = cx * blending.x + cy * blending.y + cz * blending.z;
				c *= tex2D(_OcclusionMap, i.uv);
				return c;
			}
			ENDCG
		}
	}
}
