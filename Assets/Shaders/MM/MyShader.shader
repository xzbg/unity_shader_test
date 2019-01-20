// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MM/MyShader"
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
            
            #include "UnityCG.cginc"
            #pragma vertex vert
            #pragma fragment frag
            
            sampler2D _MainTex;
            int _ColIndex;
            int _RowIndex;
            int _ColCount;
            int _RowCount;
            
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
                o.uv.x = _ColIndex / _ColCount + v.texcoord.x / _ColCount;
                o.uv.y = _RowIndex / _RowCount + v.texcoord.y / _RowCount;
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
}
