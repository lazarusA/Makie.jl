using Pkg
cd(@__DIR__)
Pkg.activate(".")
pkg"registry up"
Pkg.update()
pkg"dev .. ../MakieCore ../CairoMakie ../GLMakie ../WGLMakie ../RPRMakie"
Pkg.precompile()

# copy CHANGELOG file over to documentation
cp(
    joinpath(@__DIR__, "..", "CHANGELOG.md"),
    joinpath(@__DIR__, "src", "news.md"),
    force = true)

using Documenter
using DocumenterVitepress

# include("buildutils/deploydocs.jl")
# include("buildutils/relative_links.jl")
# include("buildutils/redirect_generation.jl")

using CairoMakie
using WGLMakie
using RPRMakie
using GLMakie

# remove GLMakie's renderloop completely, because any time `GLMakie.activate!()`
# is called somewhere, it's reactivated and slows down CI needlessly
function GLMakie.renderloop(screen)
    return
end

include("figure_block.jl")

makedocs(;
    # modules=[Makie],
    sitename="Makie.jl",
    format=DocumenterVitepress.MarkdownVitepress(;
        repo = "https://github.com/MakieOrg/Makie.jl",
        devurl = "dev",
        devbranch = "master",
        deploy_url = "", # for local testing not setting this has broken links with Makie.jl in them
    ),
    pages=[
        "Home" => "index.md",
        "Tutorials" => [
            "tutorials/basic-tutorial.md",
            "tutorials/aspect-tutorial.md",
            "tutorials/layout-tutorial.md",
            "tutorials/scenes.md",
            "tutorials/wrap-existing-recipe.md",
        ],
        "Explanations" => [
            "Backends" => [
                "explanations/backends/backends.md",
                "explanations/backends/cairomakie.md",
                "explanations/backends/glmakie.md",
                "explanations/backends/rprmakie.md",
                "explanations/backends/wglmakie.md",
            ],
            "explanations/animation.md",
            "explanations/blocks.md",
            "explanations/cameras.md",
            "explanations/conversion_pipeline.md",
            "explanations/colors.md",
            "explanations/dim-converts.md",
            "explanations/events.md",
            "explanations/figure.md",
            "explanations/faq.md",
            "explanations/fonts.md",
            "explanations/layouting.md",
            "explanations/headless.md",
            "explanations/inspector.md",
            "explanations/latex.md",
            "explanations/observables.md",
            "explanations/plot_method_signatures.md",
            "explanations/recipes.md",
        ],
        "How-Tos" => [
            "how-to/draw-boxes-around-subfigures.md",
            "how-to/save-figure-with-transparency.md",
        ],
        "API" => "api.md",
        "News" => "news.md",
    ],
    warnonly = true,
    pagesonly = true,
)

# # by making all links relative, we can forgo the `prepath` setting of Franklin
# # which means that files in some `vX.Y.Z` subfolder which happens to be `stable`
# # at the time, link relatively within `stable` so that users don't accidentally
# # copy & paste versioned links if they started out on `stable`
# @info "Rewriting all absolute links as relative"
# make_links_relative()

# generate_redirects([
#     "/reference/index.html" => "/examples/index.html",
#     r"/reference/blocks/(.*)" => s"/examples/blocks/\1",
#     r"/reference/plots/(.*)" => s"/examples/plotting_functions/\1",
#     r"/explanations/(.*)" => s"/documentation/\1",
# ], dry_run = false)

deploydocs(;
    repo="github.com/MakieOrg/Makie.jl",
    devbranch="master",
    push_preview = true,
)
