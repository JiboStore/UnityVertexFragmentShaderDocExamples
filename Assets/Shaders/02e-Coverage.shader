﻿Shader "Unlit/Coverage"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            #include "UnityCG.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
            };

            v2f vert (float4 vertex : POSITION)
            {
                v2f o;
//                o.pos = UnityObjectToClipPos(vertex);
				o.pos = mul(UNITY_MATRIX_MVP, float4(vertex.x, vertex.y, vertex.z, 1.0));	// http://forum.unity3d.com/threads/unityobjecttoclippos.400520/
                return o;
            }

            fixed4 frag (v2f i, uint cov : SV_Coverage) : SV_Target
            {
            	return cov * 0.1;
            }
            ENDCG
        }
    }
}
