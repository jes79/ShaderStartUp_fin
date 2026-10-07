Shader "Custom/LimLightWork"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
                cull off

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

            float rim = abs(dot(normalize(IN.viewDir), o.Normal));
            //o.Emission = pow((1 - rim), 4);
            o.Emission = pow((1 - rim), 4) * float3(abs(sin(_Time.y * 5)), 0, 0);
         }
         ENDCG
    }
        FallBack "Diffuse"
}