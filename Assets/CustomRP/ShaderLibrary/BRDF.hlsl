#ifndef CUSTOM_BRDF_INCLUDE
#define CUSTOM_BRDF_INCLUDE

#define MIN_REFLECTIVITY 0.04

float OneMinusReflectivity(float metallic)
{
	float range = 1.0f - MIN_REFLECTIVITY;
	return range - metallic * range;
}
struct BRDF
{
	float3 diffuse;
	float3 specular;
	float roughness;
};

float SpecularStrength(Surface surface, BRDF brdf, Light light)
{
	float3 H = SafeNormalize(light.direction + surface.viewDirection);
	float NDotH2 = Square(saturate(dot(surface.normalWS, H)));
	float LDotH2 = Square(saturate(dot(light.direction, H)));
	float R2 = Square(brdf.roughness);
	float D2 = Square(NDotH2 * (R2 - 1.0) + 1.00001);
	float Normalization = brdf.roughness * 4.0f + 2.0f;
	return R2 / (D2 * max(0.1, LDotH2) * Normalization);
}

float3 DirectBRDF(Surface surface, BRDF brdf, Light light)
{
	return SpecularStrength(surface, brdf, light) * brdf.specular + brdf.diffuse;
}

BRDF GetBRDF(Surface surface)
{
	BRDF brdf;
	float oneMinusReflectivity = OneMinusReflectivity(surface.metallic);
	brdf.diffuse = surface.color * oneMinusReflectivity;
	brdf.specular = lerp(MIN_REFLECTIVITY, surface.color, surface.metallic);
	float perceptualRoughness = PerceptualSmoothnessToPerceptualRoughness(surface.smoothness);
	brdf.roughness = perceptualRoughness;
	return brdf;
}


#endif