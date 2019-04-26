#ifndef JZYX_ChannelBlend
    #define JZYX_ChannelBlend
    
    sampler2D _ChanBlendMaskTex;
    sampler2D _ChanBlendLut;
    const int KEY_OFFSET_R = 1;
    const int KEY_OFFSET_G = 2;
    const int KEY_OFFSET_B = 4;
    const float LUT_WIDTH = 32;
    half _BlendStrength;
    
    
    
    
    half4 c2v(half4 color)
    {
        return(color - 0.5f) * 4;
    }
    half3 TransformCol(fixed3 origCol, half2 uv)
    {
        
        fixed3 maskCol = tex2D(_ChanBlendMaskTex, uv);
        float bais = 0.5;
        half maskIdx = step(bais, maskCol.r) * 1 + step(bais, maskCol.g) * 2 + step(bais, maskCol.b) * 4;
        maskIdx = (maskIdx) * 3;
        half2 uvR = half2(maskIdx / 32.0, 0.5);
        half2 uvG = half2((maskIdx + 1) / 32.0, 0.5);
        half2 uvB = half2((maskIdx + 2) / 32.0, 0.5);
        half4 ParamR = c2v(tex2D(_ChanBlendLut, uvR));
        half4 ParamG = c2v(tex2D(_ChanBlendLut, uvG));
        half4 ParamB = c2v(tex2D(_ChanBlendLut, uvB));
        fixed3 GrayCol = dot(origCol, fixed3(0.3, 0.6, 0.1));
        fixed3 retCol = fixed3(dot(GrayCol, ParamR.rgb) + ParamR.a, dot(GrayCol, ParamG.rgb) + ParamG.a, dot(GrayCol, ParamB.rgb) + ParamB.a);
        return saturate(lerp(origCol, retCol.rgb, _BlendStrength));
    }
    
    fixed4 TransformCol(fixed4 origCol, half2 uv)
    {
        fixed3 col = TransformCol(origCol.rgb, uv);
        return fixed4(col, origCol.a);
    }
    
    
#endif