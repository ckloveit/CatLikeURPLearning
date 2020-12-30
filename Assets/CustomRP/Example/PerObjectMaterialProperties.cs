using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PerObjectMaterialProperties : MonoBehaviour
{
    static int baseColorId = Shader.PropertyToID("_BaseColor");
    static int cutoffId = Shader.PropertyToID("_Cutoff");

    [SerializeField]
    Color baseColor = Color.white;
    [SerializeField]
    float cutoff = 0.5f;

    private void Awake()
    {
        OnValidate();

    }
    static MaterialPropertyBlock block;
    private void OnValidate()
    {
        if(block == null)
        {
            block = new MaterialPropertyBlock();
        }

        block.SetColor(baseColorId, baseColor);
        block.SetFloat(cutoffId, cutoff);

        GetComponent<Renderer>().SetPropertyBlock(block);

    }
}
