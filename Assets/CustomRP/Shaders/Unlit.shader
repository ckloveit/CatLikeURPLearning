Shader "Custom RP/Unlit"
{
    Properties
    {
	   _BaseColor("Color", Color) = (1.0,1.0,1.0,1.0)
	   _BaseMap("Texture", 2D) = "white"{}

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
			Blend [_SrcBlend] [_DestBlend]
			ZWrite [_ZWrite]

            HLSLPROGRAM
			#include "../ShaderLibrary/UnlitPass.hlsl"
		    #pragma shader_feature _CLIPPING
			#pragma multi_compile_instancing
			#pragma vertex UnlitPassVertex
			#pragma fragment UnlitPassFragment

			ENDHLSL
        }
    }
}
