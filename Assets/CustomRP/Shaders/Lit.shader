Shader "Custom RP/Lit"
{
    Properties
    {
	   _BaseColor("Color", Color) = (1.0,1.0,1.0,1.0)
	   _BaseMap("Texture", 2D) = "white"{}
	   _Metallic("Metallic", Range(0, 1)) = 0
	   _Smoothness("Smoothness", Range(0, 1)) = 0.5

	   [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend", Float) = 1
	   [Enum(UnityEngine.Rendering.BlendMode)] _DestBlend("Dest Blend", Float) = 1
	   [Enum(off, 0, on, 1)] _ZWrite("Z Write", Float) = 1
	   _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5
	   [Toggle(_CLIPPING)] _Clipping("Alpha Clipping", Float) = 0

	}

    SubShader
    {
        
        Pass
        {
			Tags
			{
				"LightMode" = "CustomLit"
			}

			Blend [_SrcBlend] [_DestBlend]
			ZWrite [_ZWrite]

            HLSLPROGRAM
			#pragma target 3.5
			#include "../ShaderLibrary/LitPass.hlsl"
		    #pragma shader_feature _CLIPPING
			#pragma multi_compile_instancing
			#pragma vertex LitPassVertex
			#pragma fragment LitPassFragment

			ENDHLSL
        }
    }
}
