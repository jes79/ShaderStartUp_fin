Shader "Custom/Refraction"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _RefStrength("Reflection Strength", Range(0,0.1)) = 0.05
        _RefSpeed("Reflection Speed", float) = 0.1 //
    }
        SubShader
        {
            // 다른 일반 오브젝트들보다 나중에 그려져야 배경캡쳐가 되므로 Transparent 와 zwrite off를 사용한다.
            Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
            zwrite off

            GrabPass { }        // 화면 캡쳐

            CGPROGRAM
            #pragma surface surf nolight noambient alpha:fade
            #pragma target 3.0

            sampler2D _GrabTexture;
            sampler2D _MainTex;
            float _RefStrength;
            float _RefSpeed;  //

            struct Input
            {
                float4 color:COLOR;
                float4 screenPos;		// 현재 화면의 UV
                float2 uv_MainTex;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                float4 ref = tex2D(_MainTex, float2(IN.uv_MainTex.x, IN.uv_MainTex.y + _Time.y * _RefSpeed));//float2(IN.uv_MainTex.x, IN.uv_MainTex.y + _Time.y * _RefSpeed) //IN.uv_MainTex

                // 카메라의 거리 영향을 제거하기 위함.
                float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
                o.Emission =  tex2D(_GrabTexture, (screenUV.xy + ref.x * _RefStrength)); //1 -
            }

            float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten)
            {
                return float4(0, 0, 0, 1);
            }
            //
            ENDCG
        }
            FallBack "Regacy Shaders/Transparent/Vertexlit"
}