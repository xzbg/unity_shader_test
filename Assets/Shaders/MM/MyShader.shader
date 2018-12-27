// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MM/MyShader"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
        _Alpha ("Color Alpha", Range(0, 1.0)) = 1.0
        _MainText ("MainTex", 2d) = "white" { }
        _MainText1 ("MainTex1", 3d) = "white" { }
        _MainText2 ("MainTex2", 2d) = "bump" { }
        _BumpScale ("BumpScale", Float) = 1.0
        _BumpScale1 ("BumpScale1", Int) = 1.0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
            
            #pragma vertex vert
            #pragma fragment frag
            fixed4 _Color;
            float _Alpha;
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 texcoord: TEXCOORD0;
            };
            
            struct v2f
            {
                float3 color: COLOR0;
                float4 vertex: SV_POSITION;
            };
            
            v2f vert(a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
                return o;
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                fixed3 c = i.color;
                c *= _Color.rgb;
                return fixed4(c, _Color.a);
            }
            ENDCG
            
        }
    }
}
