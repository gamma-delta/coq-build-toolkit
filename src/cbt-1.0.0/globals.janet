# Janet doesn't like circular deps, so declare the global var here. euhg.

(varglobal '*CBT-GLOBALS*
  @{:qud-dlls nil
    :qud-mods-folder nil
    :manifest @{}

    :build-dir "build"
    :resources-dir "src/resources"
    :file-generators @{}
    :hooks @[]})

# TODO: is there a way to sync this from project.janet
# perhaps with use of an ancillary file
(def version "1.0.0")

(defn dbg [text & bodies]
  (def dbg-on (os/getenv "CBT_DEBUG"))
  (if (and dbg-on (not (empty? dbg-on)))
    (apply printf text bodies)
    nil))

(def csproj-template ```
<Project Sdk="Microsoft.NET.Sdk">
	<PropertyGroup>
		<AssemblyName>%s</AssemblyName>
		<PackageId>%s</PackageId>
		<Authors>%s</Authors>
		<TargetFramework>netstandard2.0</TargetFramework>
		<LangVersion>7</LangVersion>
		<GenerateAssemblyInfo>false</GenerateAssemblyInfo>
		<GenerateTargetFrameworkAttribute>false</GenerateTargetFrameworkAttribute>
		<QudLibPath>%s</QudLibPath>
    <DefaultItemExcludes>$(DefaultItemExcludes);%s/**</DefaultItemExcludes>
	</PropertyGroup>
	<ItemGroup>
		<Reference Include="$(QudLibPath)/0Harmony.dll" />
		<Reference Include="$(QudLibPath)/Accessibility.dll" />
		<Reference Include="$(QudLibPath)/AiUnityCommon.dll" />
		<Reference Include="$(QudLibPath)/Assembly-CSharp.dll" />
		<Reference Include="$(QudLibPath)/Assembly-CSharp-firstpass.dll" />
		<Reference Include="$(QudLibPath)/Ionic.Zip.Unity.dll" />
		<Reference Include="$(QudLibPath)/Microsoft.CodeAnalysis.CSharp.dll" />
		<Reference Include="$(QudLibPath)/Microsoft.CodeAnalysis.dll" />
		<Reference Include="$(QudLibPath)/Microsoft.Contracts.dll" />
		<Reference Include="$(QudLibPath)/Mono.Data.Sqlite.dll" />
		<Reference Include="$(QudLibPath)/Mono.Posix.dll" />
		<Reference Include="$(QudLibPath)/Mono.Security.dll" />
		<Reference Include="$(QudLibPath)/Mono.WebBrowser.dll" />
		<Reference Include="$(QudLibPath)/mscorlib.dll" />
		<Reference Include="$(QudLibPath)/NAudio.dll" />
		<Reference Include="$(QudLibPath)/netstandard.dll" />
		<Reference Include="$(QudLibPath)/Newtonsoft.Json.dll" />
		<Reference Include="$(QudLibPath)/NLog.dll" />
		<Reference Include="$(QudLibPath)/Novell.Directory.Ldap.dll" />
		<Reference Include="$(QudLibPath)/nunit.framework.dll" />
		<Reference Include="$(QudLibPath)/NVorbis.dll" />
		<Reference Include="$(QudLibPath)/PlayFab.dll" />
		<Reference Include="$(QudLibPath)/Rewired_Core.dll" />
		<Reference Include="$(QudLibPath)/Rewired_Linux.dll" />
		<Reference Include="$(QudLibPath)/RoslynCSharp.Compiler.dll" />
		<Reference Include="$(QudLibPath)/RoslynCSharp.dll" />
		<Reference Include="$(QudLibPath)/RoslynCSharp.Examples.dll" />
		<Reference Include="$(QudLibPath)/System.AppContext.dll" />
		<Reference Include="$(QudLibPath)/System.Collections.Concurrent.dll" />
		<Reference Include="$(QudLibPath)/System.Collections.dll" />
		<Reference Include="$(QudLibPath)/System.Collections.Immutable.dll" />
		<Reference Include="$(QudLibPath)/System.ComponentModel.Composition.dll" />
		<Reference Include="$(QudLibPath)/System.ComponentModel.DataAnnotations.dll" />
		<Reference Include="$(QudLibPath)/System.Configuration.dll" />
		<Reference Include="$(QudLibPath)/System.Console.dll" />
		<Reference Include="$(QudLibPath)/System.Core.dll" />
		<Reference Include="$(QudLibPath)/System.Data.dll" />
		<Reference Include="$(QudLibPath)/System.Design.dll" />
		<Reference Include="$(QudLibPath)/System.Diagnostics.Debug.dll" />
		<Reference Include="$(QudLibPath)/System.Diagnostics.FileVersionInfo.dll" />
		<Reference Include="$(QudLibPath)/System.Diagnostics.StackTrace.dll" />
		<Reference Include="$(QudLibPath)/System.Diagnostics.Tools.dll" />
		<Reference Include="$(QudLibPath)/System.DirectoryServices.dll" />
		<Reference Include="$(QudLibPath)/System.dll" />
		<Reference Include="$(QudLibPath)/System.Drawing.Design.dll" />
		<Reference Include="$(QudLibPath)/System.Drawing.dll" />
		<Reference Include="$(QudLibPath)/System.EnterpriseServices.dll" />
		<Reference Include="$(QudLibPath)/System.Globalization.dll" />
		<Reference Include="$(QudLibPath)/System.Globalization.Extensions.dll" />
		<Reference Include="$(QudLibPath)/System.IO.Compression.dll" />
		<Reference Include="$(QudLibPath)/System.IO.Compression.FileSystem.dll" />
		<Reference Include="$(QudLibPath)/System.IO.dll" />
		<Reference Include="$(QudLibPath)/System.IO.FileSystem.dll" />
		<Reference Include="$(QudLibPath)/System.IO.FileSystem.Primitives.dll" />
		<Reference Include="$(QudLibPath)/System.Linq.dll" />
		<Reference Include="$(QudLibPath)/System.Linq.Expressions.dll" />
		<Reference Include="$(QudLibPath)/System.Net.Http.dll" />
		<Reference Include="$(QudLibPath)/System.Numerics.dll" />
		<Reference Include="$(QudLibPath)/System.Reflection.dll" />
		<Reference Include="$(QudLibPath)/System.Reflection.Extensions.dll" />
		<Reference Include="$(QudLibPath)/System.Reflection.Metadata.dll" />
		<Reference Include="$(QudLibPath)/System.Reflection.Primitives.dll" />
		<Reference Include="$(QudLibPath)/System.Resources.ResourceManager.dll" />
		<Reference Include="$(QudLibPath)/System.Runtime.dll" />
		<Reference Include="$(QudLibPath)/System.Runtime.Extensions.dll" />
		<Reference Include="$(QudLibPath)/System.Runtime.InteropServices.dll" />
		<Reference Include="$(QudLibPath)/System.Runtime.Numerics.dll" />
		<Reference Include="$(QudLibPath)/System.Runtime.Serialization.dll" />
		<Reference Include="$(QudLibPath)/System.Runtime.Serialization.Formatters.Soap.dll" />
		<Reference Include="$(QudLibPath)/System.Runtime.Serialization.Xml.dll" />
		<Reference Include="$(QudLibPath)/System.Security.Cryptography.Algorithms.dll" />
		<Reference Include="$(QudLibPath)/System.Security.Cryptography.Encoding.dll" />
		<Reference Include="$(QudLibPath)/System.Security.Cryptography.Primitives.dll" />
		<Reference Include="$(QudLibPath)/System.Security.Cryptography.X509Certificates.dll" />
		<Reference Include="$(QudLibPath)/System.Security.dll" />
		<Reference Include="$(QudLibPath)/System.ServiceModel.Internals.dll" />
		<Reference Include="$(QudLibPath)/System.Text.Encoding.CodePages.dll" />
		<Reference Include="$(QudLibPath)/System.Text.Encoding.dll" />
		<Reference Include="$(QudLibPath)/System.Text.Encoding.Extensions.dll" />
		<Reference Include="$(QudLibPath)/System.Threading.dll" />
		<Reference Include="$(QudLibPath)/System.Threading.Tasks.dll" />
		<Reference Include="$(QudLibPath)/System.Threading.Tasks.Extensions.dll" />
		<Reference Include="$(QudLibPath)/System.Threading.Tasks.Parallel.dll" />
		<Reference Include="$(QudLibPath)/System.Threading.Thread.dll" />
		<Reference Include="$(QudLibPath)/System.Transactions.dll" />
		<Reference Include="$(QudLibPath)/System.ValueTuple.dll" />
		<Reference Include="$(QudLibPath)/System.Web.ApplicationServices.dll" />
		<Reference Include="$(QudLibPath)/System.Web.dll" />
		<Reference Include="$(QudLibPath)/System.Web.Services.dll" />
		<Reference Include="$(QudLibPath)/System.Windows.Forms.dll" />
		<Reference Include="$(QudLibPath)/System.Xml.dll" />
		<Reference Include="$(QudLibPath)/System.Xml.Linq.dll" />
		<Reference Include="$(QudLibPath)/System.Xml.ReaderWriter.dll" />
		<Reference Include="$(QudLibPath)/System.Xml.XDocument.dll" />
		<Reference Include="$(QudLibPath)/System.Xml.XmlDocument.dll" />
		<Reference Include="$(QudLibPath)/System.Xml.XPath.dll" />
		<Reference Include="$(QudLibPath)/System.Xml.XPath.XDocument.dll" />
		<Reference Include="$(QudLibPath)/Trivial.CodeSecurity.dll" />
		<Reference Include="$(QudLibPath)/Trivial.Mono.Cecil.dll" />
		<Reference Include="$(QudLibPath)/Trivial.Mono.Cecil.Mdb.dll" />
		<Reference Include="$(QudLibPath)/Trivial.Mono.Cecil.Pdb.dll" />
		<Reference Include="$(QudLibPath)/Unity.Analytics.DataPrivacy.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.AccessibilityModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.Advertisements.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.AIModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.AndroidJNIModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.AnimationModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.AssetBundleModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.AudioModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.ClothModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.ClusterInputModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.ClusterRendererModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.CoreModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.CrashReportingModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.DirectorModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.DSPGraphModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.GameCenterModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.GridModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.HotReloadModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.ImageConversionModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.IMGUIModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.InputLegacyModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.InputModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.JSONSerializeModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.LocalizationModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.Monetization.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.ParticleSystemModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.PerformanceReportingModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.Physics2DModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.PhysicsModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.ProfilerModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.Purchasing.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.ScreenCaptureModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.SharedInternalsModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.SpatialTracking.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.SpriteMaskModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.SpriteShapeModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.StreamingModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.SubstanceModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.SubsystemsModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.TerrainModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.TerrainPhysicsModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.TestRunner.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.TextCoreModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.TextRenderingModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.TilemapModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.TLSModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UI.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UIElementsModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UIElementsNativeModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UIModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UmbraModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UNETModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UnityAnalyticsModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UnityConnectModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UnityTestProtocolModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UnityWebRequestAssetBundleModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UnityWebRequestAudioModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UnityWebRequestModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UnityWebRequestTextureModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.UnityWebRequestWWWModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.VehiclesModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.VFXModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.VideoModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.VRModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.WindModule.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.XR.LegacyInputHelpers.dll" />
		<Reference Include="$(QudLibPath)/UnityEngine.XRModule.dll" />
		<Reference Include="$(QudLibPath)/Unity.MemoryProfiler.dll" />
		<Reference Include="$(QudLibPath)/UnityMultiSelectDropdown.dll" />
		<Reference Include="$(QudLibPath)/Unity.Timeline.dll" />
	</ItemGroup>
</Project>
```)
