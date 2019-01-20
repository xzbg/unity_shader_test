// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MM/ImageSplit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _ColCount ("ColCount", int) = 4
        _RowCount ("RowCount", int) = 4
        _ColIndex ("ColIndex", int) = 0
        _RowIndex ("RowIndex", int) = 0
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Opaque" }
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            ZTest Off
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            int _ColIndex;
            int _RowIndex;
            int _ColCount;
            int _RowCount;
            // float4 _MainTex_ST;
            
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
                o.pos = UnityObjectToClipPos(v.vertex);
                
                // o.uv.x = (_ColIndex + v.texcoord.x) / _ColCount;
                // o.uv.y = (_RowIndex + v.texcoord.y) / _RowCount;
                
                // o.uv.x = _ColIndex / _ColCount + v.texcoord.x / _ColCount;
                // o.uv.y = _RowIndex / _RowCount + v.texcoord.y / _RowCount;

                // texcoord的x和y值是从0~1之间进行变换，除以划分的图集分数，表示每一份的变化量
                // 下标除以总分数，表示每一份的起始位置

                o.uv.x = _ColIndex * (1.0f / _ColCount) + v.texcoord.x * (1.0f / _ColCount);
                o.uv.y = _RowIndex * (1.0f / _RowCount) + v.texcoord.y * (1.0f / _RowCount);
                
                return o;
            }
            
            fixed4 frag(v2f i): SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
            
        }
    }
    Fallback "Transparent/VertexLit"
}
