﻿Shader "MM/HalfLambertMat"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            
            fixed4 _Diffuse;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                fixed3 worldNormal: TEXCOORD0;
            };
            
            void vert(a2v v, out v2f o)
            {
                // Transform the vertex from object space to projection space
                o.pos = UnityObjectToClipPos(v.vertex);
                // Transform the normal from object space to world space
                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
            }
            
            fixed4 frag(v2f i): SV_TARGET
            {
                // Get ambinet term
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                // Get the normal in world space
                fixed3 worldNormal = normalize(i.worldNormal);
                // Get the light direction in world space
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                // Compute diffuse term
                fixed3 halfLambert = dot(worldNormal, worldLightDir) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;
                
                fixed3 color = ambient + diffuse;
                
                return fixed4(color, 1.0);
            }
            
            
            ENDCG
            
        }
    }
    Fallback "Diffuse"
}
