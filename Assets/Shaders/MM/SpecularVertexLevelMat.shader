Shader "MM/SpecularVertexLevelMat"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20
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
            
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                fixed3 color: COLOR;
            };
            
            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;
            
            void vert(a2v v, out v2f o)
            {
                // Tranform the vertex from object space to projection space
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                // Get ambient term
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                // Tranform the normal from object space to world space
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)_World2Object));
                // Get the light direction in world space
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
            
        }
    }
}
