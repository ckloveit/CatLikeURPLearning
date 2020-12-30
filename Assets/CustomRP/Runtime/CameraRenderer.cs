using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public partial class CameraRenderer
{
    ScriptableRenderContext context;

    Camera camera;

    CullingResults cullingResults;

    const string bufferName = "Render Camera";

    static ShaderTagId unlitShaderTagId = new ShaderTagId("SRPDefaultUnlit");

    CommandBuffer cmdBuffer = new CommandBuffer
    {
      name = bufferName
    };

    public void Render(ScriptableRenderContext context, Camera camera, bool useDynamicBatching, bool useGPUInstancing)
    {
        this.context = context;
        this.camera = camera;
        PrepareBuffer();
        PrepareForSceneWindow();
        if (!Cull())
            return;

        Setup();

        DrawVisiableGeometry(useDynamicBatching, useGPUInstancing);

#if UNITY_EDITOR
        DrawUnsupportedShaders();
        DrawGizmos();
#endif
        Submit();
    }
    bool Cull()
    {
        if(camera.TryGetCullingParameters(out ScriptableCullingParameters cullingParameters))
        {
            cullingResults = context.Cull(ref cullingParameters);
            return true;
        }
        return false;
    }
    void Setup()
    {
        context.SetupCameraProperties(camera);
        CameraClearFlags flags = camera.clearFlags;
        cmdBuffer.ClearRenderTarget(flags <= CameraClearFlags.Depth, 
            flags == CameraClearFlags.Color, 
            flags == CameraClearFlags.Color ? camera.backgroundColor.linear : Color.clear);

        cmdBuffer.BeginSample(SampleName);
        ExecuteBuffer();

    }
    private void DrawVisiableGeometry(bool useDynamicBatching, bool useGPUInstancing)
    {
        var sortingSettings = new SortingSettings(camera)
        {
            criteria = SortingCriteria.CommonOpaque
        };

        var drawingSettings = new DrawingSettings(unlitShaderTagId, sortingSettings);
        drawingSettings.enableDynamicBatching = useDynamicBatching;
        drawingSettings.enableInstancing = useGPUInstancing;

        var filteringSettings = new FilteringSettings(RenderQueueRange.opaque);

        context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSettings);
      
        context.DrawSkybox(camera);

        sortingSettings.criteria = SortingCriteria.CommonTransparent;
        drawingSettings.sortingSettings = sortingSettings;
        filteringSettings.renderQueueRange = RenderQueueRange.transparent;

        context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSettings);
   
    }
    
    
    void ExecuteBuffer()
    {
        context.ExecuteCommandBuffer(cmdBuffer);
        cmdBuffer.Clear();
    }
    void Submit()
    {
        cmdBuffer.EndSample(SampleName);
        ExecuteBuffer();
        context.Submit();
    }
}
