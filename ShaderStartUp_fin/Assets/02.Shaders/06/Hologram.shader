Shader "Custom/Hologram"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _BumpTex("Normal", 2D) = "bump" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            float rim = abs(dot(IN.viewDir, o.Normal));
            o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex - float2(0, _Time.y * 0.2)));
            o.Emission = c.rgb * float3(abs(sin(_Time.y)), abs(cos(_Time.y)), 0);
            o.Alpha = pow(1 - rim, 2);
        }
        ENDCG
    }
        FallBack "Diffuse"
}