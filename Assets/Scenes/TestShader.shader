// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MM/TestShader"
{
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
                float4 pos: SV_POSITION;
                fixed4 color: COLOR0;
            };
            
            void vert(appdata_full v, out v2f o)
            {
                o.pos = UnityObjectToClipPos(v.vertex);
                // 可视化法线方向
                o.color = fixed4(v.normal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
            }
            
            fixed4 frag(v2f i): SV_TARGET
            {
                return i.color;
            }
            
            ENDCG
            
        }
    }
}