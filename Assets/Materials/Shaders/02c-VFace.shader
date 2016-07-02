Shader "Unlit/Face Orientation"
{
    Properties
    {
        _ColorFront ("Front Color", Color) = (1,0.7,0.7,1)
        _ColorBack ("Back Color", Color) = (0.7,1,0.7,1)
    }
    SubShader
    {
        Pass
        {
            // turn off backface culling
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "UnityCG.cginc"

            float4 vert (float4 vertex : POSITION) : SV_POSITION
            {
//                return UnityObjectToClipPos(vertex);
				return mul(UNITY_MATRIX_MVP, float4(vertex.x, vertex.y, vertex.z, 1.0));	// http://forum.unity3d.com/threads/unityobjecttoclippos.400520/
            }

            fixed4 _ColorFront;
            fixed4 _ColorBack;

            fixed4 frag (fixed facing : VFACE) : SV_Target
            {
                // VFACE input positive for frontbaces,
                // negative for backfaces
                return facing > 0 ? _ColorFront : _ColorBack;
            }
            ENDCG
        }
    }
}
