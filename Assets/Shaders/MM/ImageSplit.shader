Shader "MM/ImageSplit"
{
    Properties
    {
        _MainTex ("Main Tex", 2D) = "white" { }
        _ColCount ("Column Count", int) = 4
        _RowCount ("Row Count", int) = 4
        _ColIndex ("Col Index", int) = 0
        _RowIndex ("Row Index", int) = 0
    }
    
    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            ZTest off
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            int _ColCount;
            int _RowCount;
            int _ColIndex;
            int _RowIndex;
            
            struct a2v
            {
                float4 vertex: POSITION;
                float2 texcoord: TEXCOORD0;
            };
            
            
            struct v2f
            {
                float4 pos: SV_POSITION;
                float2 uv: TEXCOORD0;
            };
            
            
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                
                o.uv.x = (_ColIndex + v.texcoord.x) / _ColCount;
                o.uv.y = (_RowIndex + v.texcoord.y) / _RowCount;
                return o;
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.uv);
                return c;
            }
            ENDCG
            
        }
    }
    FallBack "Transparent/VertexLit"
}
