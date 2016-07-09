//Shader "MyShader/13-Fogs" {
//    SubShader {
//        Pass {
//            CGPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//            
//            //Needed for fog variation to be compiled.
//            #pragma multi_compile_fog
//
//            #include "UnityCG.cginc"
//
//            struct vertexInput {
//                float4 vertex : POSITION;
//                float4 texcoord0 : TEXCOORD0;
//            };
//
//            struct fragmentInput{
//                float4 position : SV_POSITION;
//                float4 texcoord0 : TEXCOORD0;
//                
//                //Used to pass fog amount around number should be a free texcoord.
//                UNITY_FOG_COORDS(1)
//            };
//
//            fragmentInput vert(vertexInput i){
//                fragmentInput o;
//                o.position = mul (UNITY_MATRIX_MVP, i.vertex);
//                o.texcoord0 = i.texcoord0;
//                
//                //Compute fog amount from clip space position.
//                UNITY_TRANSFER_FOG(o,o.position);
//                return o;
//            }
//
//            fixed4 frag(fragmentInput i) : SV_Target {
//                fixed4 color = fixed4(i.texcoord0.xy,0,0);
//                
//                //Apply fog (additive pass are automatically handled)
//                UNITY_APPLY_FOG(i.fogCoord, color); 
//                
//                //to handle custom fog color another option would have been 
//                //#ifdef UNITY_PASS_FORWARDADD
//                //  UNITY_APPLY_FOG_COLOR(i.fogCoord, color, float4(0,0,0,0));
//                //#else
//                //  fixed4 myCustomColor = fixed4(0,0,1,0);
//                //  UNITY_APPLY_FOG_COLOR(i.fogCoord, color, myCustomColor);
//                //#endif
//                
//                return color;
//            }
//            ENDCG
//        }
//    }
//}

Shader "MyShader/13-Fogs"
{
	Properties
	{
		[NoScaleOffset]
		_MainTex("Main Texture", 2D) = "empty" { }
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// needed for fog variation to be compiled.
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;

				// used to pass fog amount around number should be a free texcoord.
				UNITY_FOG_COORDS(1)
			};

			v2f vert(appdata_base i)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
				o.uv = i.texcoord;

				// compute fog amount from clip space position
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 c = fixed4(i.uv.xy, 0.0, 0.0);

				// Apply fog (additive pass are automatically handled)
				UNITY_APPLY_FOG(i.fogCoord, c);

				return c;
			}
			ENDCG
		}
	}
}
