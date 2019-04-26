// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "JZYX/UI/FrameAnimAlphaBlend"
{
    Properties
    {
        _Color ("Base Color", Color) = (1, 1, 1, 1)
        _MainTex ("Base(RGB)", 2D) = "white" { }
        _Speed ("播放速度", Float) = 30
        _SizeX ("列数", Float) = 12
        _SizeY ("行数", Float) = 1
        _Random ("Random", Range(1, 20)) = 1
        
        [Enum(UnityEngine.Rendering.BlendMode)] _SourceBlend ("Source Blend Mode", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _DestBlend ("Dest Blend Mode", Float) = 10
        
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        
        _ColorMask ("Color Mask", Float) = 15
        
        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
    }
    
    SubShader
    {
        tags { "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        Lighting Off ZWrite Off
        ColorMask [_ColorMask]
        ZTest [unity_GUIZTestMode]
        Blend[_SourceBlend][_DestBlend]
        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityUI.cginc"
            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            
            float4 _Color;
            sampler2D _MainTex;
            fixed _Speed;
            fixed _SizeX;
            fixed _SizeY;
            fixed _Random;
            float4 _ClipRect;
            
            struct v2f
            {
                float4 pos: POSITION;
                float4 uv: TEXCOORD0;
                float4 worldPosition: TEXCOORD1;
            };
            
            
            struct appdata
            {
                float4 vertex: POSITION;
                float4 texcoord: TEXCOORD;
            };
            
            
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                
                return o;
            }
            
            float2 AnimationUV(float2 uv)
            {
                
                int index = floor(_Time.y * _Speed + _Random);
                index = fmod(index, _SizeX * _SizeY);
                int indexY = index / _SizeX;
                int indexX = index - indexY * _SizeX;
                float2 testUV = float2(uv.x / _SizeX, uv.y / _SizeY);
                
                testUV.x += indexX / _SizeX;
                testUV.y += indexY / _SizeY;
                return testUV;
            }
            
            half4 frag(v2f i): COLOR
            {
                half4 c = tex2D(_MainTex, AnimationUV(i.uv.xy)) * _Color;
                #ifdef UNITY_UI_CLIP_RECT
                    c.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
                #endif
                return c;
            }
            
            ENDCG
            
        }
    }
}