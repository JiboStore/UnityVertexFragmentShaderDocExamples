﻿Shader "Unlit/Show UVs"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert (
                float4 vertex : POSITION, // vertex position input
                float2 uv : TEXCOORD0 // first texture coordinate input
                )
            {
                v2f o;
//                o.pos = UnityObjectToClipPos(vertex);
				o.pos = mul(UNITY_MATRIX_MVP, float4(vertex.x, vertex.y, vertex.z, 1.0));	// http://forum.unity3d.com/threads/unityobjecttoclippos.400520/
                o.uv = uv;
                return o;
            }

			struct fragOutput {
			    fixed4 color : SV_Target;
			};         
			   
			fragOutput frag (v2f i)
			{
			    fragOutput o;
			    o.color = fixed4(i.uv, 0, 0);
			    return o;
			}

            ENDCG
        }
    }
}